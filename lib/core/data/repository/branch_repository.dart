import 'package:pay/core/data/models/branch_model.dart';
import 'package:pay/core/data/provider/branch_provider.dart';

class BranchRepository {
  final BranchProvider _provider;

  BranchRepository({BranchProvider? provider})
      : _provider = provider ?? BranchProvider();

  Future<List<BranchModel>> getBranches() async {
    return await _provider.getBranches();
  }
}
