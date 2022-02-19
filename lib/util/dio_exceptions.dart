import 'package:dio/dio.dart';

class DioExceptions implements Exception{

  String? message;

  DioExceptions.fromDioError(DioError dioError){
    switch(dioError.type){
      case DioErrorType.cancel:
        message = "Request to API Server was Cancelled";
        break;
      case DioErrorType.connectTimeout:
        message = "Connection TimeOut with API Server";
        break;
      case DioErrorType.other:
        message = "Connection to API Server Failed due to Internet Connection";
        break;
      case DioErrorType.receiveTimeout:
        message = "Receive Timeout in connection with API Server";
        break;
      case DioErrorType.sendTimeout:
        message = "Send Timeout in connection with API Server";
        break;
      case DioErrorType.response:
        message = _handleError(dioError.response!.statusCode!, dioError.response!.data);
        break;
      default:
        message = "Something Went Wrong";
        break;
    }
  }

  String _handleError(int statusCode, dynamic error){
    switch(statusCode){
      case 400:
        return "Bad Request";

      case 404:
        return "Pokemons Page Not Found";

      case 500:
        return "Internal Server Error";

      default:
        return "Something Went wrong ";
    }
  }

  @override
  String toString() {
    return message!;
  }
}