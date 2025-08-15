import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:teddex/database/app_database.dart';
import 'package:teddex/generated/l10n.dart';
import 'package:teddex/helpers/helpers.dart';
import 'package:teddex/network/api_client.dart';
import 'package:teddex/pref/app_pref.dart';
import 'package:teddex/resources/resources.dart';
import 'package:teddex/ui/auth/create_account/create_account_view.dart';
import 'package:teddex/ui/auth/login/login_view.dart';
import 'package:teddex/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ApiException implements Exception {
  final String message;

  ApiException(this.message);
}

abstract class BaseCubit<State extends Object?> extends Cubit<State> {
  final BuildContext context;
  EventBus eventBus = GetIt.I.get<EventBus>();
  ApiClient apiClient = GetIt.I.get<ApiClient>();
  AppDatabase database = GetIt.I.get<AppDatabase>();
  ConnectivityHelper connectivityHelper = GetIt.I.get<ConnectivityHelper>();
  final List<StreamSubscription> listStreamSubscription = [];

  BaseCubit(this.context, State initialState) : super(initialState);

  @override
  Future<void> close() {
    for (var element in listStreamSubscription) {
      element.cancel();
    }
    return super.close();
  }

  static int _noOfApiCalls = 0;

  Future<T?> processApi<T>(Future<T> Function() request, {bool doShowLoader = false}) async {
    try {
      if (_noOfApiCalls == 0 && !connectivityHelper.hasInternet && doShowLoader) {
        Timer.run(() => showErrorMessage(S.current.errorNoInternet));
      }
      if (doShowLoader && connectivityHelper.hasInternet) _showLoader(context);
      var response = await request();
      if (doShowLoader && connectivityHelper.hasInternet) _hideLoader(context);
      return response;
    } on DioError catch (error) {
      if (doShowLoader) _hideLoader(context);
      "processApi => DioError :: request -> ${error.requestOptions.uri}".error();
      "processApi => DioError :: ${error.type} -> ${error.message}".error();
      switch (error.type) {
        case DioErrorType.connectionTimeout:
        case DioErrorType.connectionError:
        case DioErrorType.sendTimeout:
        case DioErrorType.receiveTimeout:
          break;
        case DioErrorType.badResponse:
           _onHttpError(context, error);
          final json = error.response?.data;
          throw ApiException(json["message"]);
        case DioErrorType.cancel:
          break;
        case DioErrorType.unknown:
          rethrow;
        case DioErrorType.badCertificate:
          // TODO: Handle this case.
          break;

      }
    } on SocketException catch (socketException) {
      if (doShowLoader) _hideLoader(context);
      "processApi => SocketException :: $socketException".error();
    } catch (error, stackTrace) {
      if (doShowLoader) _hideLoader(context);
      "processApi => $error".error();
      stackTrace.error();
    }
    return null;
  }

  void _showLoader(BuildContext context) {
    if (_noOfApiCalls == 0) AppLoader.show(context);
    _noOfApiCalls++;
  }

  void _hideLoader(BuildContext context) {
    _noOfApiCalls--;
    if (_noOfApiCalls == 0) AppLoader.dismiss(context);
  }

  void _onHttpError(BuildContext context, DioError error) {
    final json = error.response?.data;
    switch (error.response?.statusCode) {
      case 500: // ServerError
      case 400: // BadRequest
      case 403: // Unauthorized
      case 404: // NotFound
      case 409: // Conflict
      case 423: // Blocked
      case 402: // Payment required
        if (json is Map<String, dynamic> && json['message'] != null) {
          showErrorMessage(json['message']);
        }
        break;
      case 422: // InValidateData
        if (json is Map<String, dynamic>) {
          if (json['errors'] == null) {
            if (json['message'] != null) {
               showErrorMessage(json['message'] ?? "");
              // CommonUtils.showErrorDialog(context, json['message']);
            }
          } else {
            String errors = "";
            (json['errors'] as Map<String, dynamic>).forEach((k, v) {
              errors += "• $v\n";
            });
            // showErrors(errors);
          }
        }
        break;
      case 401: // Unauthenticated
        onUserUnauthenticated();
        break;
      case 426: // ForceUpdate
        break;
      case 503:
      case 524: // ServerTimeout
      case 521: // Web server is down debugPrint
      default:
        return showErrorMessage(S.current.errorSomethingWentWrong);
    }
  }

  void onUserUnauthenticated() {
    AppPref.clear();
    Navigator.of(context).pushNamedAndRemoveUntil(LoginView.routeName, (route) => false);
  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: AppColor.red),
          ),
        ),
      );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: AppColor.green),
          ),
        ),
      );
  }

  void showErrors(String error) {
    showAppDialog(
      context: context,
      title: S.current.titleOops,
      content: error,
      negativeButton: AppDialogButton(label: S.current.btnOkay, onPressed: null),
    );
  }

  bool userLoggedIn() {
    var isLogin = AppPref.isLogin;
    if (!isLogin) {
      showAppDialog(
        context: context,
        title: S.current.titleLoginRequired,
        content: S.current.descLoginRequired,
        positiveButton: AppDialogButton(
          label: S.current.btnLogin,
          onPressed: () {
            Navigator.of(context).popAndPushNamed(LoginView.routeName);
          },
        ),
        otherButton: AppDialogButton(
          label: S.current.btnCreateAccount,
          onPressed: () {
            Navigator.of(context).popAndPushNamed(CreateAccountView.routeName);
          },
        ),
        negativeButton: AppDialogButton(label: S.current.btnCancel, onPressed: null),
        barrierDismissible: false,
      );
    }
    return isLogin;
  }
}

abstract class DataEvent<T> {
  DataEvent();

  factory DataEvent.success(T data) => SuccessEvent._(data);

  factory DataEvent.failure([Exception? exception]) => FailureEvent._(exception);
}

class SuccessEvent<T> extends DataEvent<T> {
  T data;

  SuccessEvent._(this.data);
}

class FailureEvent<T> extends DataEvent<T> {
  final Exception? exception;

  FailureEvent._([this.exception]);
}

class NoInternetException implements Exception {}
