abstract class BankAccountEvent {}

class LoadBankAccounts extends BankAccountEvent {}

class SearchBankAccounts extends BankAccountEvent {
  final String query;

  SearchBankAccounts(this.query);
}
