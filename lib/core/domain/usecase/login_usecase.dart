import 'package:pay/core/data/repository/auth_repository.dart';
import 'package:pay/core/domain/entity/auth_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  Future<AuthEntity> call(String email, String password) async {
    final response = await authRepository.login(email, password);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', response.token);
    await prefs.setString('refreshToken', response.refreshToken);
    await prefs.setString(
        'expirationDate', response.expirationDate.toIso8601String());

    return AuthEntity(
      token: response.token,
      refreshToken: response.refreshToken,
      expirationDate: response.expirationDate,
      userName: response.userData.name,
    );
  }
}
