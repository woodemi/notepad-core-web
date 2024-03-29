import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:tuple/tuple.dart';

import 'NotepadClient.dart';
import 'NotepadCommand.dart';
import 'js/BleType.dart';

class NotepadType {
  final NotepadClient _notepadClient;
  final BleType _bleType;

  NotepadType(this._notepadClient, this._bleType) {
    _notepadClient.notepadType = this;
  }

  Future<void> configCharacteristics() async {
    for (var serviceCharacteristic in _notepadClient.inputIndicationCharacteristics) {
      print('configInputCharacteristic $serviceCharacteristic, indication');
      await _bleType.setNotifiable(serviceCharacteristic);
    }
  }

  Future<void> sendRequestAsync(String messageHead, Tuple2<String, String> serviceCharacteristic, Uint8List request) async {
    await _bleType.writeValue(serviceCharacteristic, request);
    print('on${messageHead}Send: ${hex.encode(request)}');
  }

  Stream<Uint8List> receiveValue(Tuple2<String, String> serviceCharacteristic) => _bleType.inputValueStream
      .where((cv) => cv.item1 == serviceCharacteristic.item2)
      .map((cv) => cv.item2);

  Future<Uint8List> receiveResponseAsync(String messageHead, Tuple2<String, String> serviceCharacteristic, Predicate intercept) async {
    var response = await receiveValue(serviceCharacteristic).firstWhere(intercept);
    print('on${messageHead}Receive: ${hex.encode(response)}');
    return response;
  }

  Future<T> executeCommand<T>(NotepadCommand<T> command) async {
    await sendRequestAsync('Command', _notepadClient.commandRequestCharacteristic, command.request);
    var response = await receiveResponseAsync('Command', _notepadClient.commandResponseCharacteristic, command.intercept);
    return command.handle(response);
  }
}