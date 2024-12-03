import 'package:pay/core/data/models/bank_slip.model.dart';
import 'package:pay/core/data/provider/bank_slip_provider.dart';

class BankSlipRepository {
  final BankSlipProvider _provider;

  BankSlipRepository({BankSlipProvider? provider})
      : _provider = provider ?? BankSlipProvider();

  Future<List<BankSlipModel>> getBankSlips() async {
    final bankSlipModels = await _provider.getBankSlips();

    return bankSlipModels;
  }
}
