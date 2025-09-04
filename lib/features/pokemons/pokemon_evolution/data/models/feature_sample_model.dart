// import 'package:britam/core/core_barrel.dart';
// import 'package:britam/features/auto_debit/domain/entities/auto_debit_entity.dart';
//
// class AutoDebitModel extends AutoDebitEntity{
//   const AutoDebitModel({super.policyNumber, super.idNumber, super.subscriptionId, super.id, super.version,
//    super.accountNumber, super.firstDeductionDate, super.amount, super.cancelReason, super.comments});
//
//   factory AutoDebitModel.fromJson(Map<String, dynamic> json) {
//     return AutoDebitModel(
//       policyNumber: json['merchantReferenceCode'],
//       id: json['_id'],
//       idNumber: json['id_number'],
//       subscriptionId: json['subscriptionID'],
//       version: "${json['__v']}",
//       accountNumber: json['account_number'],
//       firstDeductionDate: json['first_deduction_date'],
//       amount: thousandNumberFormat("${json['total_amount']}"),
//       cancelReason: json['cancel_reason'],
//       comments: json['comments'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'merchantReferenceCode': policyNumber,
//       '_id': id,
//       'id_number': idNumber,
//       'subscriptionID': subscriptionId,
//       '__v': version,
//       'account_number': accountNumber,
//       'first_deduction_date': firstDeductionDate,
//       'total_amount': cleanNumbers(amount ?? "0"),
//       'cancel_reason': cancelReason,
//       'comments': comments,
//     };
//   }
//
//   static AutoDebitModel fromEntity({required AutoDebitEntity entity}) {
//     return AutoDebitModel(
//       policyNumber: entity.policyNumber,
//       idNumber: entity.idNumber,
//       subscriptionId: entity.subscriptionId,
//       id: entity.id,
//       version: entity.version,
//       accountNumber: entity.accountNumber,
//       firstDeductionDate: entity.firstDeductionDate,
//       amount: entity.amount,
//       cancelReason: entity.cancelReason,
//       comments: entity.comments,
//     );
//   }
//
// }