import 'common_js.dart';
import 'notepad_core_js.dart';

final notepadConnector = NotepadConnector._();

const _tag = 'NotepadConnector';

class NotepadConnector {
  NotepadConnector._();

  Future<BluetoothDevice> requestDevice() {
    print('$_tag:requestDevice');
    return Bluetooth.requestDevice(ScanOptions(
      acceptAllDevices: true,
    )).toFuture();
  }
}
