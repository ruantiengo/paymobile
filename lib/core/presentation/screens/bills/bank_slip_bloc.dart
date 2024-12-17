import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/core/data/models/bank_slip.model.dart';
import 'package:pay/core/domain/usecase/bank_slip_usecase.dart';
import 'bank_slip_event.dart';
import 'bank_slip_state.dart';

class BankSlipBloc extends Bloc<BankSlipEvent, BankSlipState> {
  final BankSlipUseCase useCase;

  // Lista completa de boletos carregados até o momento
  List<BankSlipModel> allBankSlips = [];

  // Controle de paginação
  int currentPage = 1;
  bool hasMore = true;

  BankSlipBloc(this.useCase) : super(BankSlipInitial()) {
    on<LoadBankSlips>((event, emit) async {
      emit(BankSlipLoading());
      try {
        currentPage = 1;
        hasMore = true;
        final bankSlips = await useCase.call(
            currentPage); // Assumindo que sua useCase agora suporta paginação
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
      // Só carrega se ainda houver mais
      if (!hasMore) return;

      try {
        currentPage++;
        final newBankSlips = await useCase.call(currentPage); // Próxima página
        if (newBankSlips.isEmpty) {
          hasMore = false;
        } else {
          allBankSlips.addAll(newBankSlips);
        }
        emit(BankSlipLoaded(allBankSlips));
      } catch (error) {
        // Se der erro, podemos emitir um erro, ou voltar o currentPage
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
