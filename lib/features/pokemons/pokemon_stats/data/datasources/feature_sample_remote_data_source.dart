// import 'package:britam/core/core_barrel.dart';
// import 'package:britam/features/auto_debit/auto_debit_barrel.dart';
// import 'package:britam/features/auto_debit/data/data_barrel.dart';
// import 'package:dio/dio.dart';
// import '../../../../core/api/api.dart';
// import '../models/auto_debit_model.dart';
// import '../models/set_up_model.dart';
//
// abstract class AutoDebitRemoteDataSource {
//   Future<void> addNewAutoDebit({required SetUpModel model});
//
//   Future<List<AutoDebitModel>> fetchAutoDebits({required String nationalId});
//
//   Future<void> cancelAutoDebit({required AutoDebitModel autoDebit});
// }
//
// class AutoDebitRemoteDataSourceImpl implements AutoDebitRemoteDataSource {
//   final Dio _dio;
//
//   const AutoDebitRemoteDataSourceImpl({required Dio dio}) : _dio = dio;
//
//   @override
//   Future<void> addNewAutoDebit({required SetUpModel model}) async{
//     var url = "${Api.baseUrl}/general-module/setautodebit";
//
//     var data = model.toJson();
//
//     final response = await _dio.post(url, data: data, options: Options(headers: {
//       'Authorization':
//       'Bearer ${locator<SharedPreferencesUtil>().getValidToken()}'
//     }));
//
//     if((response.statusCode ?? 0) == 201){
//       final autoDebitResponse = response.data;
//       var customResponse = dynamicError(response: autoDebitResponse, errorText: "You could not set an auto debit");
//       return customResponse;
//     }
//     else {
//       throw("${response.statusMessage}");
//     }
//   }
//
//   @override
//   Future<List<AutoDebitModel>> fetchAutoDebits({required String nationalId}) async{
//     var url = "${Api.baseUrl}/autodebitresponses/$nationalId";
//
//     final response = await _dio.get(url, options: Options(headers: {
//       'Authorization':
//       'Bearer ${locator<SharedPreferencesUtil>().getValidToken()}'
//     }));
//
//     if((response.statusCode ?? 0) == 200){
//       List<AutoDebitModel> listOfAutoDebits = [];
//       listOfAutoDebits = List<AutoDebitModel>.from(response.data.map((e) => AutoDebitModel.fromJson(e)));
//       return listOfAutoDebits;
//     }
//     else {
//       throw("${response.statusMessage}");
//     }
//   }
//
//   @override
//   Future<void> cancelAutoDebit({required AutoDebitModel autoDebit}) async{
//     var url = "${Api.baseUrl}/general-module/cancelautodebit";
//     var cyberUrl = "https://api.cybersource.com/rbs/v1/subscriptions/${autoDebit.subscriptionId}/cancel";
//
//     await _dio.post(cyberUrl);
//
//     var data = autoDebit.toJson();
//     final response = await _dio.post(url, data: data);
//
//     if((response.statusCode ?? 0) == 201){
//       final cancelAutoDebitResponse = response.data;
//       dynamicError(response: cancelAutoDebitResponse, errorText: "Could not cancel auto debit");
//     }
//     else {
//       throw("${response.statusMessage}");
//     }
//   }
//
// }