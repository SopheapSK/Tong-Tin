import 'dart:convert' as JSON;

import 'package:TonTin/item/account.dart';
import 'package:TonTin/item/login_token.dart';
import 'package:TonTin/util/AESImpl.dart';
import 'package:TonTin/util/NetworkService.dart';
import 'package:TonTin/util/constant.dart';
import 'package:TonTin/util/share_pref.dart';
import 'package:TonTin/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibrate/vibrate.dart';


class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();


  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();

  }
  bool submitting = false;

  void toggleSubmitState() {

    print(("update -> $submitting"));
    setState(() {
      submitting = !submitting;
    });
  }
  /*

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: !submitting
            ? new Container(
          color: Colors.white,
        )
            : const Center(child: const CircularProgressIndicator()),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.refresh),
        onPressed: toggleSubmitState,
      ),
    );
  }
  */



  @override
  Widget build(BuildContext context) {



    final logo = Hero(
      tag: 'hero_4',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final email = TextFormField(
      controller: userNameController,
      keyboardType: TextInputType.phone,
      autofocus: false,

      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      controller: passwordController,
      autofocus: false,
      keyboardType: TextInputType.number,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    var progressBar = new Container(
      decoration: new BoxDecoration(color: Colors.white),
      child: new Center(
        child: new CircularProgressIndicator(),
      ),
    );

    var loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          toggleSubmitState();
          _tokeTask(context);
        },
        // onPressed: () {
        // Navigator.of(context).pushNamed(HomePage.tag);
        // Navigator.of(context).pushNamed(DrawerSlideWithHeader.tag);
        //toggleSubmitState();
        // FocusScope.of(context).requestFocus(new FocusNode());
        //_tokeTask(context);
        // },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text(submitting ? 'Loading' : 'Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: ()  {

       // Navigator.pushReplacementNamed(context, DrawerSlideWithHeader.tag);
        //Navigator.pushReplacementNamed(context, "WingPay");
        Navigator.pushNamed(context, '/home');

      },

    );

    return new Scaffold(
      backgroundColor: Colors.white,
      body:   new Center(
        child: submitting ? progressBar : ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            forgotLabel,


          ],
        ),
      ),
    );
  }

  void _tokeTask(BuildContext context){

    // startProgressBar(true);
    // print("data -> " + tokeData());
    var data =   NetworkUtil.requestToken(Global.TOKEN_LOGIN_URL , token());
    data.then((result) {
      //Utils.showToastError(context, result);
      //print("response data-> " +  result);

      // if network error, result.response will be null


      if(result.getSuccessResponse() != null){
        // success, do sth here
        print("we got successs " + result.getSuccessResponse());

        var token = AESUtil.parseJwt(result.getSuccessResponse());
        var tokenData = token['token'];

        var tokenDecrypt = AESUtil.decryptAES(tokenData, Global.KEY_AES);

        print(tokenDecrypt);

        var header = JSON.jsonDecode(tokenDecrypt);

        var accessToken = header['access_token'];
        var refreshToken = header['refresh_token'];
        print('REFRESH_TOKEN_ $refreshToken');

        // save access token and refresh token
        _prefs.then((SharedPreferences prefs){
          prefs.setString(PrefUtil.ACCESS_TOKEN, accessToken);
          prefs.setInt(PrefUtil.TOKEN_TIME, new DateTime.now().millisecondsSinceEpoch);

          prefs.setString(PrefUtil.REFRESH_TOKEN, refreshToken);

        });

        var tokenSave =  _prefs.then((SharedPreferences prefs){
          return (prefs.getString(PrefUtil.REFRESH_TOKEN) ?? "");
        });
        tokenSave.then((_) {
          print('TOKEN_ $_');
        }
        );
          Global.HEADER = accessToken;
        _loginTask(context, accessToken );


      }else {
        toggleSubmitState();

        if(result.getErrorResponse() != null){
          // do sth here,

          if(result.getErrorResponse() != ""){
            print("Error with Data " +result.getErrorResponse());
            Utils.showToastError(context, Utils.messageErrorController(result.getErrorResponse()));
            return;
          }

          print("Gerneral Error " + result.toString());
          Utils.showToastError(context, "Network Connection Error");

        }
      }

    }, onError: (e){
      print("error-> " + e.toString());
    });


  }
  void _loginTask(BuildContext context, String header){
    var data =   NetworkUtil.makeRequest(Global.END_LOGIN_URL , loginData(), header, Method.POST);
    data.then((result){
      toggleSubmitState();
      if(result.getSuccessResponse() != null){
        // success, do sth here
        print("we got successs " + result.getSuccessResponse());
        _handleResponseLoginData(result.getSuccessResponse());
        //Navigator.of(context).pushNamed(DrawerSlideWithHeader.tag);
        _startHaptic();
       // Navigator.pushReplacementNamed(context, DrawerSlideWithHeader.tag);
        Navigator.pushNamed(context, '/home');

      }else {

        if(result.getErrorResponse() != null){
          // do sth here,

          if(result.getErrorResponse() != ""){
            print("Error with Data " +result.getErrorResponse());
            Utils.showToastError(context, Utils.messageErrorController(result.getErrorResponse()));
            return;
          }

          print("Gerneral Error " + result.toString());
          Utils.showToastError(context, "Network Connection Error");

        }
      }
    });
  }

  String  tokeData() {
    var data =  new Token(refreshToken: "",
        username: userNameController.text,
        password: AESUtil.encryptAES(passwordController.text, Global.KEY_AES),
        grantType: "password",
        clientId: "mobileapps_android",
        clientSecret: "16681c9ff419d8ecc7cfe479eb02a7a",
        clientVersion: "1232",
        applicationId: "WCX_PORTAL_APP",
        deviceId: "123456789"

    );

    var mapData = data.toJson();
    return JSON.jsonEncode(mapData);


    //return data.toMap().toString();
  }
  Token  token() {
    var data =  new Token(refreshToken: "",
        username: userNameController.text,
        password: AESUtil.encryptAES(passwordController.text, Global.KEY_AES),
        grantType: "password",
        clientId: "mobileapps_android",
        clientSecret: "16681c9ff419d8ecc7cfe479eb02a7a",
        clientVersion: "223344",
        applicationId: "MWX_PORTAL_APP",
        deviceId: "123456789"

    );

    return data;


    //return data.toMap().toString();
  }

  Future _startHaptic() async {
    var canVibrate = await Vibrate.canVibrate;
    if(canVibrate) {
      var _type = FeedbackType.success;
      Vibrate.feedback(_type);
    }
  }
  String loginData(){
    Map me = ({
      "username" : userNameController.text,
      "password" : AESUtil.encryptAES(passwordController.text, Global.KEY_AES),
      "notification_id" : 1,
      "device_id" : "123456789",
      "os_version" : "",
      "device_name" : "Samsung",
      "application_id" : "MWX_PORTAL_APP",
      "notification_id" : "one_signal_id",
    });

    return JSON.jsonEncode(me);
  }
  void _handleResponseLoginData(String response){
    Global.accountItem.clear();
    Map accountData = JSON.jsonDecode(response);
    if(accountData.containsKey("account_id")){
      // save account id for later
    }

    List<dynamic> accountInside = accountData['accounts'];
    //var accountJson = JSON.jsonDecode(accountInside);

    for(int i = 0 ; i < accountInside.length ; i++){
      AccountItem accountItem = AccountItem.fromJson(accountInside[i]);
      Global.accountItem.add(accountItem);
      print(accountItem.toString());
    }

    //userNameController.clear();
    passwordController.clear();




  }





}
