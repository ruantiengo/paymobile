import 'package:pay/core/data/repository/branch_repository.dart';
import 'package:pay/core/domain/entity/branch_entity.dart';

class BranchUseCase {
  final BranchRepository repository;

  BranchUseCase(this.repository);

  Future<List<BranchEntity>> call() async {
    return await repository.getBranches();
  }
}
