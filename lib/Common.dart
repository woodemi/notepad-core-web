import 'NotepadClient.dart';
import 'js/notepad_core_js.dart';
import 'woodemi/WoodemiClient.dart';

NotepadClient create(BluetoothDevice device) {
  // TODO manufacturerData
  // FIXME Without `as NotepadClient` compiles error via dart2js
  return WoodemiClient() as NotepadClient;
}