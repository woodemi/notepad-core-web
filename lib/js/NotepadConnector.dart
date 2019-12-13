import 'dart:typed_data';

import '../woodemi/Woodemi.dart';
import 'common_js.dart';
import 'notepad_core_js.dart';

final notepadConnector = NotepadConnector._();

const _tag = 'NotepadConnector';

class NotepadConnector {
  NotepadConnector._();

  Future<BluetoothDevice> requestDevice() {
    print('$_tag:requestDevice');
    return Bluetooth.requestDevice(ScanOptions(
      optionalServices: [SERV_COMMAND.serviceUuid()],
      acceptAllDevices: true,
    )).toFuture();
  }

  void connect(BluetoothDevice device) {
    print('$_tag:connect');
    _connect(device.gatt);
  }

  void disconnect() {
    print('$_tag:disconnect');
    connectGatt?.disconnect();
    connectGatt = null;
  }

  BluetoothRemoteGATTServer connectGatt;

  Future<void> _connect(BluetoothRemoteGATTServer gatt) async {
    connectGatt = gatt;
    try {
      await connectGatt.connect().toFuture();
      await completeConnection();
    } catch (e) {
      print('error $e');
      connectGatt = null;
    }
  }

  Future<void> completeConnection() async {
    var service = await connectGatt
        .getPrimaryService(SERV_COMMAND.serviceUuid())
        .toFuture();
    var characteristic = await service
        .getCharacteristic(CHAR__COMMAND_REQUEST.characteristicUuid())
        .toFuture();
    await characteristic
        .writeValue(Uint8List.fromList([0x01, 0x0A, 0x00, 0x00, 0x00, 0x01]))
        .toFuture();
  }
}