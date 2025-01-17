import 'package:uuid/uuid.dart';

Object? idOrUnderscoreId(
  Map<dynamic, dynamic> map,
  String string,
) {
  return map['id'] ?? (map['_id'] as UuidValue).uuid;
}

DateTime fromDateTime(DateTime value) => value;

Object? createdAtOrCreatedUnderscoreAt(
  Map<dynamic, dynamic> map,
  String string,
) {
  return map['createdAt'] ?? map['created_at'];
}

Object? updatedAtOrUpdatedUnderscoreAt(
  Map<dynamic, dynamic> map,
  String string,
) {
  return map['updatedAt'] ?? map['updated_at'];
}

Object? userIdOrUserUnderscoreId(
  Map<dynamic, dynamic> map,
  String string,
) {
  return map['user_id'] ?? (map['userId'] as UuidValue).uuid;
}
