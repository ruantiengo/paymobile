import 'package:pay/core/data/models/bank_slip.model.dart';
import 'package:pay/core/data/provider/api_provider.dart';
import 'package:pay/config/env.dart';
import 'package:pay/core/domain/entity/statistics_entity.dart';

class BankSlipProvider {
  final ApiProvider _apiProvider;

  BankSlipProvider() : _apiProvider = ApiProvider(AppConfig.apiBaseUrl);

  Future<List<BankSlipModel>> getBankSlips(num page) async {
    final response = await _apiProvider.get(
        '/cbaservice/bank-slip/list?page=${page}&limit=25&order=DESC&order_by=erp_id');
    if (response.containsKey('data')) {
      final List<dynamic> data = response['data'];
      return data.map((json) => BankSlipModel.fromJson(json)).toList();
    }
    throw Exception('Unexpected response format');
  }

  Future<Statistics> getMonthStatistics() async {
    final response = await _apiProvider.get('/cbaservice/statistics');

    if (response.containsKey('approved')) {
      final stats = Statistics.fromJson(response);
      return stats;
    }
    throw Exception('Unexpected response format');
  }
}
