import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:teddex/resources/resources.dart';

import 'app/app.dart';
import 'database/app_database.dart';
import 'helpers/helpers.dart';
import 'network/api_client.dart';
import 'pref/app_pref.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: AppColor.black_30,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarContrastEnforced: false,
      systemStatusBarContrastEnforced: false,
    ),
  );
  await AppPref.init();
  var appDatabase = await AppDatabase.getInstance("tedeex.db");
  GetIt.I.registerSingleton<ConnectivityHelper>(ConnectivityHelper());
  GetIt.I.registerSingleton<EventBus>(EventBus(logPrinter: Log.debug));
  GetIt.I.registerSingleton<AppDatabase>(appDatabase);
  GetIt.I.registerSingleton<ApiClient>(ApiClient());
  EquatableConfig.stringify = true;

  runApp(
    BlocProvider(
      create: (context) => AppCubit(context),
      lazy: false,
      child: const TedeexEmbroideryApp(),
    ),
  );
}

void downloadCallback(id, status, progress) {
  debugPrint("FlutterDownloader => $id => $status => $progress");
}
