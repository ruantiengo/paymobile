import 'package:pay/core/domain/entity/branch_entity.dart';

abstract class BranchState {}

class BranchInitial extends BranchState {}

class BranchLoading extends BranchState {}

class BranchLoaded extends BranchState {
  final List<BranchEntity> branches;

  BranchLoaded(this.branches);
}

class BranchError extends BranchState {
  final String message;

  BranchError(this.message);
}
