import 'package:equatable/equatable.dart';

class FindUserByIdRequestModel extends Equatable {
  const FindUserByIdRequestModel({required this.userId});

  final String userId;

  @override
  List<Object> get props => [userId];
}
