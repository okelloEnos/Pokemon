//
//
// import 'package:britam/features/auto_debit/auto_debit_barrel.dart';
// import 'package:britam/features/auto_debit/domain/entities/auto_debit_entity.dart';
//
// import '../../domain/entities/set_up_entity.dart';
// import '../../domain/repository/auto_debit_repository.dart';
// import '../datasources/auto_debit_remote_data_source.dart';
// import '../models/set_up_model.dart';
//
// class AutoDebitRepositoryImpl implements AutoDebitRepository{
//   final AutoDebitRemoteDataSource _remoteDataSource;
//
//   AutoDebitRepositoryImpl({required AutoDebitRemoteDataSource remoteDataSource}) :
//         _remoteDataSource = remoteDataSource ;
//
//   @override
//   Future<void> addNewAutoDebit({required SetUpEntity entity}) {
//     return _remoteDataSource.addNewAutoDebit(model: SetUpModel.fromEntity(entity: entity));
//   }
//
//   @override
//   Future<List<AutoDebitModel>> fetchAutoDebits({required String nationalId}) {
//     return _remoteDataSource.fetchAutoDebits(nationalId: nationalId);
//   }
//
//   @override
//   Future<void> cancelAutoDebit({required AutoDebitEntity autoDebit}) {
//     return _remoteDataSource.cancelAutoDebit(autoDebit: AutoDebitModel.fromEntity(entity: autoDebit));
//   }
//
//
//
// }