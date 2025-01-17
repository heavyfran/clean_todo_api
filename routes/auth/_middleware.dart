import 'package:clean_todo_api/core/db/db_connection.dart';
import 'package:clean_todo_api/core/services/jwt_service.dart';
import 'package:clean_todo_api/core/services/password_manager.dart';
import 'package:clean_todo_api/core/validators/input_validators.dart';
import 'package:clean_todo_api/env/env.dart';
import 'package:clean_todo_api/features/auth/data/datasources/auth_data_source.dart';
import 'package:clean_todo_api/features/auth/data/datasources/mongo_auth_data_source.dart';
import 'package:clean_todo_api/features/auth/data/datasources/postgres_auth_data_source.dart';
import 'package:clean_todo_api/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:clean_todo_api/features/auth/domain/presenters/auth_presenter.dart';
import 'package:clean_todo_api/features/auth/domain/repositories/auth_repository.dart';
import 'package:clean_todo_api/features/auth/domain/usecases/usecases.dart';
import 'package:clean_todo_api/features/auth/presentation/controllers/auth_controller.dart';
import 'package:clean_todo_api/features/auth/presentation/controllers/auth_controller_impl.dart';
import 'package:clean_todo_api/features/auth/presentation/presenters/auth_presenter_impl.dart';
import 'package:dart_frog/dart_frog.dart';

AuthDataSource? _authDataSource;
AuthRepository? _authRepository;
AuthPresenter? _authPresenter;
SignupUsecase? _signupUsecase;
SigninUsecase? _signinUsecase;
ResetPasswordUsecase? _resetPasswordUsecase;
AuthController? _authController;

Handler middleware(Handler handler) {
  return handler

      /// ====== controllers
      .use(
        provider<AuthController>(
          (context) => _authController ??= AuthControllerImpl(
            signupUsecase: context.read<SignupUsecase>(),
            signinUsecase: context.read<SigninUsecase>(),
            resetPasswordUsecase: context.read<ResetPasswordUsecase>(),
            jwtService: context.read<JwtService>(),
            inputValidators: context.read<InputValidators>(),
          ),
        ),
      )

      /// ====== usecases
      .use(
        provider<SignupUsecase>(
          (context) => _signupUsecase ??= SignupUsecase(
            authRepository: context.read<AuthRepository>(),
            authPresenter: context.read<AuthPresenter>(),
          ),
        ),
      )
      .use(
        provider<SigninUsecase>(
          (context) => _signinUsecase ??= SigninUsecase(
            authRepository: context.read<AuthRepository>(),
            authPresenter: context.read<AuthPresenter>(),
          ),
        ),
      )
      .use(
        provider<ResetPasswordUsecase>(
          (context) => _resetPasswordUsecase ??= ResetPasswordUsecase(
            authRepository: context.read<AuthRepository>(),
          ),
        ),
      )

      /// ====== presenters
      .use(
        provider<AuthPresenter>(
          (context) => _authPresenter ??= AuthPresenterImpl(),
        ),
      )

      /// ====== repositories
      .use(
        provider<AuthRepository>(
          (context) => _authRepository ??= AuthRepositoryImpl(
            authDataSource: context.read<AuthDataSource>(),
          ),
        ),
      )

      /// ====== data sources
      .use(
    provider<AuthDataSource>(
      (context) {
        if (env[Env.activeDb] == 'postgres') {
          return _authDataSource ??= PostgresAuthDataSource(
            dbConnection: context.read<DbConnection>(),
            passwordManager: context.read<PasswordManager>(),
          );
        } else {
          return _authDataSource ??= MongoAuthDataSource(
            dbConnection: context.read<DbConnection>(),
            passwordManager: context.read<PasswordManager>(),
          );
        }
      },
    ),
  );
}
