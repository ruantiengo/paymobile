class BankSlipModel {
  final String id;
  final String erpId;
  final String status;
  final double total;
  final String buyerName;
  final String buyerDocument;
  final DateTime dueDate;
  final DateTime expeditionDate;
  final DateTime expirationDate;
  final DateTime? paymentDate;

  BankSlipModel({
    required this.id,
    required this.erpId,
    required this.status,
    required this.total,
    required this.buyerName,
    required this.buyerDocument,
    required this.dueDate,
    required this.expeditionDate,
    required this.expirationDate,
    this.paymentDate,
  });

  factory BankSlipModel.fromJson(Map<String, dynamic> json) {
    return BankSlipModel(
      id: json['id'],
      erpId: json['erp_id'],
      status: json['status'],
      total: json['total'].toDouble(),
      buyerName: json['buyer_name'],
      buyerDocument: json['buyer_document'],
      dueDate: DateTime.parse(json['due_date']),
      expeditionDate: DateTime.parse(json['expedition_date']),
      expirationDate: DateTime.parse(json['expiration_date']),
      paymentDate: json['payment_date'] != null
          ? DateTime.parse(json['payment_date'])
          : null,
    );
  }
}
