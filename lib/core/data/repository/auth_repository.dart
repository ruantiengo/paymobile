import 'package:pay/core/data/provider/api_provider.dart';

import '../models/auth_response_model.dart';

class AuthRepository {
  final ApiProvider apiProvider;

  AuthRepository(this.apiProvider);

  Future<AuthResponseModel> login(String email, String password) async {
    final response = await apiProvider.post(
      '/auth',
      {'username': email, 'password': password},
    );

    return AuthResponseModel.fromJson(response);
  }
}
