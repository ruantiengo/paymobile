class AuthResponseModel {
  final String token;
  final String accessToken;
  final String refreshToken;
  final DateTime expirationDate;
  final UserDataModel userData;

  AuthResponseModel({
    required this.token,
    required this.accessToken,
    required this.refreshToken,
    required this.expirationDate,
    required this.userData,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      token: json['token'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      expirationDate: DateTime.parse(json['expirationDate']),
      userData: UserDataModel.fromJson(json['data']),
    );
  }
}

class UserDataModel {
  final String userId;
  final String username;
  final String name;
  final String mainTenant;
  final String pk;
  final List<TenantModel> tenants;

  UserDataModel({
    required this.userId,
    required this.username,
    required this.name,
    required this.mainTenant,
    required this.tenants,
    required this.pk,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      userId: json['user_id'],
      username: json['username'],
      name: json['name'],
      mainTenant: json['mainTenant'],
      tenants: (json['tenants'] as List)
          .map((tenant) => TenantModel.fromJson(tenant))
          .toList(),
      pk: json['pk'],
    );
  }
}

class TenantModel {
  final String tenantId;
  final String name;
  final String pk;
  final String description;
  final DateTime createdAt;
  final bool enabled;
  final bool userIsMain;

  TenantModel({
    required this.tenantId,
    required this.name,
    required this.pk,
    required this.description,
    required this.createdAt,
    required this.enabled,
    required this.userIsMain,
  });

  factory TenantModel.fromJson(Map<String, dynamic> json) {
    return TenantModel(
      tenantId: json['tenantId'],
      name: json['name'],
      pk: json['pk'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      enabled: json['enabled'],
      userIsMain: json['userIsMain'],
    );
  }
}
