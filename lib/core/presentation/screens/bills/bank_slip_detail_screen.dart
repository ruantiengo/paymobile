import 'package:flutter/material.dart';
import 'package:pay/core/data/models/bank_slip.model.dart';

class BankSlipDetailScreen extends StatelessWidget {
  final BankSlipModel bankSlip;

  const BankSlipDetailScreen({Key? key, required this.bankSlip})
      : super(key: key);

  String formatDateTime(String dateTime) {
    final date = DateTime.parse(dateTime);
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Boleto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${bankSlip.erpId}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Status: ${bankSlip.status}'),
            Text('Valor: R\$ ${bankSlip.total.toStringAsFixed(2)}'),
            Text(
                'Data de Emissão: ${formatDateTime(bankSlip.expeditionDate.toString())}'),
            Text('Conta: ${bankSlip.id}'),
            // Adicione aqui outras informações relevantes do bankSlip.
          ],
        ),
      ),
    );
  }
}
