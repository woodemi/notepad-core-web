import 'dart:typed_data';

import 'package:tuple/tuple.dart';

import '../NotepadClient.dart';
import 'Woodemi.dart';

enum AccessResult {
  Denied,      // Device claimed by other user
  Confirmed,   // Access confirmed, indicating device not claimed by anyone
  Unconfirmed, // Access unconfirmed, as user doesn't confirm before timeout
  Approved     // Device claimed by this user
}

class WoodemiClient extends NotepadClient {
  @override
  Tuple2<String, String> get commandRequestCharacteristic => const Tuple2(SERV__COMMAND, CHAR__COMMAND_REQUEST);

  @override
  Tuple2<String, String> get commandResponseCharacteristic => const Tuple2(SERV__COMMAND, CHAR__COMMAND_RESPONSE);

  @override
  List<Tuple2<String, String>> get inputIndicationCharacteristics => [
    commandResponseCharacteristic,
  ];

  @override
  Future<void> completeConnection() async {
    var accessResult = await _checkAccess(defaultAuthToken, 10);
    print('_checkAccess $accessResult');
  }

  Future<AccessResult> _checkAccess(Uint8List authToken, int seconds) async {
    var command = WoodemiCommand(
      request: Uint8List.fromList([0x01, seconds] + authToken),
      intercept: (data) => data.first == 0x02,
      handle: (data) => data[1],
    );
    var response = await notepadType.executeCommand(command);
    switch(response) {
      case 0x00:
        return AccessResult.Denied;
      case 0x01:
        var confirm = await notepadType.receiveResponseAsync('Confirm',
            commandResponseCharacteristic, (value) => value.first == 0x03);
        return confirm[1] == 0x00 ? AccessResult.Confirmed : AccessResult.Unconfirmed;
      case 0x02:
        return AccessResult.Approved;
      default:
        throw Exception('Unknown error');
    }
  }
}