import 'dart:convert' as JSON;

import 'package:TonTin/core/models/productModel.dart';
import 'package:TonTin/core/viewmodels/CRUDModel.dart';
import 'package:TonTin/item/account.dart';
import 'package:TonTin/item/login_token.dart';
import 'package:TonTin/util/AESImpl.dart';
import 'package:TonTin/util/NetworkService.dart';
import 'package:TonTin/util/constant.dart';
import 'package:TonTin/util/share_pref.dart';
import 'package:TonTin/util/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    final passwordConfirm = TextFormField(
      controller: passwordConfirmController,
      autofocus: false,
      keyboardType: TextInputType.number,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Confirm Password',
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
          //toggleSubmitState();
          validateData(userProvider);

        },

        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text(submitting ? 'Loading' : 'Go Now', style: TextStyle(color: Colors.white)),
      ),
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
            SizedBox(height: 8.0),
            passwordConfirm,
            SizedBox(height: 24.0),
            loginButton,


          ],
        ),
      ),
    );
  }


  void validateData(CRUDModel userProvider){

    if(passwordConfirmController.text.isEmpty || passwordController.text.isEmpty || userNameController.text.isEmpty){
      Utils.showToast(context, "Please Fill All Infomation");
      return;
    }

    Users data = new Users(password: passwordController.text, phone: userNameController.text, createOn:  new DateTime.now().millisecondsSinceEpoch);
    setState(() {
      submitting = true;
    });
    var result =  userProvider.addUser(data);
    result.then((res){

      setState(() {
        submitting = false;
      });
    }, onError: (f){
      setState(() {
        submitting = false;
      });
      Utils.showToast(context, "There is an Error, Please Try Again");
    });

  }






}
