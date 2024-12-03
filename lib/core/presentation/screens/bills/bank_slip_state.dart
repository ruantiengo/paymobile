import 'package:pay/core/data/models/bank_slip.model.dart';

abstract class BankSlipState {}

class BankSlipInitial extends BankSlipState {}

class BankSlipLoading extends BankSlipState {}

class BankSlipLoaded extends BankSlipState {
  final List<BankSlipModel> bankSlips;

  BankSlipLoaded(this.bankSlips);
}

class BankSlipError extends BankSlipState {
  final String message;

  BankSlipError(this.message);
}
