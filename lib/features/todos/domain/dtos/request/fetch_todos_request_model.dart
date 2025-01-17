import 'package:equatable/equatable.dart';

import '../../../../../core/typedefs/typedefs.dart';

class FetchTodosRequestModel extends Equatable {
  const FetchTodosRequestModel({
    required this.userId,
    required this.match,
    required this.sort,
  });

  final String userId;
  final MapData match;
  final MapData sort;

  @override
  List<Object> get props => [userId, match, sort];
}
