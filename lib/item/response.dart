
 import 'package:dio/dio.dart';

class ResponseUtils {

  /*
      if _error = null, it mean there is no error
      if _error = "", it mean it has error with DEFAULT,  CONNECT TIME OUT ...
      if _error = "..." it has error
   */

  String _successResponse;
  String _error;

  ResponseUtils({String response, String error}){
    _successResponse = response;
    _error = error;
  }

  String getSuccessResponse(){

    return _successResponse;
  }

  String getErrorResponse(){
    //if(_error == null) return "";

    return _error;
  }

 }