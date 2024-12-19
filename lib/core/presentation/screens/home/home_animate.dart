import 'package:flutter/material.dart';
import 'package:pay/utils/colors.dart';
import 'package:pay/utils/format.dart';

class AnimatedStatsGroup extends StatelessWidget {
  final List<Map<String, dynamic>> stats;

  const AnimatedStatsGroup({Key? key, required this.stats}) : super(key: key);

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
            // Use formatToBRL para valores monetários
            final formattedValue = stat['suffix'] == null
                ? formatToBRL(animatedValue)
                : "${animatedValue.toStringAsFixed(2)}${stat['suffix']}";

            return _buildStatItem(
              stat['label'],
              formattedValue,
              highlight: stat['highlight'] ?? false,
              color: stat['color'],
            );
          },
        );
      },
    );
  }

  Widget _buildStatItem(String title, String value, {bool highlight = false, Color? color}) {
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
              color: highlight ? Colors.red : color ?? Colors.black,
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
              formatToBRL(animatedValue),
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
}
