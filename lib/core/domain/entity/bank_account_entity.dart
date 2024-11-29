class BankAccount {
  final String id;
  final String tenantId;
  final String name;
  final String documentNumber;
  final int? walletNumber;
  final int convenantCode;
  final String agency;
  final int accountNumber;
  final int accountDigit;
  final String pixDictKey;
  final String? pixDictKeyType;
  final String bank;
  final String createdBy;
  final DateTime createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;

  BankAccount({
    required this.id,
    required this.tenantId,
    required this.name,
    required this.documentNumber,
    this.walletNumber,
    required this.convenantCode,
    required this.agency,
    required this.accountNumber,
    required this.accountDigit,
    required this.pixDictKey,
    this.pixDictKeyType,
    required this.bank,
    required this.createdBy,
    required this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });
}
