class AuthEntity {
  final String token;
  final String refreshToken;
  final DateTime expirationDate;
  final String userName;

  AuthEntity({
    required this.token,
    required this.refreshToken,
    required this.expirationDate,
    required this.userName,
  });
}