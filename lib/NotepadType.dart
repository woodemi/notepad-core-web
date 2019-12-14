import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:tuple/tuple.dart';

import 'NotepadClient.dart';
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
}