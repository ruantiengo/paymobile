import 'package:pay/core/data/repository/bank_slip_repository.dart';
import 'package:pay/core/domain/entity/statistics_entity.dart';

class StatisticsUsecase {
  final BankSlipRepository repository;
  StatisticsUsecase(this.repository);

  Future<Statistics> getMonthStatistics() async {
    return await repository.getMonthStatistics();
  }
}
