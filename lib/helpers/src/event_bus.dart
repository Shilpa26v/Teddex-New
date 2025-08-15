import 'dart:async';

import 'package:flutter/material.dart';

class BusEvent<T> {
  String tag;
  T? data;

  BusEvent(this.tag, {this.data});

  @override
  String toString() => "$tag -> $data";
}

class EventBus {
  final StreamController<BusEvent> _streamController;
  final void Function(BusEvent event) logPrinter;

  EventBus({bool sync = false, this.logPrinter = _defaultLogPrinter})
      : _streamController = StreamController<BusEvent>.broadcast(sync: sync);

  EventBus.customController(StreamController<BusEvent> controller, {this.logPrinter = _defaultLogPrinter})
      : _streamController = controller;

  StreamSubscription<BusEvent> listen(
    Function(BusEvent event) onEvent, {
    Function? onError,
    Function()? onDone,
    bool? cancelOnError,
  }) {
    return _streamController.stream.listen(onEvent, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  void fire<T extends Object?>(String tag, [T? data]) {
    _streamController.add(BusEvent(tag, data: data));
  }

  void destroy() {
    _streamController.close();
  }

  static void _defaultLogPrinter(BusEvent event) {
    debugPrint("${event.tag} -> ${event.data}");
  }
}
