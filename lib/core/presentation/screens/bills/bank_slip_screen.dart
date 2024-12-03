import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/core/presentation/screens/bills/bank_slip_bloc.dart';
import 'package:pay/core/presentation/screens/bills/bank_slip_event.dart';
import 'package:pay/core/presentation/screens/bills/bank_slip_state.dart';

class BankSlipScreen extends StatelessWidget {
  const BankSlipScreen({Key? key}) : super(key: key);

  String formatDateTime(String dateTime) {
    final date = DateTime.parse(dateTime);
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Boletos Bancários',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar boletos...',
                      prefixIcon: const Icon(Icons.search, color: Colors.blue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                    onChanged: (value) {
                      context.read<BankSlipBloc>().add(SearchBankSlips(value));
                    },
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  hint:
                      const Text('Erpid', style: TextStyle(color: Colors.blue)),
                  items: const [
                    // DropdownMenuItem(
                    //   value: 'pending',
                    //   child: Text('Pendentes',
                    //       style: TextStyle(color: Colors.blue)),
                    // ),
                    // DropdownMenuItem(
                    //   value: 'paid',
                    //   child:
                    //       Text('Pagos', style: TextStyle(color: Colors.blue)),
                    // ),
                    // DropdownMenuItem(
                    //   value: '',
                    //   child:
                    //       Text('Todos', style: TextStyle(color: Colors.blue)),
                    // ),
                  ],
                  onChanged: (value) {
                    // context
                    //     .read<BankSlipBloc>()
                    //     .add(FilterBankSlipsByStatus(value!));
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<BankSlipBloc, BankSlipState>(
              builder: (context, state) {
                if (state is BankSlipLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is BankSlipError) {
                  return Center(
                      child: Text('Erro: ${state.message}',
                          style: TextStyle(color: Colors.red)));
                }

                if (state is BankSlipLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<BankSlipBloc>().add(LoadBankSlips());
                    },
                    child: ListView.builder(
                      itemCount: state.bankSlips.length,
                      itemBuilder: (context, index) {
                        final bankSlip = state.bankSlips[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white, // Alterado para branco
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Boleto: ${bankSlip.erpId}',
                                  style: TextStyle(
                                    color: Colors.blue.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  bankSlip.status == "pending"
                                      ? "Pendente"
                                      : "Pago",
                                  style: TextStyle(
                                    color: bankSlip.status == "pending"
                                        ? Colors.orange
                                        : Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  'Valor: R\$ ${bankSlip.total.toStringAsFixed(2)}',
                                  style: TextStyle(color: Colors.black87),
                                ),
                                Text(
                                  'Data de Emissão: ${formatDateTime(bankSlip.expeditionDate.toString())}',
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                                Text(
                                  'Conta: ${bankSlip.id}', // Substitua por nome da conta, se disponível.
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                return const Center(
                  child: Text(
                    'Nenhum boleto disponível',
                    style: TextStyle(color: Colors.blue),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
