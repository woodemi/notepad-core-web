import 'package:tuple/tuple.dart';

import 'NotepadType.dart';

abstract class NotepadClient {
  Tuple2<String, String> get commandRequestCharacteristic;

  Tuple2<String, String> get commandResponseCharacteristic;

  NotepadType notepadType;

  Future<void> completeConnection();
}