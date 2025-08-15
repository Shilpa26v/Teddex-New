import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityHelper {
  bool hasInternet = true;
  StreamSubscription? _subscription;
  StreamController<bool>? _connectivityChangeStreamController;

  Stream<bool> get onConnectivityChanged =>
      (_connectivityChangeStreamController ??= StreamController<bool>.broadcast()).stream;

  void initialize() {
    // Cancel any previous subscription
    dispose();

    // Initial connectivity check
    Connectivity().checkConnectivity().then(_onConnectivityChange);

    // Listen to ongoing connectivity changes
    _subscription = Connectivity().onConnectivityChanged.listen(_onConnectivityChange);
  }

  void _onConnectivityChange(List<ConnectivityResult> result) {
    hasInternet = result.first != ConnectivityResult.none;
    _connectivityChangeStreamController?.add(hasInternet);
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _connectivityChangeStreamController?.close();
    _connectivityChangeStreamController = null;
  }
}
