abstract class BankSlipEvent {}

class LoadBankSlips extends BankSlipEvent {}

class SearchBankSlips extends BankSlipEvent {
  final String query;

  SearchBankSlips(this.query);
}
