import 'package:clean_todo_api/core/db/db_connection.dart';
import 'package:clean_todo_api/core/services/bearer_authenticator.dart';
import 'package:clean_todo_api/core/services/jwt_service.dart';
import 'package:clean_todo_api/core/services/password_manager.dart';
import 'package:clean_todo_api/core/validators/input_validators.dart';
import 'package:clean_todo_api/env/env.dart';
import 'package:clean_todo_api/features/users/data/datasources/mongo_user_data_source.dart';
import 'package:clean_todo_api/features/users/data/datasources/postgres_user_data_source.dart';
import 'package:clean_todo_api/features/users/data/datasources/user_data_source.dart';
import 'package:clean_todo_api/features/users/data/repositories/user_repository_impl.dart';
import 'package:clean_todo_api/features/users/domain/presenters/user_presenter.dart';
import 'package:clean_todo_api/features/users/domain/repositories/user_repository.dart';
import 'package:clean_todo_api/features/users/domain/usecases/usecases.dart';
import 'package:clean_todo_api/features/users/presentation/presenters/user_presenter_impl.dart';
import 'package:dart_frog/dart_frog.dart';

PasswordManager? _passwordManager;
JwtService? _jwtService;
InputValidators? _inputValidators;
BearerAuthenticator? _bearerAuthenticator;
FindUserByIdUsecase? _findUserByIdUsecase;
UserRepository? _userRepository;
UserPresenter? _userPresenter;
UserDataSource? _userDataSource;

Handler middleware(Handler handler) {
  return handler
      .use(
        provider<BearerAuthenticator>(
          (context) => _bearerAuthenticator ??= BearerAuthenticator(
            jwtService: context.read<JwtService>(),
            findUserByIdUsecase: context.read<FindUserByIdUsecase>(),
          ),
        ),
      )
      .use(
        provider<FindUserByIdUsecase>(
          (context) => _findUserByIdUsecase ??= FindUserByIdUsecase(
            userRepository: context.read<UserRepository>(),
            userPresenter: context.read<UserPresenter>(),
          ),
        ),
      )
      .use(
        provider<UserRepository>(
          (context) => _userRepository ??= UserRepositoryImpl(
            userDataSource: context.read<UserDataSource>(),
          ),
        ),
      )
      .use(
        provider<UserPresenter>(
          (context) => _userPresenter ??= UserPresenterImpl(),
        ),
      )
      .use(
        provider<UserDataSource>(
          (context) {
            if (env[Env.activeDb] == 'postgres') {
              return _userDataSource ??= PostgresUserDataSource(
                dbConnection: context.read<DbConnection>(),
                passwordManager: context.read<PasswordManager>(),
              );
            } else {
              return _userDataSource ??= MongoUserDataSource(
                dbConnection: context.read<DbConnection>(),
                passwordManager: context.read<PasswordManager>(),
              );
            }
          },
        ),
      )
      .use(
        provider<JwtService>(
          (context) => _jwtService ??= JwtService(),
        ),
      )
      .use(
        provider<PasswordManager>(
          (context) => _passwordManager ??= BcryptHashPassword(),
        ),
      )
      .use(
        provider<InputValidators>(
          (context) => _inputValidators ??= InputValidators(),
        ),
      );
}
