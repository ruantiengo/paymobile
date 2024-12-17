import 'package:pay/core/domain/entity/statistics_entity.dart';

abstract class StatisticsState {}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsLoaded extends StatisticsState {
  final Statistics statistics;
  StatisticsLoaded(this.statistics);
}

class StatisticsError extends StatisticsState {
  final String message;
  StatisticsError(this.message);
}
