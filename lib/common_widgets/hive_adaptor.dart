import 'package:hive/hive.dart';

class ListOfMapsAdapter extends TypeAdapter<List<Map<String, dynamic>>> {
  @override
  final typeId = 0;

  @override
  List<Map<String, dynamic>> read(BinaryReader reader) {
    final length = reader.readByte();
    return List.generate(
      length,
      (_) {
        final mapLength = reader.readByte();
        final map = <String, dynamic>{};
        for (var i = 0; i < mapLength; i++) {
          final key = reader.readString();
          final value = reader.read();
          map[key] = value;
        }
        return map;
      },
    );
  }

  @override
  void write(BinaryWriter writer, List<Map<String, dynamic>> obj) {
    writer.writeByte(obj.length);
    for (var map in obj) {
      writer.writeByte(map.length);
      map.forEach((key, value) {
        writer.writeString(key);
        writer.write(value);
      });
    }
  }
}
