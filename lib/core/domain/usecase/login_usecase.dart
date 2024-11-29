import 'package:pay/core/data/repository/auth_repository.dart';
import 'package:pay/core/domain/entity/auth_entity.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  Future<AuthEntity> call(String email, String password) async {
    final response = await authRepository.login(email, password);
    return AuthEntity(
      token: response.token,
      refreshToken: response.refreshToken,
      expirationDate: response.expirationDate,
      userName: response.userData.name,
    );
  }
}
