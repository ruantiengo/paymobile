class Statistics {
  final double approvedTotal;
  final PaymentMethodStatistics paymentMethodStatistics;
  final double pending;
  final double expired;
  final double cancelled;

  Statistics({
    required this.approvedTotal,
    required this.paymentMethodStatistics,
    required this.pending,
    required this.expired,
    required this.cancelled,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      approvedTotal: json['approved']['total'],
      paymentMethodStatistics:
          PaymentMethodStatistics.fromJson(json['approved']['byPaymentMethod']),
      pending: (json['pending'] as num).toDouble(),
      expired: (json['expired'] as num).toDouble(),
      cancelled: (json['cancelled'] as num).toDouble(),
    );
  }
}

class PaymentMethodStatistics {
  final PaymentMethodDetail barcode;
  final PaymentMethodDetail pix;
  final PaymentMethodDetail creditCard;

  PaymentMethodStatistics({
    required this.barcode,
    required this.pix,
    required this.creditCard,
  });

  factory PaymentMethodStatistics.fromJson(Map<String, dynamic> json) {
    return PaymentMethodStatistics(
      barcode: PaymentMethodDetail.fromJson(json['barcode']),
      pix: PaymentMethodDetail.fromJson(json['pix']),
      creditCard: PaymentMethodDetail.fromJson(json['credit_card']),
    );
  }
}

class PaymentMethodDetail {
  final int count;
  final double total;

  PaymentMethodDetail({
    required this.count,
    required this.total,
  });

  factory PaymentMethodDetail.fromJson(Map<String, dynamic> json) {
    final total = (json['total'] as num).toDouble();
    return PaymentMethodDetail(
      count: json['count'],
      total: total,
    );
  }
}
