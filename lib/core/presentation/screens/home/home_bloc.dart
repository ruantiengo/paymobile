import 'package:flutter/material.dart';
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

class BlocStateHandler extends StatelessWidget {
  final Widget Function(BuildContext, StatisticsState) builder;

  const BlocStateHandler({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatisticBloc, StatisticsState>(
      builder: (context, state) {
        if (state is StatisticsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is StatisticsError) {
          return Center(
            child: Text(
              'Erro: ${state.message}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        if (state is StatisticsLoaded) {
          return builder(context, state);
        }
        return Container();
      },
    );
  }
}
