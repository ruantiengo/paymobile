// bank_account_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/core/domain/usecase/bank_account_usecase.dart';

import 'package:pay/core/presentation/screens/bank_account/bank_account_block.dart';
import 'package:pay/core/presentation/screens/bank_account/bank_account_event.dart';
import 'package:pay/core/presentation/screens/bank_account/bank_account_state.dart';

class BankAccountScreen extends StatelessWidget {
  const BankAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BankAccountBloc(context.read<BankAccountUseCase>())
        ..add(LoadBankAccounts()),
      child: const BankAccountView(),
    );
  }
}

class BankAccountView extends StatelessWidget {
  const BankAccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contas Bancárias'),
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Nova Conta Bancária'),
            onPressed: () {
              // Implement new bank account navigation
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar contas...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      context
                          .read<BankAccountBloc>()
                          .add(SearchBankAccounts(value));
                    },
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  hint: const Text('Agência'),
                  items: const [
                    DropdownMenuItem(value: '', child: Text('Todas')),
                  ],
                  onChanged: (value) {
                    // Implement filter logic
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<BankAccountBloc, BankAccountState>(
              builder: (context, state) {
                if (state is BankAccountLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is BankAccountError) {
                  return Center(child: Text('Error'));
                }

                if (state is BankAccountLoaded) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Nome')),
                          DataColumn(label: Text('CNPJ/CPF')),
                          DataColumn(label: Text('Banco')),
                          DataColumn(label: Text('Conta')),
                          DataColumn(label: Text('Agência')),
                          DataColumn(label: Text('Tipo de Chave PIX')),
                          DataColumn(label: Text('Data de Criação')),
                          DataColumn(label: Text('Ações')),
                        ],
                        rows: state.accounts.map((account) {
                          return DataRow(
                            cells: [
                              DataCell(Text(account.name)),
                              DataCell(Text(account.documentNumber)),
                              DataCell(Text(account.bank)),
                              DataCell(Text(
                                  '${account.accountNumber}-${account.accountDigit}')),
                              DataCell(Text(account.agency)),
                              DataCell(Text(account.pixDictKeyType)),
                              DataCell(
                                  Text(account.createdAt.toIso8601String())),
                              DataCell(Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      // Implement edit action
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.copy),
                                    onPressed: () {
                                      // Implement copy action
                                    },
                                  ),
                                ],
                              )),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }

                return const Center(child: Text('No data available'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
