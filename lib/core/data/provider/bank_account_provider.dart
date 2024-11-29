import 'package:pay/core/data/models/bank_account_model.dart';
import 'package:pay/core/data/provider/api_provider.dart';
import 'package:pay/config/env.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BankAccountProvider {
  final ApiProvider _apiProvider;

  BankAccountProvider() : _apiProvider = ApiProvider(AppConfig.apiBaseUrl);

  Future<List<BankAccountModel>> getBankAccounts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final pk = prefs.getString('pk');

      print('token: $token');
      print('pk: $pk');
      final response = await _apiProvider.get(
        '/cbaservice/bank-account/list',
        headers: {
          'Content-Type': 'application/json',
          'Token': '$token',
          'X-api-key': '$pk',
        },
      );

      if (response is List) {
        return (response as List<dynamic>)
            .map((json) =>
                BankAccountModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (response.containsKey('data')) {
        print(response['data']);
        final List<dynamic> data = response['data'];
        return data.map((json) => BankAccountModel.fromJson(json)).toList();
      }

      throw Exception('Unexpected response format');
    } catch (e) {
      print(e);
      throw Exception('Error fetching bank accounts: $e');
    }
  }
}
