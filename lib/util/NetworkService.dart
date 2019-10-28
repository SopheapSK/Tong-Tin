
import 'dart:io';

import 'package:TonTin/item/login_token.dart';
import 'package:TonTin/item/response.dart';
import 'package:TonTin/util/AESImpl.dart';
import 'package:TonTin/util/constant.dart';
import 'package:TonTin/util/share_pref.dart';
import 'package:dio/dio.dart';
import 'dart:convert' as JSON;

import 'package:shared_preferences/shared_preferences.dart';

class NetworkUtil {

  static Future<ResponseUtils> makeRequestWithToken(String url, String data, Method method) async{

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    var tokenTime = await  _prefs.then((SharedPreferences prefs){
      return (prefs.getInt(PrefUtil.TOKEN_TIME) ?? 0);
    });
    var token = await  _prefs.then((SharedPreferences prefs){
      return (prefs.getString(PrefUtil.ACCESS_TOKEN) ?? "");
    });
    var currentTime = new DateTime.now().millisecondsSinceEpoch;
    var remainTime = currentTime - tokenTime;
    bool isTokenExpired = (remainTime >= 1000 * 30) || remainTime < 0;

    print('TOKEN_ $tokenTime');

    ResponseUtils responseUtils;
    Response response;
    Dio dio = new Dio();

    isTokenExpired = true;
    dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options) async {

          if(isTokenExpired){
            print("INTERCEPT START");
            print('send request：path:${options.path}，baseURL:${options.baseUrl}');
            // If no token, request token firstly and lock this interceptor
            // to prevent other request enter this interceptor.
            dio.lock();
            dio.interceptors.requestLock.lock();
            // We use a new Dio(to avoid dead lock) instance to request token.
            var response =  refreshToken(Global.TOKEN_LOGIN_URL);
            print("Hello $response");
            print(
                'continue to perform request：path:${options.path}，baseURL:${options.path}');
            return response.then((header){
              options.headers["Authorization"] = "bearer" +  header;
              dio.interceptors.requestLock.unlock();
              return options; //continue
            }).whenComplete(() {
              dio.unlock();
              dio.interceptors.requestLock.lock();
            }); // unlock the dio

          } else {
            options.headers['Authorization'] = "bearer $token";
            return options;
          }



        }
    ));

    dio.options.baseUrl = Global.BASE_URL;
    if(method == Method.GET){
      try {

        if(data != null) {
          final model = JSON.jsonDecode(data);
          response = await dio.get(url, queryParameters: model);
        }else {
          response = await dio.get(url);
        }

      } on DioError catch(e) {
        print(e);
        if(e.response !=  null) {
          print("error with res " +e.response.toString());
          responseUtils = new ResponseUtils(response: null, error: e.response.toString());
        }else {
          print("error no res");
          // it might be internet connection
          responseUtils = new ResponseUtils(response: null, error:  "");
        }
        return responseUtils;
      }
    }else if(method == Method.POST){
      print("Post Method");
      try {
        if (data != null) {
          final model = JSON.jsonDecode(data);
          response = await dio.post(url, data: model);
        }
      } on DioError catch(e){
        print(e);
        if(e.response !=  null) {
          print("error with res " + e.response.toString());
          responseUtils = new ResponseUtils(response: null, error: e.response.toString());
        }else {
          print("error no res");
          // it might be internet connection
          responseUtils = new ResponseUtils(response: null, error:  "");
        }
        return responseUtils;
      }

    }

    print("return here?");
    if(response.statusCode == 200){
      var res = JSON.jsonEncode(response.data);
      print("return 200? " + res);
      return responseUtils = new ResponseUtils(response: res, error: null);
    }
    print("return  not 200? " + response.data);
    return responseUtils = new ResponseUtils(response: null, error: response.data);

  }
  static Future<ResponseUtils> makeRequest(String url, String data, String header, Method method) async{
    ResponseUtils responseUtils;
    Response response;
    Dio dio = new Dio();
    dio.options.baseUrl = Global.BASE_URL;
    dio.options.headers['Authorization'] = "bearer $header";
    if(method == Method.GET){
      try {


        if(data != null) {
          final model = JSON.jsonDecode(data);
          response = await dio.get(url, queryParameters: model);
        }else {
          response = await dio.get(url);
        }

      } on DioError catch(e) {
        print(e);
        if(e.response !=  null) {
          print("error with res " +e.response.toString());
          responseUtils = new ResponseUtils(response: null, error: e.response.toString());
        }else {
          print("error no res");
          // it might be internet connection
          responseUtils = new ResponseUtils(response: null, error:  "");
        }
        return responseUtils;
      }
    }else if(method == Method.POST){
      print("Post Method");
      try {
        if (data != null) {
          final model = JSON.jsonDecode(data);
          response = await dio.post(url, data: model);
        }
      } on DioError catch(e){
        print(e);
        if(e.response !=  null) {
          print("error with res");
          responseUtils = new ResponseUtils(response: null, error: e.response.toString());
        }else {
          print("error no res");
          // it might be internet connection
          responseUtils = new ResponseUtils(response: null, error:  "");
        }
        return responseUtils;
      }

    }

    print("return here?");
    if(response.statusCode == 200){
      var res = JSON.jsonEncode(response.data);
      print("return 200?");
      return responseUtils = new ResponseUtils(response: res, error: null);
    }
    print("return  not 200?");
    return responseUtils = new ResponseUtils(response: null, error: response.data);

  }

  static Future<ResponseUtils> requestToken(String url, Token param) async{

    Dio dio = new Dio();
    dio.options.baseUrl = Global.BASE_URL;
    dio.options.contentType= ContentType.parse("application/x-www-form-urlencoded");

    Response response;
    ResponseUtils responseUtils;

    try{
      if(param != null){

        //final model = JSON.jsonDecode(data);
        FormData formData = new FormData.from({

          "username": param.username,
          "password" : param.password,
          "grant_type" : param.grantType,
          "client_id" : param.clientId,
          "client_secret" : param.clientSecret,
          "client_version" : param.clientVersion,
          "application_id" : param.applicationId,
          "device_id" : param.deviceId

        });

        /*

        dio.interceptors.add(InterceptorsWrapper(
            onRequest:(RequestOptions options){
              // Do something before request is sent
              print(options.contentType.toString());
              print(options.data.toString());
              print(options.toString());
              return options; //continue
              // If you want to resolve the request with some custom data，
              // you can return a `Response` object or return `dio.resolve(data)`.
              // If you want to reject the request with a error message,
              // you can return a `DioError` object or return `dio.reject(errMsg)`
            },
            onResponse:(Response response) {
              // Do something with response data
              return response; // continue
            },
            onError: (DioError e) {
              // Do something with response error
              return  e;//continue
            }
        ));
        */

        response = await dio.post(url, data: param.toJson());
      }

    } on DioError catch(e) {
      //return e;
      print(e);

      if(e.response !=  null) {
        print("error with res");
        responseUtils = new ResponseUtils(response: null, error: e.response.toString());
      }else {
        print("error no res");
        // it might be internet connection
        responseUtils = new ResponseUtils(response: null, error:  "");
      }
      return responseUtils;
    }

    print("return here?");
    if(response.statusCode == 200){
      var res = JSON.jsonEncode(response.data);
      print("return 200?");
      return responseUtils = new ResponseUtils(response: res, error: null);
    }
    print("return  not 200?");
    return responseUtils = new ResponseUtils(response: null, error: response.data);

  }
  static Future<ResponseUtils> requestNewToken(String url) async{
    print('==== START TOKEN =====');
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    var tokenSave = await  _prefs.then((SharedPreferences prefs){
      return (prefs.getString(PrefUtil.REFRESH_TOKEN) ?? "");
    });

    print('TOKEN_ $tokenSave');




    var param =  new Token(refreshToken: tokenSave,
        grantType: "refresh_token",
        clientId: "mobileapps_android",
        clientSecret: "16681c9ff419d8ecc7cfe479eb02a7a",
        clientVersion: "1232",
        applicationId: "WCX_PORTAL_APP",
        deviceId: "123456789"

    );


    Dio dio = new Dio();
    dio.options.baseUrl = Global.BASE_URL;
    dio.options.contentType= ContentType.parse("application/x-www-form-urlencoded");

    Response response;
    ResponseUtils responseUtils;

    try{
      if(param != null){
        response = await dio.post(url, data: param.toJson());
      }

    } on DioError catch(e) {
      //return e;
      print(e);

      if(e.response !=  null) {
        print("error with res"   + e.response.toString());
        responseUtils = new ResponseUtils(response: null, error: e.response.toString());
      }else {
        print("error no res ");
        // it might be internet connection
        responseUtils = new ResponseUtils(response: null, error:  "");
      }
      return responseUtils;
    }

    print("return here?");
    if(response.statusCode == 200){
      var res = JSON.jsonEncode(response.data);
      print("return 200?");
      return responseUtils = new ResponseUtils(response: res, error: null);
    }
    print("return  not 200?");
    return responseUtils = new ResponseUtils(response: null, error: response.data);

  }
  static Future<String> refreshToken(String url) async{
    print('==== START TOKEN =====');
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    var tokenSave = await  _prefs.then((SharedPreferences prefs){
      return (prefs.getString(PrefUtil.REFRESH_TOKEN) ?? "");
    });

    print('TOKEN_ $tokenSave');

    var param =  new Token(refreshToken: tokenSave,
        grantType: "refresh_token",
        clientId: "mobileapps_android",
        clientSecret: "16681c9ff419d8ecc7cfe479eb02a7a",
        clientVersion: "1232",
        applicationId: "WCX_PORTAL_APP",
        deviceId: "123456789"

    );
    Dio dio = new Dio();
    dio.options.baseUrl = Global.BASE_URL;
    dio.options.contentType= ContentType.parse("application/x-www-form-urlencoded");
    Response response =  await dio.post(url, data: param.toJson());

    if(response.statusCode == 200){
      var res = JSON.jsonEncode(response.data);
      print("we got successs " + res);

      var token = AESUtil.parseJwt(res);
      var tokenData = token['token'];

      var tokenDecrypt = AESUtil.decryptAES(tokenData, Global.KEY_AES);

      print(tokenDecrypt);

      var header = JSON.jsonDecode(tokenDecrypt);

      var accessToken = header['access_token'];
      // var refreshToken = header['refresh_token'];

      // save access token and refresh token
      _prefs.then((SharedPreferences prefs){
        prefs.setString(PrefUtil.ACCESS_TOKEN, accessToken);
        prefs.setInt(PrefUtil.TOKEN_TIME, new DateTime.now().millisecondsSinceEpoch);

        // prefs.setString(PrefUtil.REFRESH_TOKEN, refreshToken);

      });

      return accessToken;
    }


    return "";
  }



}

enum Method{
  GET,
  POST
}