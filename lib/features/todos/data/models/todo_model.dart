import 'package:json_annotation/json_annotation.dart';

import '../../../../core/converters/converters.dart';
import '../../domain/entities/todo_entity.dart';

part 'todo_model.g.dart';

@JsonSerializable(createToJson: false)
class TodoModel extends Todo {
  const TodoModel({
    required super.id,
    required super.description,
    super.completed,
    required super.userId,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);

  @JsonKey(readValue: idOrUnderscoreId)
  @override
  String get id;
  @override
  String get description;
  @override
  bool get completed;
  @JsonKey(readValue: userIdOrUserUnderscoreId)
  @override
  String get userId;
  @JsonKey(fromJson: fromDateTime, readValue: createdAtOrCreatedUnderscoreAt)
  @override
  DateTime get createdAt;
  @JsonKey(fromJson: fromDateTime, readValue: updatedAtOrUpdatedUnderscoreAt)
  @override
  DateTime get updatedAt;
}
