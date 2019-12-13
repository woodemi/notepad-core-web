@JS()
library common_js;

import 'dart:async';

import 'package:js/js.dart';

@JS()
class Promise<T> {
  external Promise(void executor(void resolve(T result), Function reject));

  external Promise then(void onFulfilled(T result), [Function onRejected]);
}

extension Promise2Future<T> on Promise<T> {
  Future<T> toFuture() {
    final c = Completer<T>();
    this.then(
        (result) => c.complete(result), (error) => c.completeError(error));
    return c.future;
  }
}
