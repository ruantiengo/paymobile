import 'package:pay/core/domain/entity/branch_entity.dart';

class BranchModel extends BranchEntity {
  BranchModel({required super.id, required super.commercialName});

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'],
      commercialName: json['commercial_name'],
    );
  }
}
