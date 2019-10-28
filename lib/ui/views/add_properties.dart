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


class CreateProperty extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _CreatePropertyState createState() => new _CreatePropertyState();
}

class _CreatePropertyState extends State<CreateProperty> {

  String _title, _price, _interest;

  final userNameController = TextEditingController();
  final tTitleController = TextEditingController();
  final tPriceController = TextEditingController();
  final tInterestController = TextEditingController();
  final tTotalMonthController = TextEditingController();
  final tPaidMonthController = TextEditingController();
  final tStartDateController = TextEditingController();
  final passwordController = TextEditingController();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isAutoValidate = false;

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

    final topContent = InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: 90.0,
        width: double.infinity,
        child: Row(

          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Hero( tag: 'hello_1',
                child: Icon(Icons.arrow_back, color: Colors.grey)),
          ],
        ),
      ),
    );


    final logo = Hero(
      tag: 'hero_11',
      child: Icon(Icons.wifi_tethering, size: 90.0, color: Colors.blueAccent,),
    );

    final vTitle = TextFormField(
      controller: tTitleController,
      keyboardType: TextInputType.text,
      autofocus: true,
      autovalidate: _isAutoValidate,
      autocorrect: false,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please Enter Data';
        }
        return null;
      },
      onSaved: (val) => _title = val,

      decoration: InputDecoration(
        hintText: 'ex: Land in PP, House in KPS...',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0)),
      ),
    );
    final vPrice = TextFormField(
      controller: tPriceController,
      keyboardType: TextInputType.number,
      autofocus: true,
      autovalidate: _isAutoValidate,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please Enter Data';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'ex: 12500 (\$)',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0)),
      ),
    );
    final vInterest = TextFormField(
      controller: tInterestController,
      keyboardType: TextInputType.number,
      autofocus: true,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please Enter Data';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'ex: 0.3% per month',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0)),
      ),
    );

    final vTotalMonth = TextFormField(
      controller: tTotalMonthController,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please Enter Data';
        }
        return null;
      },
      keyboardType: TextInputType.number,
      autofocus: false,
      decoration: InputDecoration(
        hintText: '24 Months = 2 Years',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0)),
      ),
    );
    final vPaidMonth = TextFormField(
      controller: tPaidMonthController,
      keyboardType: TextInputType.number,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'ex: 10 Months',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0)),
      ),
    );
    final vStartMonth = TextFormField(
      controller: tStartDateController,
      keyboardType: TextInputType.datetime,
      autofocus: false,
      decoration: InputDecoration(
        hintText: '01-01-2019',
        errorText: 'Wat',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0)),
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
    final confirmBtn = Center(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new RaisedButton(
                  onPressed: () {
                    //Navigator.pop(context);
                    setState(() {
                      _isAutoValidate = true;
                    });
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      // If the form is valid, display a Snackbar.
                      //showSnakeBar(context);
                    }

                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  color: Colors.blue,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Hero(child: new Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 24.0,
                      ), tag: 'hero_1',
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      new Text(
                        '\t\t READY?   LET\'S GO    \t\t\t',

                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ))
            ]));

    final contentBody = submitting ? Center( child: progressBar) : Form(key: _formKey, child: Container(

      margin: EdgeInsets.only(top: 10),
      child:  ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        children: <Widget>[
          topContent,
          logo,
          SizedBox(height: 28.0),
          guideLine('Your Short Title(ex: Land in PP, House in KPS)'),
          vTitle,
          SizedBox(height: 20.0),
          guideLine('Your Property\'s Price(ex: 12500) (\$)'),
          vPrice,
          SizedBox(height: 20.0),
          guideLine('Your Property\'s Interest(ex: 0.3%) (per month)'),
          vInterest,
          SizedBox(height: 20.0),
          guideLine('Total Months/Years to Pay'),
          vTotalMonth,
          SizedBox(height: 20.0),
          guideLine('How many Month(s) you paid Money? (Optional)'),
          vPaidMonth,
          SizedBox(height: 20.0),
          guideLine('When do you start Pay for First Time? (Optional)' ),
          vStartMonth,
          SizedBox(height: 20.0),
          password,
          SizedBox(height: 24.0),
          confirmBtn,
          forgotLabel,


        ],
      ),
    ));

    return new Scaffold(
      backgroundColor:  Colors.white,//Color.fromRGBO(64, 75, 96, .9),
      body:   contentBody,
    );
  }



  Future _startHaptic() async {
    var canVibrate = await Vibrate.canVibrate;
    if(canVibrate) {
      var _type = FeedbackType.success;
      Vibrate.feedback(_type);
    }
  }

}

 Widget guideLine(String description){

  return Text(description, style: TextStyle(fontSize: 12.0, color: Colors.blueAccent),);
 }

 void showSnakeBar(BuildContext context){
   Scaffold.of(context)
       .showSnackBar(SnackBar(content: Text('Processing Data')));
 }