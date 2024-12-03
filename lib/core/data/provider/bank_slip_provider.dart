import 'package:pay/core/data/models/bank_slip.model.dart';
import 'package:pay/core/data/provider/api_provider.dart';
import 'package:pay/config/env.dart';

class BankSlipProvider {
  final ApiProvider _apiProvider;

  BankSlipProvider() : _apiProvider = ApiProvider(AppConfig.apiBaseUrl);

  Future<List<BankSlipModel>> getBankSlips() async {
    final response = await _apiProvider.get(
        '/cbaservice/bank-slip/list?page=1&limit=25&order=DESC&order_by=erp_id');
    if (response.containsKey('data')) {
      final List<dynamic> data = response['data'];
      return data.map((json) => BankSlipModel.fromJson(json)).toList();
    }
    throw Exception('Unexpected response format');
  }
}
