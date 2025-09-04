import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../core_barrel.dart';

Future<void> invokeCoreDI({required GetIt locator}) async {
  /// Shared preferences
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  /// DIO
  locator.registerLazySingleton<Dio>(() {
    // return Dio(BaseOptions(
    //     baseUrl: baseUrl,
    //     receiveDataWhenStatusError: true,
    //     connectTimeout: connectionTimeout,
    //     sendTimeout: sendTimeout,
    //     receiveTimeout: receiveTimeout,
    //     contentType: 'application/json',
    // ));

    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: timeout,
      sendTimeout: timeout,
      receiveTimeout: timeout,
      contentType: 'application/json',
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onError: (DioError e, ErrorInterceptorHandler handler) async {
        if (e.response?.statusCode == 401) {
          // timeoutCallback();
          //
          // // locator.get<SharedPrefsRepositoryImpl>().setLoginToken(token: '');
          // locator.get<SharedPrefsRepositoryImpl>().clearPreferences();
          //
          // appRouter.go('/login');
        }
        else if (e.response?.statusCode == 404){
          // handle 404
          debugPrint("404 error");
        }

        return handler.next(e);
      },
    ));

    return dio;
  });
}
