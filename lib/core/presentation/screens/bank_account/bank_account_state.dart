import 'package:pay/core/domain/entity/bank_account_entity.dart';

abstract class BankAccountState {}

class BankAccountInitial extends BankAccountState {}

class BankAccountLoading extends BankAccountState {}

class BankAccountLoaded extends BankAccountState {
  final List<BankAccount> accounts;

  BankAccountLoaded(this.accounts);
}

class BankAccountError extends BankAccountState {
  final String message;

  BankAccountError(this.message);
}
