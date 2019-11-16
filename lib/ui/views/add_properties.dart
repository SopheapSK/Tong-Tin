import 'dart:convert' as JSON;

import 'package:TonTin/core/models/productModel.dart';
import 'package:TonTin/core/viewmodels/CRUDModel.dart';
import 'package:TonTin/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibrate/vibrate.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';


class CreateProperty extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _CreatePropertyState createState() => new _CreatePropertyState();
}

class _CreatePropertyState extends State<CreateProperty> {
  final USER_ID = "xm0RJnDMeW6ggADBFKDY";
  final df = new DateFormat('dd-MM-yyyy');
  String _currentDateTime =  '';

  final tTitleController = TextEditingController();
  final tPriceController = TextEditingController();
  final tTotalPeopleController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isAutoValidate = false;

  @override
  void dispose() {
    tTitleController.dispose();
    tPriceController.dispose();
    tTotalPeopleController.dispose();

    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    if(mounted){
    setState(() {
      _currentDateTime  =  df.format(new DateTime.now());
    });
  }
  }
  bool submitting = false;

  void toggleSubmitState() {
    setState(() {
      submitting = !submitting;
    });
  }

  @override
  Widget build(BuildContext context) {

    var propertyProvider = Provider.of<CRUDModel>(context);

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
      autovalidate: _isAutoValidate,
      autocorrect: false,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please Enter Data';
        }
        return null;
      },

      decoration: InputDecoration(
        hintText: 'ex: Tong Tin 200 \$ ...',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0)),
      ),
    );
    final vPrice = TextFormField(
      controller: tPriceController,
      keyboardType: TextInputType.number,
      autovalidate: _isAutoValidate,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please Enter Data';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'ex: 200 (\$)',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0)),
      ),
    );
    final vTotalPeople = TextFormField(

      controller: tTotalPeopleController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please Enter Data';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'ex: 10 នាក់',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0)),
      ),
    );



    final vStartMonth = OutlineButton(
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(24.0)),
        onPressed: () {
          DatePicker.showDatePicker(context,
              showTitleActions: true,
              minTime: DateTime(2018, 3, 5),
              maxTime: DateTime(2099, 6, 7), onChanged: (date) {
                print('change $date');
              }, onConfirm: (date) {
                print('confirm $date');
                setState(() {
                  _currentDateTime = df.format(date);
                  print('confirm F $_currentDateTime');
                });
              }, currentTime: DateTime.now(), locale: LocaleType.en);
        },
        child: Text(
          _currentDateTime,
          style: TextStyle(color: Colors.blue),
        ));



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
                  onPressed: () async {
                    setState(() {
                      _isAutoValidate = true;
                    });


                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      // If the form is valid, display a Snackbar.
                      //showSnakeBar(context);
                      Utils.showBottomSheet(context);
                      _startSubmitData(propertyProvider);
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
          guideLine('កំណត់ចំណាំខ្លី(ex: Tong Tin 100\$)'),
          vTitle,
          SizedBox(height: 20.0),
          guideLine('លេងមួយក្បាលប៉ុន្មាន (\$)?'),
          vPrice,
          SizedBox(height: 20.0),
          guideLine('ចំនួនអ្នកលេង'),
          vTotalPeople,

          SizedBox(height: 20.0),
          guideLine('ថ្ងៃចាប់ផ្តើមលេង'),
          vStartMonth,
          SizedBox(height: 24.0),
          confirmBtn,


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

  Future _startSubmitData( CRUDModel provider) async {

    var startDate = new DateFormat('dd-MM-yyyy').parse(_currentDateTime).millisecondsSinceEpoch;
    var createDate = DateTime.now().millisecondsSinceEpoch;
    Property property = new Property(people: int.parse(tTotalPeopleController.text),
        title: tTitleController.text, startOn: startDate, createOn: createDate, amount: double.parse(tPriceController.text));

    provider.addNewProperty(property, USER_ID);


    await new Future.delayed(const Duration(seconds: 2));
    Navigator.pop(context);
    await Utils.startHapticSuccess();
    await new Future.delayed(const Duration(seconds: 1));
    Navigator.pop(context);
  }

}

 Widget guideLine(String description){

  return Text(description, style: TextStyle(fontSize: 12.0, color: Colors.blueAccent),);
 }

 void showSnakeBar(BuildContext context){
   Scaffold.of(context)
       .showSnackBar(SnackBar(content: Text('Processing Data')));
 }