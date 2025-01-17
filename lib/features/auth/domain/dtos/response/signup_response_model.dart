import 'package:equatable/equatable.dart';

import '../../../../../core/typedefs/typedefs.dart';

class SignupResponseModel extends Equatable {
  const SignupResponseModel({required this.id});

  final String id;

  @override
  List<Object> get props => [id];

  MapData toJson() {
    return {'id': id};
  }
}
