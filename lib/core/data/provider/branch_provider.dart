import 'package:pay/core/data/models/branch_model.dart';
import 'package:pay/core/data/provider/api_provider.dart';
import 'package:pay/config/env.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BranchProvider {
  final ApiProvider _apiProvider;

  BranchProvider() : _apiProvider = ApiProvider(AppConfig.apiBaseUrl);

  Future<List<BranchModel>> getBranches() async {
    final prefs = await SharedPreferences.getInstance();
    final tenantId = prefs.getString('tenant_id');
    final String cacheKey = 'branches_cache_${tenantId ?? ''}';
    final String cacheKeyTime = 'branches_cache_${tenantId ?? ''}_time';
    final Duration cacheDuration = Duration(days: 7);
    final cachedData = prefs.getString(cacheKey);
    final cacheTime = prefs.getInt(cacheKeyTime);

    if (cachedData != null && cacheTime != null) {
      final cacheDate = DateTime.fromMillisecondsSinceEpoch(cacheTime);
      if (DateTime.now().isBefore(cacheDate.add(cacheDuration))) {
        final List<dynamic> jsonData = json.decode(cachedData);
        return jsonData
            .map((json) => BranchModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    }

    final response = await _apiProvider
        .get('/generaldataservice/api/branches/tenantid/getAll');

    if (response is List) {
      final branches = (response as List)
          .map((json) => BranchModel.fromJson(json as Map<String, dynamic>))
          .toList();

      // Cache the response
      prefs.setString(cacheKey, json.encode(response));
      prefs.setInt(cacheKeyTime, DateTime.now().millisecondsSinceEpoch);

      return branches;
    }
    throw Exception('Unexpected response format');
  }
}
