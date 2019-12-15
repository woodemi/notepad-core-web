@JS()
library common_js;

import 'dart:async';

import 'package:js/js.dart';
import 'package:js/js_util.dart' as js_util;

@JS()
class Promise<T> {
  external Promise(void executor(void resolve(T result), Function reject));

  external Promise then(void onFulfilled(T result), [Function onRejected]);
}

extension Promise2Future<T> on Promise<T> {
  Future<T> toFuture() {
    final c = Completer<T>();
    then(allowInterop(c.complete), allowInterop(c.completeError));
    return c.future;
  }
}

// Utility method to mask the typed JS facade as JSObject
T callMethod<T>(object, String method, List args) =>
    js_util.callMethod(object, method, args) as T;

// Utility method to mask the typed JS facade as JSObject
T getProperty<T>(object, String name) =>
    js_util.getProperty(object, name) as T;