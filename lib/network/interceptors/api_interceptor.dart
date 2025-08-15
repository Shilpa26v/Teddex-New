import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:teddex/helpers/src/logger.dart';
import 'package:teddex/network/models/model.dart';
import 'package:teddex/pref/app_pref.dart';

import '../encryption.dart';

class ApiInterceptor extends InterceptorsWrapper {
  final bool doEncryption;
  final bool doWriteLog;

  ApiInterceptor({this.doEncryption = true, this.doWriteLog = true});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (AppPref.userToken.isNotEmpty) {
      options.headers["token"] = AppPref.userToken;
    }
    options.headers["currency"] = AppPref.currencySymbol;
    if (doWriteLog) {
      Log.debug("<-------------------------------------- Request Options -------------------------------------->");
      Log.debug("Request :: ${options.method} -> ${options.uri}");
      Log.debug("Data ::");
      Log.debug(options.data);
      Log.debug("QueryParameters ::");
      Log.debug(options.queryParameters);
      Log.debug("Headers ::");
      options.headers.forEach((key, value) => Log.debug("$key: $value"));
    }
    if (options.data is Map<String, dynamic> && doEncryption) {
      var encrypted = Encryption.instance.encryption(jsonEncode(options.data));
      options.data = encrypted.toJson();
      if (doWriteLog) Log.debug("Encrypted Data :: ${options.data}");
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    Log.error(err.response);
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (doWriteLog) {
      Log.success("<-------------------------------------- Response -------------------------------------->");
      Log.success("Response :: ${response.requestOptions.method} -> ${response.requestOptions.uri}");
      Log.success("Data ::");
      Log.success(response.data);
    }
    if (response.data is Map<String, dynamic> && doEncryption) {
      var encryptResp = EncryptData.fromJson(response.data);
      var decrypted = Encryption.instance.decryption(encryptResp);
      if (doWriteLog) {
        Log.success("Decrypted ::");
        Log.success(decrypted);
      }
      var decryptedData = jsonDecode(decrypted);
      response.data = decryptedData;
      if (doWriteLog) {
        Log.success("Decrypted Data ::");
        Log.success(response.data);
      }
    }
    super.onResponse(response, handler);
  }
}
