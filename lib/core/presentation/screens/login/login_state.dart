import 'package:pay/core/domain/entity/auth_entity.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final AuthEntity auth;

  LoginSuccess(this.auth);
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);
}
