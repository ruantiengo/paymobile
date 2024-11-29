import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/core/domain/usecase/login_usecase.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc(this.loginUseCase) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());

      try {
        final auth = await loginUseCase(event.email, event.password);
        emit(LoginSuccess(auth));
      } catch (error) {
        emit(LoginFailure(error.toString()));
      }
    });
  }
}
