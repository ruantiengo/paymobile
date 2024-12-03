// bank_account_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/core/domain/entity/bank_account_entity.dart';
import 'package:pay/core/domain/usecase/bank_account_usecase.dart';
import 'bank_account_event.dart';
import 'bank_account_state.dart';

class BankAccountBloc extends Bloc<BankAccountEvent, BankAccountState> {
  final BankAccountUseCase useCase;
  List<BankAccount> allAccounts = [];

  BankAccountBloc(this.useCase) : super(BankAccountInitial()) {
    on<LoadBankAccounts>((event, emit) async {
      emit(BankAccountLoading());

      try {
        final accounts = await useCase.call();
        allAccounts = accounts;
        emit(BankAccountLoaded(accounts));
      } catch (error) {
        emit(BankAccountError(error.toString()));
      }
    });

    on<SearchBankAccounts>((event, emit) {
      final filteredAccounts = allAccounts.where((account) {
        return account.name.toLowerCase().contains(event.query.toLowerCase());
      }).toList();
      emit(BankAccountLoaded(filteredAccounts));
    });
  }
}
