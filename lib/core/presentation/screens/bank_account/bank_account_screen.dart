import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/core/presentation/screens/bank_account/bank_account_bloc.dart';
import 'package:pay/core/presentation/screens/bank_account/bank_account_event.dart';
import 'package:pay/core/presentation/screens/bank_account/bank_account_state.dart';

class BankAccountScreen extends StatelessWidget {
  const BankAccountScreen({super.key});

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
            'Contas Bancárias',
            style: TextStyle(color: Colors.white),
          ),
        ),
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
                      context
                          .read<BankAccountBloc>()
                          .add(SearchBankAccounts(value));
                    },
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  hint:
                      const Text('Nome', style: TextStyle(color: Colors.blue)),
                  items: const [],
                  onChanged: (value) {},
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
                  return const Center(
                      child: Text('Erro', style: TextStyle(color: Colors.red)));
                }

                if (state is BankAccountLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<BankAccountBloc>().add(LoadBankAccounts());
                    },
                    child: ListView.builder(
                      itemCount: state.accounts.length + 1,
                      itemBuilder: (context, index) {
                        if (index == state.accounts.length) {
                          return const SizedBox(height: 100);
                        }

                        final account = state.accounts[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: ListTile(
                            title: Text(
                              account.name,
                              style: TextStyle(color: Colors.blue.shade900),
                            ),
                            subtitle: Text(
                              'Banco: ${account.bank}\nConta: ${account.accountNumber}-${account.accountDigit}\nAgência: ${account.agency}',
                              style: TextStyle(color: Colors.blue.shade700),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                return const Center(
                  child: Text(
                    'Lista de contas vazias',
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
