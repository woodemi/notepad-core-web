import 'dart:typed_data';

import 'package:notepad_core_web/NotepadClient.dart';
import 'package:tuple/tuple.dart';

import 'Woodemi.dart';

class WoodemiClient extends NotepadClient {
  @override
  Tuple2<String, String> get commandRequestCharacteristic => const Tuple2(SERV__COMMAND, CHAR__COMMAND_REQUEST);

  @override
  Tuple2<String, String> get commandResponseCharacteristic => const Tuple2(SERV__COMMAND, CHAR__COMMAND_RESPONSE);

  @override
  Future<void> completeConnection() async {
    await _checkAccess();
  }

  Future<void> _checkAccess() async {
    var request = Uint8List.fromList([0x01, 0x0A, 0x00, 0x00, 0x00, 0x01]);
    await notepadType.sendRequestAsync('Command', commandRequestCharacteristic, request);
  }
}