// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoModel _$TodoModelFromJson(Map<String, dynamic> json) => TodoModel(
      id: idOrUnderscoreId(json, 'id') as String,
      description: json['description'] as String,
      completed: json['completed'] as bool? ?? false,
      userId: userIdOrUserUnderscoreId(json, 'userId') as String,
      createdAt: fromDateTime(
          createdAtOrCreatedUnderscoreAt(json, 'createdAt') as DateTime),
      updatedAt: fromDateTime(
          updatedAtOrUpdatedUnderscoreAt(json, 'updatedAt') as DateTime),
    );
