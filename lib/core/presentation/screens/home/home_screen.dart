import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/core/presentation/screens/home/home_bloc.dart';
import 'package:pay/core/presentation/screens/home/home_animate.dart';
import 'package:pay/core/presentation/screens/home/home_event.dart';
import 'package:pay/core/presentation/screens/home/home_state.dart';
import 'package:pay/utils/colors.dart';
import 'package:pay/utils/format.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

            Future<String?> getUserName() async {
              final prefs = await SharedPreferences.getInstance();
              return prefs.getString('name');
            }

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                // Avatar do usuário
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: SvgPicture.asset(
                                    'assets/images/Avatar.svg',
                                    height: 32,
                                  ),
                                ),
                                const SizedBox(width: 12),

                                FutureBuilder<String?>(
                                  future: getUserName(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    }
                                    if (snapshot.hasError ||
                                        !snapshot.hasData) {
                                      return const Text(
                                        "Nome não encontrado",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      );
                                    }
                                    return Text(
                                      snapshot.data!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            SvgPicture.asset(
                              'assets/images/4pay.svg',
                              height: 32,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              "Bem vindo",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
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
                        BlocStateHandler(
                          builder: (context, state) {
                            final statistics =
                                (state as StatisticsLoaded).statistics;
                            return AnimatedPaymentRate(
                              approvedTotal: statistics.approvedTotal,
                              pending: statistics.pending,
                            );
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
                          BlocStateHandler(
                            builder: (context, state) {
                              final statistics =
                                  (state as StatisticsLoaded).statistics;
                              final stats = [
                                {
                                  'label': "Total de Cobranças",
                                  'value': statistics.pending +
                                      statistics.approvedTotal,
                                },
                                {
                                  'label': "Cobranças Pagas",
                                  'value': statistics.approvedTotal,
                                  'color': Colors.green,
                                },
                                {
                                  'label': "Cobranças Pendentes",
                                  'value': statistics.pending,
                                  'color': Colors.blueAccent,
                                },
                                {
                                  'label': "Cobranças Expiradas",
                                  'value': statistics.expired,
                                  'color': Colors.redAccent,
                                },
                                {
                                  'label': "Percentual de Atrasados",
                                  'value': (statistics.expired /
                                          (statistics.pending +
                                              statistics.approvedTotal)) *
                                      100,
                                  'suffix': '%',
                                  'highlight': true,
                                },
                                {
                                  'label': "Média de Atraso no Pagamento",
                                  'value': statistics.expired /
                                      statistics.approvedTotal,
                                  'suffix': ' dias',
                                },
                              ];
                              return AnimatedStatsGroup(stats: stats);
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
                          BlocStateHandler(
                            builder: (context, state) {
                              return _buildPaymentStatistics(
                                  state as StatisticsLoaded);
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

  Widget _buildPaymentStatistics(StatisticsLoaded state) {
    final statistics = state.statistics;
    final paymentMethods = [
      {
        'label': 'Cartão de crédito',
        'count': statistics.paymentMethodStatistics.creditCard.count,
        'total':
            formatToBRL(statistics.paymentMethodStatistics.creditCard.total),
      },
      {
        'label': 'Pix',
        'count': statistics.paymentMethodStatistics.pix.count,
        'total': formatToBRL(statistics.paymentMethodStatistics.pix.total),
      },
      {
        'label': 'Código de barra',
        'count': statistics.paymentMethodStatistics.barcode.count,
        'total': formatToBRL(statistics.paymentMethodStatistics.barcode.total),
      },
      {
        'label': 'Outros',
        'count': 0,
        'total': formatToBRL(0),
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
                color: Colors.black.withAlpha((0.1 * 255).toInt()),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  method['label'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  "Cobranças: ${method['count']}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  "Total: ${method['total']}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

extension on Future<SharedPreferences> {
  getString(String s) {}
}
