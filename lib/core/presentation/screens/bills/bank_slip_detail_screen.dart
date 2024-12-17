import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pay/config/env.dart';
import 'package:pay/core/data/models/bank_slip.model.dart';
import 'package:pay/core/domain/entity/branch_entity.dart';
import 'package:pay/utils/format.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BankSlipDetailScreen extends StatelessWidget {
  final BankSlipModel bankSlip;
  final BranchEntity branch;

  const BankSlipDetailScreen({
    Key? key,
    required this.bankSlip,
    required this.branch,
  }) : super(key: key);

  String formatDateTime(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case "pending":
        return Icons.hourglass_empty;
      case "paid":
        return Icons.check_circle;
      case "cancelled":
        return Icons.cancel;
      case "expired":
        return Icons.error;
      default:
        return Icons.error_outline;
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.orange;
      case "paid":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      case "expired":
        return Colors.grey;
      default:
        return Colors.red;
    }
  }

  Future<void> _sharePdf(BuildContext context) async {
    try {
      final pdfUrl =
          "${AppConfig.apiBaseUrl}/cbaservice/bank-slip/${bankSlip.id}/pdf";
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final xApiKey = prefs.getString('pk');

      final response = await http.get(Uri.parse(pdfUrl), headers: {
        "accept": "application/pdf",
        "token": token!,
        "x-api-key": xApiKey!,
      });
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final pdfPath = '${tempDir.path}/boleto_${bankSlip.id}.pdf';
        final file = File(pdfPath);
        await file.writeAsBytes(response.bodyBytes);

        // Aqui usamos shareFiles, mas encapsulado em uma função chamada _sharePdfFile (sua função "share_pdf")
        await Share.shareXFiles(
          [XFile(pdfPath)],
          text: 'Compartilhando PDF do boleto ${bankSlip.erpId}',
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao obter o PDF do boleto')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao compartilhar PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Definições de estilo
    final titleStyle = const TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white);
    final subTitleStyle = const TextStyle(fontSize: 16, color: Colors.white70);
    final cardTitleStyle =
        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    final cardContentStyle = const TextStyle(fontSize: 16);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Detalhes do Boleto',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Fundo com gradiente
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A2980), Color(0xFF26D0CE)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cabeçalho do boleto
                  Center(
                    child: Column(
                      children: [
                        Text('Boleto: ${bankSlip.erpId}', style: titleStyle),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(getStatusIcon(bankSlip.status),
                                color: getStatusColor(bankSlip.status)),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Card com informações do boleto
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Informações do Boleto', style: cardTitleStyle),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.attach_money,
                                color: Colors.green),
                            title: Text('Valor', style: cardTitleStyle),
                            subtitle: Text(formatToBRL(bankSlip.total),
                                style: cardContentStyle),
                          ),
                          ListTile(
                            leading: const Icon(Icons.calendar_today,
                                color: Colors.blue),
                            title:
                                Text('Data de Emissão', style: cardTitleStyle),
                            subtitle: Text(
                                formatDateTime(bankSlip.expeditionDate),
                                style: cardContentStyle),
                          ),
                          ListTile(
                            leading: const Icon(Icons.date_range,
                                color: Colors.orange),
                            title: Text('Data de Vencimento',
                                style: cardTitleStyle),
                            subtitle: Text(formatDateTime(bankSlip.dueDate),
                                style: cardContentStyle),
                          ),
                          ListTile(
                            leading: const Icon(Icons.timer_off,
                                color: Colors.redAccent),
                            title: Text('Data de Expiração',
                                style: cardTitleStyle),
                            subtitle: Text(
                                formatDateTime(bankSlip.expirationDate),
                                style: cardContentStyle),
                          ),
                          if (bankSlip.paymentDate != null)
                            ListTile(
                              leading:
                                  const Icon(Icons.check, color: Colors.green),
                              title: Text('Data de Pagamento',
                                  style: cardTitleStyle),
                              subtitle: Text(
                                  formatDateTime(bankSlip.paymentDate!),
                                  style: cardContentStyle),
                            ),
                          ListTile(
                            leading: const Icon(Icons.person,
                                color: Colors.deepPurple),
                            title: Text('Comprador', style: cardTitleStyle),
                            subtitle: Text(
                                '${bankSlip.buyerName}\n${bankSlip.buyerDocument}',
                                style: cardContentStyle),
                          ),
                          ListTile(
                            leading: const Icon(Icons.account_balance_wallet,
                                color: Colors.brown),
                            title: Text('ID Interno do Boleto',
                                style: cardTitleStyle),
                            subtitle:
                                Text(bankSlip.id, style: cardContentStyle),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Card com informações da filial
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Informações da Filial Emissora',
                              style: cardTitleStyle),
                          const Divider(),
                          ListTile(
                            leading:
                                const Icon(Icons.store, color: Colors.teal),
                            title:
                                Text('Nome Comercial', style: cardTitleStyle),
                            subtitle: Text(branch.commercialName,
                                style: cardContentStyle),
                          ),
                          ListTile(
                            leading: const Icon(Icons.location_on,
                                color: Colors.red),
                            title: Text('ID da Filial', style: cardTitleStyle),
                            subtitle: Text(branch.id, style: cardContentStyle),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Botão de compartilhar PDF
                  if (bankSlip.status == "pending" ||
                      bankSlip.status == "overdue")
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () => _sharePdf(context),
                        icon: const Icon(Icons.share),
                        label: const Text('Compartilhar PDF do Boleto'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
