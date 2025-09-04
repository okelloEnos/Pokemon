// import 'package:equatable/equatable.dart';
//
// class AutoDebitEntity extends Equatable{
//   final String? id;
//   final String? policyNumber;
//   final String? subscriptionId;
//   final String? idNumber;
//   final String? version;
//   final String? policyName;
//   final String? category;
//   final String? accountNumber;
//   final String? firstDeductionDate;
//   final String? amount;
//   final String? cancelReason;
//   final String? comments;
//
//   const AutoDebitEntity({this.policyNumber, this.idNumber, this.subscriptionId, this.id, this.version, this.policyName, this.category,
//     this.accountNumber, this.firstDeductionDate, this.amount, this.cancelReason, this.comments});
//
//   @override
//   List<Object?> get props => [policyNumber, idNumber, subscriptionId, id, version, policyName, category, accountNumber, firstDeductionDate, amount, cancelReason, comments];
//
//   // copy method
//   AutoDebitEntity copyWith({String? policyNumber, String? idNumber, String? subscriptionId, String? id, String? version, String? policyName, String? category,
//     String? accountNumber, String? firstDeductionDate, String? amount, String? cancelReason, String? comments}) {
//     return AutoDebitEntity(
//       policyNumber: policyNumber ?? this.policyNumber,
//       idNumber: idNumber ?? this.idNumber,
//       subscriptionId: subscriptionId ?? this.subscriptionId,
//       id: id ?? this.id,
//       version: version ?? this.version,
//       policyName: policyName ?? this.policyName,
//       category: category ?? this.category,
//       accountNumber: accountNumber ?? this.accountNumber,
//       firstDeductionDate: firstDeductionDate ?? this.firstDeductionDate,
//       amount: amount ?? this.amount,
//       cancelReason: cancelReason ?? this.cancelReason,
//       comments: comments ?? this.comments,
//     );
//   }
// }