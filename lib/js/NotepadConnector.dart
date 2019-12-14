import 'dart:typed_data';

import '../Common.dart';
import '../NotepadClient.dart';
import '../NotepadType.dart';
import '../woodemi/Woodemi.dart';
import 'BleType.dart';
import 'common_js.dart';
import 'notepad_core_js.dart';

final notepadConnector = NotepadConnector._();

const _tag = 'NotepadConnector';

class NotepadConnector {
  NotepadConnector._();

  Future<BluetoothDevice> requestDevice() {
    print('$_tag:requestDevice');
    return Bluetooth.requestDevice(ScanOptions(
      optionalServices: [SERV__COMMAND.serviceUuid()],
      acceptAllDevices: true,
    )).toFuture();
  }

  BluetoothRemoteGATTServer _connectGatt;
  NotepadClient _notepadClient;
  NotepadType _notepadType;

  void connect(BluetoothDevice device) {
    print('$_tag:connect');
    _connectGatt = device.gatt;
    _notepadClient = create(device);
    _notepadType = NotepadType(_notepadClient, BleType(device.gatt));
    _connect(device.gatt);
  }

  void disconnect() {
    print('$_tag:disconnect');
    _connectGatt?.disconnect();
    _connectGatt = null;
  }

  Future<void> _connect(BluetoothRemoteGATTServer gatt) async {
    try {
      await _connectGatt.connect().toFuture();
      await _notepadClient.completeConnection();
    } catch (e) {
      print('error $e');
      _connectGatt = null;
      _notepadClient = null;
      _notepadType = null;
    }
  }

  Future<void> completeConnection() async {
    var service = await _connectGatt
        .getPrimaryService(SERV__COMMAND.serviceUuid())
        .toFuture();
    var characteristic = await service
        .getCharacteristic(CHAR__COMMAND_REQUEST.characteristicUuid())
        .toFuture();
    await characteristic
        .writeValue(Uint8List.fromList([0x01, 0x0A, 0x00, 0x00, 0x00, 0x01]))
        .toFuture();
  }
}