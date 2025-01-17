import 'package:fpdart/fpdart.dart';

import '../errors/failures.dart';

typedef MapData = Map<String, dynamic>;
typedef EitherOr<T> = Either<Failure, T>;
typedef FutureEither<T> = Future<EitherOr<T>>;
