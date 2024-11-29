// bank_account_usecase.dart
import 'package:pay/core/data/repository/bank_account_repository.dart';
import 'package:pay/core/domain/entity/bank_account_entity.dart';

class BankAccountUseCase {
  final BankAccountRepository repository;

  BankAccountUseCase(this.repository);

  Future<List<BankAccount>> call() async {
    return await repository.getBankAccounts();
  }
}
