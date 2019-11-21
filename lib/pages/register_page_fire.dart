import 'dart:convert' as JSON;

import 'package:TonTin/core/models/productModel.dart';
import 'package:TonTin/core/viewmodels/CRUDModel.dart';
import 'package:TonTin/item/account.dart';
import 'package:TonTin/item/login_token.dart';
import 'package:TonTin/ui/views/home_list.dart';
import 'package:TonTin/util/AESImpl.dart';
import 'package:TonTin/util/NetworkService.dart';
import 'package:TonTin/util/constant.dart';
import 'package:TonTin/util/share_pref.dart';
import 'package:TonTin/util/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibrate/vibrate.dart';


class RegisterPage extends StatefulWidget {
  static String tag = 'register-page';
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();


  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();

  }
  bool submitting = false;

  void toggleSubmitState() {

    setState(() {
      submitting = !submitting;
    });
  }



  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<CRUDModel>(context);


    final logo = Hero(
      tag: 'hero_4',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Icon(Icons.wifi_tethering, size: 90.0, color: Colors.white,),
      ),
    );

    final email = TextFormField(
      controller: userNameController,
      keyboardType: TextInputType.phone,
      autofocus: false,
      style:  TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.smartphone,
          color: Colors.white70,
        ),
        hintText: 'Phone Number',
        hintStyle: TextStyle(color: Colors.white70),
        hoverColor: Colors.transparent,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),

        border:OutlineInputBorder(
          gapPadding: 32.0,
          borderRadius:  BorderRadius.all(Radius.circular(24.0)),
          borderSide: const BorderSide(color: Colors.white, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
          borderSide: BorderSide(width: 1,color: Colors.white70),
        ),


      ),
    );

    final password = TextFormField(
      controller: passwordController,
      autofocus: false,
      keyboardType: TextInputType.number,
      maxLength: 4,
      obscureText: true,
      style:  TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.security,
          color: Colors.white70,
        ),
        hintText: 'Password',
        hintStyle: TextStyle(color: Colors.white70),
        hoverColor: Colors.transparent,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),

        border:OutlineInputBorder(
          gapPadding: 32.0,
          borderRadius:  BorderRadius.all(Radius.circular(24.0)),
          borderSide: const BorderSide(color: Colors.white, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
          borderSide: BorderSide(width: 1,color: Colors.white70),
        ),


      ),
    );
    final passwordConfirm = TextFormField(
      controller: passwordConfirmController,
      autofocus: false,
      maxLength: 4,
      style:  TextStyle(color: Colors.white),
      keyboardType: TextInputType.number,
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.security,
          color: Colors.white70,
        ),
        hintText: 'Confirm Password',
        hintStyle: TextStyle(color: Colors.white70),
        hoverColor: Colors.transparent,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),

        border:OutlineInputBorder(
          gapPadding: 32.0,
          borderRadius:  BorderRadius.all(Radius.circular(24.0)),
          borderSide: const BorderSide(color: Colors.white, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
          borderSide: BorderSide(width: 1,color: Colors.white70),
        ),


      ),
    );

    var progressBar = new Container(
      decoration: new BoxDecoration(color: Colors.transparent),
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
          //toggleSubmitState();
          validateData(userProvider);

        },

        padding: EdgeInsets.all(12),
        color: Colors.blueAccent,
        child: Text(submitting ? 'Loading' : 'Go Now', style: TextStyle(color: Colors.white)),
      ),
    );

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [

                Color(0xFF1b1e44),
                Color(0xFF2d3447),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              tileMode: TileMode.clamp)),
      child: new Scaffold(
        backgroundColor: Colors.transparent,
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
              SizedBox(height: 8.0),
              passwordConfirm,
              SizedBox(height: 24.0),
              loginButton,


            ],
          ),
        ),
      ),
    );
  }

  Future<bool> localAuth() async {
    var localAuth = LocalAuthentication();
    bool didAuthenticate =
        await localAuth.authenticateWithBiometrics(
      localizedReason: 'Authenticate for Next Login',stickyAuth: true,useErrorDialogs: true,);
    return didAuthenticate;
  }

  Future validateData(CRUDModel userProvider) async {




    var pw = passwordController.text.trim();
    var conPW = passwordConfirmController.text.trim();
    var phone = userNameController.text.trim();

    if( pw.isEmpty ||   conPW.isEmpty || phone.isEmpty ){
      Utils.showToast(context, "Please Fill All Infomation");
      return;
    }
    if(pw != conPW){
      Utils.showToast(context, "Password and Confirm Password does not match");
      return;
    }
    var addLocalAuth = await localAuth();

      var data = new Users(password: pw, phone: phone, createOn:  new DateTime.now().millisecondsSinceEpoch, fingerPrint:  addLocalAuth);
      setState(() {
        submitting = true;
      });
      var resultUser =  userProvider.addUser(data);
      resultUser.then((res){

        var userID =  userProvider.getUserID(phone, pw);
        userID.then((f){
          setState(() {
            submitting = false;
          });
          if(f.id == null){
            Utils.showToast(context, "There is an Error, Please Try Again");
            return;
          }

          _prefs.then((SharedPreferences prefs){
            prefs.setBool(PrefUtil.KEY_LOCAL_AUTH, addLocalAuth);
            prefs.setString(PrefUtil.KEY_USER_ID, f.id);
            prefs.setBool(PrefUtil.KEY_HAS_ACC, true);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>ListPage(title : 'Persona ', userID: f.id,)));
          });

      }, onError: (f){
        setState(() {
          submitting = false;
        });
        Utils.showToast(context, "There is an Error, Please Try Again");
      });



    });



  }






}
