import 'package:pay/core/data/models/bank_slip.model.dart';
import 'package:pay/core/data/repository/bank_slip_repository.dart';

class BankSlipUseCase {
  final BankSlipRepository repository;

  BankSlipUseCase(this.repository);

  Future<List<BankSlipModel>> call() async {
    return await repository.getBankSlips();
  }
}
