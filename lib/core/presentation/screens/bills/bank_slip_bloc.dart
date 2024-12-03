import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/core/data/models/bank_slip.model.dart';
import 'package:pay/core/domain/usecase/bank_slip_usecase.dart';
import 'bank_slip_event.dart';
import 'bank_slip_state.dart';

class BankSlipBloc extends Bloc<BankSlipEvent, BankSlipState> {
  final BankSlipUseCase useCase;
  List<BankSlipModel> allBankSlips = [];

  BankSlipBloc(this.useCase) : super(BankSlipInitial()) {
    on<LoadBankSlips>((event, emit) async {
      emit(BankSlipLoading());

      try {
        final bankSlips = await useCase.call();
        allBankSlips = bankSlips;
        emit(BankSlipLoaded(bankSlips));
      } catch (error) {
        emit(BankSlipError(error.toString()));
      }
    });

    on<SearchBankSlips>((event, emit) {
      final filteredBankSlips = allBankSlips.where((bs) {
        return bs.erpId.toLowerCase().contains(event.query.toLowerCase());
      }).toList();
      emit(BankSlipLoaded(filteredBankSlips));
    });
  }
}
