// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: idOrUnderscoreId(json, 'id') as String,
      username: json['username'] as String,
      email: json['email'] as String,
      createdAt: fromDateTime(
          createdAtOrCreatedUnderscoreAt(json, 'createdAt') as DateTime),
      updatedAt: fromDateTime(
          updatedAtOrUpdatedUnderscoreAt(json, 'updatedAt') as DateTime),
    );
