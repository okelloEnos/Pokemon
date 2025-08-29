// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get_it/get_it.dart';
// import 'package:rido_v2/core/core_barrel.dart';
// import 'package:rido_v2/core/data/repository/shared_prefs_repository_impl.dart';
// import 'package:rido_v2/core/di/features_access_di.dart';
// import 'package:rido_v2/core/util/functions/custom_functions.dart';
// import 'package:rido_v2/core/util/functions/values_conversion.dart';
// import 'package:rido_v2/features/global/collected_data/collected_data.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dio/dio.dart';
// import '../util/constants/values.dart';
//
// Future<void> invokeCoreDI({required GetIt locator}) async {
//   /// Shared preferences
//   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//   locator.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
//
//   /// Firebase
//   locator.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
//
//   locator.registerLazySingleton<SharedPrefsRepositoryImpl>(
//       () => SharedPrefsRepositoryImpl());
//
//   /// DIO
//   locator.registerLazySingleton<Dio>(() {
//     // return Dio(BaseOptions(
//     //     baseUrl: baseUrl,
//     //     receiveDataWhenStatusError: true,
//     //     connectTimeout: connectionTimeout,
//     //     sendTimeout: sendTimeout,
//     //     receiveTimeout: receiveTimeout,
//     //     contentType: 'application/json',
//     // ));
//
//     final dio = Dio(BaseOptions(
//       baseUrl: baseUrl,
//       receiveDataWhenStatusError: true,
//       connectTimeout: const Duration(seconds: 10),
//       sendTimeout: const Duration(seconds: 10),
//       receiveTimeout: const Duration(seconds: 10),
//       contentType: 'application/json',
//     ));
//
//     dio.interceptors.add(InterceptorsWrapper(
//       onError: (DioException e, ErrorInterceptorHandler handler) async {
//         if (e.response?.statusCode == 401) {
//
//           timeoutCallback();
//
//           // locator.get<SharedPrefsRepositoryImpl>().setLoginToken(token: '');
//           locator.get<SharedPrefsRepositoryImpl>().clearPreferences();
//
//           appRouter.go('/login');
//         }
//
//         return handler.next(e);
//       },
//     ));
//
//     return dio;
//   });
//
//   /// Collected data
//   locator.registerLazySingleton(() => CollectedData());
//
//   /// core di's
//   invokeFeaturesAccessDI(locator: locator);
// }
