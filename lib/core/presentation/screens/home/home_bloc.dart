import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/core/domain/usecase/statistics_usecase.dart';
import 'package:pay/core/presentation/screens/home/home_event.dart';
import 'package:pay/core/presentation/screens/home/home_state.dart';

class StatisticBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final StatisticsUsecase useCase;

  StatisticBloc(this.useCase) : super(StatisticsInitial()) {
    on<LoadMonthStatistics>((event, emit) async {
      emit(StatisticsLoading());
      try {
        final statistics = await useCase.getMonthStatistics();
        emit(StatisticsLoaded(statistics));
      } catch (error) {
        emit(StatisticsError(error.toString()));
      }
    });
  }
}
