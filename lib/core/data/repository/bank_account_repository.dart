import 'package:pay/core/data/provider/bank_account_provider.dart';
import 'package:pay/core/domain/entity/bank_account_entity.dart';

class BankAccountRepository {
  final BankAccountProvider _provider;

  BankAccountRepository({BankAccountProvider? provider})
      : _provider = provider ?? BankAccountProvider();

  Future<List<BankAccount>> getBankAccounts() async {
    final bankAccountModels = await _provider.getBankAccounts();
    return bankAccountModels;
  }
}
