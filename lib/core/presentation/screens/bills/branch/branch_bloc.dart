import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/core/domain/usecase/branch_usecase.dart';
import 'branch_event.dart';
import 'branch_state.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  final BranchUseCase useCase;

  BranchBloc(this.useCase) : super(BranchInitial()) {
    on<LoadBranches>((event, emit) async {
      emit(BranchLoading());
      try {
        final branches = await useCase.call();
        emit(BranchLoaded(branches));
      } catch (error) {
        emit(BranchError(error.toString()));
      }
    });
  }
}
