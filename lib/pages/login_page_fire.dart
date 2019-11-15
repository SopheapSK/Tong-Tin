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

    setState(() {
      submitting = !submitting;
    });
  }



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
        hintText: 'Phone Number',
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

        },

        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text(submitting ? 'Loading' : 'Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final registerPage = FlatButton(
      child: Text(
        'មិនទាន់មាន គណនី?​ សូមចុចទីនេះ',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: ()  {

        Navigator.pushNamed(context, '/register');

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
            registerPage,

          ],
        ),
      ),
    );
  }









}
