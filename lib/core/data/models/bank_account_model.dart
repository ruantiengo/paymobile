import 'package:pay/core/domain/entity/bank_account_entity.dart';

class BankAccountModel extends BankAccount {
  BankAccountModel({
    required String id,
    required String tenantId,
    required String name,
    required String documentNumber,
    String? walletNumber,
    required int convenantCode,
    required String agency,
    required int accountNumber,
    required int accountDigit,
    required String pixDictKey,
    required String pixDictKeyType,
    required String bank,
    required String createdBy,
    required DateTime createdAt,
    String? updatedBy,
    DateTime? updatedAt,
  }) : super(
          id: id,
          tenantId: tenantId,
          name: name,
          documentNumber: documentNumber,
          walletNumber: walletNumber,
          convenantCode: convenantCode,
          agency: agency,
          accountNumber: accountNumber,
          accountDigit: accountDigit,
          pixDictKey: pixDictKey,
          pixDictKeyType: pixDictKeyType,
          bank: bank,
          createdBy: createdBy,
          createdAt: createdAt,
          updatedBy: updatedBy,
          updatedAt: updatedAt,
        );

  factory BankAccountModel.fromJson(Map<String, dynamic> json) {
    return BankAccountModel(
      id: json['id'],
      tenantId: json['tenant_id'],
      name: json['name'],
      documentNumber: json['document_number'],
      walletNumber: json['wallet_number'],
      convenantCode: json['convenant_code'],
      agency: json['agency'],
      accountNumber: json['account_number'],
      accountDigit: json['account_digit'],
      pixDictKey: json['pix_dict_key'],
      pixDictKeyType: json['pix_dict_key_type'],
      bank: json['bank'],
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at']),
      updatedBy: json['updated_by'],
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}
