import 'dart:math';

import 'package:TonTin/core/models/productModel.dart';
import 'package:TonTin/core/services/api.dart';
import 'package:TonTin/core/viewmodels/CRUDModel.dart';
import 'package:TonTin/model/lesson_model.dart';
import 'package:TonTin/pages/login_page_fire.dart';
import 'package:TonTin/ui/views/home_detail_list.dart';
import 'package:TonTin/ui/views/tong_tin_detail_page.dart';
import 'package:TonTin/ui/widgets/profile_page.dart';
import 'package:TonTin/util/share_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPage extends StatefulWidget {
  ListPage({Key key, this.title, this.userID}) : super(key: key);

  final String title;
  final String userID;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<DocumentSnapshot> _snapshot;

  bool isHomeActive = true;
  bool isProfileActive = false;
  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    var productProvider = Provider.of<CRUDModel>(context);

    final makeBody = Container(
        child: StreamBuilder(
            stream: productProvider.fetchAllProperties(widget.userID== null ? '1' : widget.userID),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                _snapshot = snapshot.data.documents;

                return _buildList(context, _snapshot, widget.userID);
              } else {
                return Text('fetching', style: TextStyle(color: Colors.white),);
              }
            }));

    final makeNewItem = Center(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          new RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create');
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
                      Icons.add_circle,
                      color: Colors.white,
                      size: 24.0,
                    ), tag: 'hero_1',
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  new Text(
                    'CREATE NEW ITEM' ,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ))
        ]));

    final makeBottom = Container(
      height: 60.0,
      child: BottomAppBar(
        color: Color.fromRGBO(58, 66, 86, 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color:  isHomeActive ? Colors.lightBlue : Colors.white70,),
              onPressed: () {
                if(isHomeActive) return;
                setState(() {
                  isProfileActive = !isProfileActive;
                  isHomeActive = !isHomeActive;

                });
              },
            ),

            IconButton(
              icon: Icon(Icons.account_box, color: isProfileActive ? Colors.lightBlue : Colors.white70,),
              onPressed: () {
                if(isProfileActive) return;
                setState(() {
                  isProfileActive = !isProfileActive;
                  isHomeActive = !isHomeActive;

                });
                if(true) return;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage()));

              },
            )
          ],
        ),
      ),
    );
    final topAppBar = AppBar(
      automaticallyImplyLeading: false,
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      title: Text(
        widget.title,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30.0),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.list,
            color: Colors.transparent,
          ),
          onPressed: () {},
        )
      ],
    );
    final prompt = Center(
      child: Text(
        'No List of Property yet \nLet create New one by \nTap on CREATE NEW ITEM',
        style: TextStyle(
            color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar,

      body:isHomeActive ? Column(
        children: <Widget>[
          Expanded(child: widget.userID == null ? prompt : makeBody),
          makeNewItem
        ],
      ): Profile(),
      bottomNavigationBar: makeBottom,
    );
  }
}


Widget promptNoItem() {
  return Padding(
    padding: const EdgeInsets.only(top:50.0),
    child: Center(
      child: Text(
        'No List of Property yet \nLet create New one by \nTap on CREATE NEW ITEM',
        style: TextStyle(
            color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot, String userID) {

  List<Property> list = new List();
  snapshot.forEach((f){
    list.add(Property.fromMap(f.data, f.documentID));
  });
  if(list.length <= 0){
    return ListView( padding: const EdgeInsets.only(top: 10.0), children: <Widget>[promptNoItem()],);
  }

  return ListView(
      padding: const EdgeInsets.only(top: 10.0),
      children:list.map((data) => makeCard(context, data, userID)).toList());
}

Widget makeCard(BuildContext context, Property data, String userID) => Card(

      elevation: 0.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: makeListTile(context, data, userID),
      ),
    );

ListTile makeListTile(BuildContext context, Property property, String userID) {

   return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
      padding: EdgeInsets.only(right: 12.0),
      decoration: new BoxDecoration(
          border: new Border(
              right: new BorderSide(width: 1.0, color: Colors.white24))),
      child: Icon( Icons.label , color: Colors.white),
    ),
    title: Text(
      property.title,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

    subtitle: Row(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Container(
              // tag: 'hero',
              child: LinearProgressIndicator(
                  backgroundColor: Colors.white,
                  value: (calculateRemainPeopleInPercentage(property.people.toDouble(), property.paidMonth.toDouble())),
                  valueColor: AlwaysStoppedAnimation(Colors.blueAccent)),
            )),
        Expanded(
          flex: 4,
          child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child:
              Text(' ១ក្បាល​: \$${property.amount.toStringAsFixed(2)} \n ដេញហើយ${property.listTrack.length.toString()}/${property.people} នាក់.',
                  style: TextStyle(color: Colors.white))),
        )
      ],
    ),
    trailing: new Hero(
        tag: property.id,
        child: Icon(Icons.keyboard_arrow_right,
            color: Colors.white, size: 16.0)),
    onTap: () {
      property.userId = userID;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailTongTinPage(property: property)));
    },
  );
}


double calculateTheRemain(double total, double finish){
  var remain = 100.0 - ((finish * 100) / total);
  print('remain $remain');
  return  remain;
}

double calculateRemainPeopleInPercentage(double total, double finish){
   return (finish * 100 / total) / 100;

}

