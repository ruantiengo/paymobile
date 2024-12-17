class BankSlip {
  final String id;
  final String erpId;
  final String branchId;
  final String status;
  final double total;
  final String buyerName;
  final String buyerDocument;
  final DateTime dueDate;
  final DateTime expeditionDate;
  final DateTime expirationDate;
  final DateTime? paymentDate;

  BankSlip({
    required this.id,
    required this.erpId,
    required this.branchId,
    required this.status,
    required this.total,
    required this.buyerName,
    required this.buyerDocument,
    required this.dueDate,
    required this.expeditionDate,
    required this.expirationDate,
    this.paymentDate,
  });

  factory BankSlip.fromJson(Map<String, dynamic> json) {
    return BankSlip(
      id: json['id'],
      erpId: json['erp_id'],
      status: json['status'],
      branchId: json['branch_id'],
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
