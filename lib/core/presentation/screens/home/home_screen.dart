import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/core/presentation/screens/home/home_bloc.dart';
import 'package:pay/core/presentation/screens/home/home_event.dart';
import 'package:pay/core/presentation/screens/home/home_state.dart';
import 'package:pay/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: FutureBuilder<String?>(
          future: _getTenantId(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            }
            final tenantId = snapshot.data;
            if (tenantId == null) {
              return const Center(child: Text('Tenant ID não encontrado'));
            }

            context.read<StatisticBloc>().add(LoadMonthStatistics());

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Resumo de Boletos",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: BlocBuilder<StatisticBloc, StatisticsState>(
                            builder: (context, state) {
                              if (state is StatisticsLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (state is StatisticsLoaded) {
                                final statistics = state.statistics;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildValueRow("Valor em aberto",
                                        formatToBrl(statistics.pending)),
                                    const SizedBox(height: 16),
                                    _buildValueRow("Total Recebido",
                                        formatToBrl(statistics.approvedTotal)),
                                  ],
                                );
                              }
                              if (state is StatisticsError) {
                                return Center(
                                  child: Text(
                                    'Erro: ${state.message}',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Taxa de Pagamento",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        BlocBuilder<StatisticBloc, StatisticsState>(
                          builder: (context, state) {
                            if (state is StatisticsLoaded) {
                              final statistics = state.statistics;
                              final paymentRate = (statistics.approvedTotal /
                                      (statistics.pending +
                                          statistics.approvedTotal)) *
                                  100;
                              return Text(
                                "${paymentRate.toStringAsFixed(2)}%",
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlueAccent,
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            "Estatísticas Gerais",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          BlocBuilder<StatisticBloc, StatisticsState>(
                            builder: (context, state) {
                              if (state is StatisticsLoading) {
                                return const Center(
                                    heightFactor: 6,
                                    child: CircularProgressIndicator());
                              }
                              if (state is StatisticsLoaded) {
                                final statistics = state.statistics;
                                return Column(
                                  children: [
                                    _buildStatItem(
                                        "Total de Boletos Gerados",
                                        formatToBrl(statistics.pending +
                                            statistics.approvedTotal)),
                                    const Divider(),
                                    _buildStatItem("Boletos Pagos",
                                        formatToBrl(statistics.approvedTotal)),
                                    const Divider(),
                                    _buildStatItem("Boletos Cancelados",
                                        formatToBrl(statistics.cancelled)),
                                    const Divider(),
                                    _buildStatItem("Percentual de Atrasados",
                                        "${(statistics.expired / (statistics.pending + statistics.approvedTotal) * 100).toStringAsFixed(2)}%",
                                        highlight: true),
                                    const Divider(),
                                    _buildStatItem(
                                        "Média de Atraso no Pagamento",
                                        "${(statistics.expired / statistics.approvedTotal).toStringAsFixed(2)} dias"),
                                  ],
                                );
                              }
                              return Container();
                            },
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            "Estatísticas de pagamento",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 30),
                          BlocBuilder<StatisticBloc, StatisticsState>(
                            builder: (context, state) {
                              if (state is StatisticsLoading) {
                                return const Center(
                                  heightFactor: 6,
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (state is StatisticsLoaded) {
                                return _buildPaymentStatistics(state);
                              }
                              return Container();
                            },
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<String?> _getTenantId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('tenant_id');
  }

  String formatToBrl(double value) {
    final format = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return format.format(value);
  }

  Widget _buildValueRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white70,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String title, String value, {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: highlight ? Colors.red : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentStatistics(StatisticsLoaded state) {
    final statistics = state.statistics;
    final paymentMethods = [
      {
        'label': 'Cartão de crédito',
        'count': statistics.paymentMethodStatistics.creditCard.count,
        'total':
            formatToBrl(statistics.paymentMethodStatistics.creditCard.total),
      },
      {
        'label': 'Pix',
        'count': statistics.paymentMethodStatistics.pix.count,
        'total': formatToBrl(statistics.paymentMethodStatistics.pix.total),
      },
      {
        'label': 'Código de barra',
        'count': statistics.paymentMethodStatistics.barcode.count,
        'total': formatToBrl(statistics.paymentMethodStatistics.barcode.total),
      },
      {
        'label': 'Outros',
        'count': 0,
        'total': formatToBrl(0),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 3 / 2,
      ),
      itemCount: paymentMethods.length,
      itemBuilder: (context, index) {
        final method = paymentMethods[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                method['label'] as String,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Boletos: ${method['count']}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Total: ${method['total']}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
