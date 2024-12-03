import 'dart:convert';

import 'package:pay/core/data/repository/auth_repository.dart';
import 'package:pay/core/domain/entity/auth_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);

  Future<AuthEntity> call(String email, String password) async {
    final response = await authRepository.login(email, password);

    // Instância do SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Salvar tokens e datas
    await prefs.setString('token', response.token);
    await prefs.setString('refreshToken', response.refreshToken);
    await prefs.setString(
        'expirationDate', response.expirationDate.toIso8601String());

    // Buscar o tenant principal
    final mainTenant = response.userData.tenants
        .firstWhere((tenant) => tenant.userIsMain == true);

    // Salvar informações do tenant principal
    await prefs.setString('pk', response.userData.pk);
    await prefs.setString('tenant_id', mainTenant.tenantId);

    // Serializar e salvar a lista de tenants como JSON
    var tenants =
        response.userData.tenants.map((tenant) => tenant.toJson()).toList();
    String tenantsJson = jsonEncode(tenants);
    await prefs.setString('tenants', tenantsJson); // Corrigido aqui

    // Retornar entidade AuthEntity
    return AuthEntity(
      token: response.token,
      refreshToken: response.refreshToken,
      expirationDate: response.expirationDate,
      userName: response.userData.name,
    );
  }
}
