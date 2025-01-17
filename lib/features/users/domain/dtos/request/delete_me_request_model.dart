import 'package:equatable/equatable.dart';

class DeleteMeRequestModel extends Equatable {
  const DeleteMeRequestModel({required this.userId});

  final String userId;

  @override
  List<Object> get props => [userId];
}
