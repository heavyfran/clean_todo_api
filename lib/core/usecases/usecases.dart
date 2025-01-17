import '../typedefs/typedefs.dart';

abstract interface class Usecase<ReturnType, ParamsType> {
  FutureEither<ReturnType> call(ParamsType params);
}
