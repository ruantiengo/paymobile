import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/core/presentation/screens/home/home_bloc.dart';
import 'package:pay/core/presentation/screens/home/home_event.dart';
import 'package:pay/core/presentation/screens/home/home_state.dart';
import 'package:pay/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
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
                                Text(
                                  'Nome do Usuário',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
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
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: BlocBuilder<StatisticBloc, StatisticsState>(
                            builder: (context, state) {
                              if (state is StatisticsLoading) {
                                return const AnimatedStatisticsContainer(
                                  isLoading: true,
                                  pending: 0,
                                  approvedTotal: 0,
                                );
                              }

                              if (state is StatisticsLoaded) {
                                final statistics = state.statistics;
                                return AnimatedStatisticsContainer(
                                  pending: statistics.pending,
                                  approvedTotal: statistics.approvedTotal,
                                );
                              }

                              if (state is StatisticsError) {
                                return AnimatedStatisticsContainer(
                                  errorMessage: state.message,
                                  pending: 0,
                                  approvedTotal: 0,
                                );
                              }

                              return const AnimatedStatisticsContainer(
                                pending: 0,
                                approvedTotal: 0,
                              );
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
                              return AnimatedPaymentRate(
                                approvedTotal: statistics.approvedTotal,
                                pending: statistics.pending,
                              );
                            }
                            return const Text(
                              "0.00%",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
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
                          BlocBuilder<StatisticBloc, StatisticsState>(
                            builder: (context, state) {
                              if (state is StatisticsLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (state is StatisticsLoaded) {
                                final statistics = state.statistics;
                                final stats = [
                                  {
                                    'label': "Total de Cobranças",
                                    'value': statistics.pending +
                                        statistics.approvedTotal,
                                  },
                                  {
                                    'label': "Cobranças Pagas",
                                    'value': statistics.approvedTotal,
                                  },
                                  {
                                    'label': "Cobranças Canceladas",
                                    'value': statistics.cancelled,
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

class AnimatedStatsGroup extends StatelessWidget {
  final List<Map<String, dynamic>> stats;

  const AnimatedStatsGroup({Key? key, required this.stats}) : super(key: key);

  String formatToBrl(double value) {
    final format = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return format.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: stat['value']),
          duration: const Duration(seconds: 2),
          builder: (context, animatedValue, child) {
            // Use formatToBrl para valores monetários
            final formattedValue = stat['suffix'] == null
                ? formatToBrl(animatedValue)
                : "${animatedValue.toStringAsFixed(2)}${stat['suffix']}";

            return _buildStatItem(
              stat['label'],
              formattedValue,
              highlight: stat['highlight'] ?? false,
            );
          },
        );
      },
    );
  }

  Widget _buildStatItem(String title, String value, {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: highlight ? Colors.red : Colors.black,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
class AnimatedPaymentRate extends StatelessWidget {
  final double approvedTotal;
  final double pending;

  const AnimatedPaymentRate({
    Key? key,
    required this.approvedTotal,
    required this.pending,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paymentRate = (approvedTotal / (pending + approvedTotal)) * 100;

    Color determineColor(double rate) {
      if (rate > 60) return Colors.lightGreenAccent;
      if (rate > 40) return Colors.amberAccent;
      return Colors.redAccent;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: paymentRate),
      duration: const Duration(seconds: 2),
      builder: (context, animatedValue, child) {
        return FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "${animatedValue.toStringAsFixed(2)}%",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: determineColor(animatedValue),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedStatisticsContainer extends StatelessWidget {
  final double pending;
  final double approvedTotal;
  final bool isLoading;
  final String? errorMessage;

  const AnimatedStatisticsContainer({
    Key? key,
    required this.pending,
    required this.approvedTotal,
    this.isLoading = false,
    this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Text(
          'Erro: $errorMessage',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnimatedValueRow(
            "Valor em aberto",
            pending,
          ),
          const SizedBox(height: 16),
          _buildAnimatedValueRow(
            "Total Recebido",
            approvedTotal,
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedValueRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: value),
          duration: const Duration(seconds: 2),
          builder: (context, animatedValue, child) {
            return Text(
              formatToBrl(animatedValue),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          },
        ),
      ],
    );
  }

  String formatToBrl(double value) {
    final format = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return format.format(value);
  }
}
