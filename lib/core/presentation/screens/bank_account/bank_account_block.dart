// bank_account_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/core/domain/usecase/bank_account_usecase.dart';
import 'bank_account_event.dart';
import 'bank_account_state.dart';

class BankAccountBloc extends Bloc<BankAccountEvent, BankAccountState> {
  final BankAccountUseCase useCase;

  BankAccountBloc(this.useCase) : super(BankAccountInitial()) {
    on<LoadBankAccounts>((event, emit) async {
      emit(BankAccountLoading());

      try {
        final accounts = await useCase.call();
        emit(BankAccountLoaded(accounts));
      } catch (error) {
        emit(BankAccountError(error.toString()));
      }
    });
  }
}
