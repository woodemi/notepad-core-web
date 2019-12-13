import 'common_js.dart';
import 'notepad_core_js.dart';

final notepadConnector = NotepadConnector._();

const _tag = 'NotepadConnector';

class NotepadConnector {
  NotepadConnector._();

  Future<void> requestDevice() {
    print('$_tag:requestDevice');
    var requestDevice = Bluetooth.requestDevice(ScanOptions(
      acceptAllDevices: true,
    ));
    print('requestDevice $requestDevice');
    requestDevice.then((result) {
      print('result $result');
    }, (error) {
      print('error $error');
    });
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
      var server = await connectGatt.connect().toFuture();
      print('server $server');
    } catch (e) {
      print('error $e');
      connectGatt = null;
    }
  }
}