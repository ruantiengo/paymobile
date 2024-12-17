import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/core/data/models/bank_slip.model.dart';
import 'package:pay/core/domain/usecase/bank_slip_usecase.dart';
import 'bank_slip_event.dart';
import 'bank_slip_state.dart';

class BankSlipBloc extends Bloc<BankSlipEvent, BankSlipState> {
  final BankSlipUseCase useCase;

  List<BankSlipModel> allBankSlips = [];

  int currentPage = 1;
  bool hasMore = true;

  BankSlipBloc(this.useCase) : super(BankSlipInitial()) {
    on<LoadBankSlips>((event, emit) async {
      emit(BankSlipLoading());
      try {
        currentPage = 1;
        hasMore = true;
        final bankSlips = await useCase.call(currentPage);
        allBankSlips = bankSlips;
        if (bankSlips.isEmpty) {
          hasMore = false;
        }
        emit(BankSlipLoaded(allBankSlips));
      } catch (error) {
        emit(BankSlipError(error.toString()));
      }
    });

    on<LoadNextBankSlipsPage>((event, emit) async {
      if (!hasMore) return;

      try {
        currentPage++;
        final newBankSlips = await useCase.call(currentPage);
        if (newBankSlips.isEmpty) {
          hasMore = false;
        } else {
          allBankSlips.addAll(newBankSlips);
        }
        emit(BankSlipLoaded(allBankSlips));
      } catch (error) {
        currentPage--;
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
