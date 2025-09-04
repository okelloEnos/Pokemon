//
// import 'package:britam/features/auto_debit/domain/entities/auto_debit_entity.dart';
//
// import '../repository/auto_debit_repository.dart';
//
// class FetchAutoDebitUseCase {
//   final AutoDebitRepository _repository;
//
//   FetchAutoDebitUseCase({required AutoDebitRepository repository}) : _repository = repository;
//
//   Future<List<AutoDebitEntity>> call({required String nationalId}) async {
//     return await _repository.fetchAutoDebits(nationalId: nationalId);
//   }
// }