import 'package:pay/core/data/models/bank_slip.model.dart';
import 'package:pay/core/data/provider/bank_slip_provider.dart';
import 'package:pay/core/domain/entity/statistics_entity.dart';

class BankSlipRepository {
  final BankSlipProvider _provider;

  BankSlipRepository({BankSlipProvider? provider})
      : _provider = provider ?? BankSlipProvider();

  Future<List<BankSlipModel>> getBankSlips(num page) async {
    final bankSlipModels = await _provider.getBankSlips(page);

    return bankSlipModels;
  }

  Future<Statistics> getMonthStatistics() async {
    return await _provider.getMonthStatistics();
  }
}
