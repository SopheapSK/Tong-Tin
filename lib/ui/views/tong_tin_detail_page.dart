import 'package:TonTin/core/models/productModel.dart';
import 'package:TonTin/core/viewmodels/CRUDModel.dart';
import 'package:TonTin/model/lesson_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../util/utils.dart';

class DetailTongTinPage extends StatelessWidget {
  final Property property;

  DetailTongTinPage({Key key, this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Text(
            property.title,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ),
      ],
    );

    final topContent = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
      Container(
        margin: EdgeInsets.all(16.0),
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: new Hero(
              tag: property.id,
              child: Icon(Icons.arrow_back, color: Colors.white)),
        ),
      )
    ],);



    return Scaffold(
      body: Container(
        color: Color.fromRGBO(58, 66, 86, 1),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            topContent,
            topContentText,
            headerInfo(context, property),
            Expanded(child: _buildList(context, property))
          ],
        ),
      ),
    );
  }
}

Widget labelWithText(IconData iconData, String info) {
  final fontX = info.length > 16 ? 13.0 : 15.0;
  return Center(
      child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
        new RaisedButton(
            onPressed: null,
            disabledColor: Colors.white12,
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            color: Colors.white10,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Icon(
                  iconData,
                  color: Colors.white,
                  size: 16.0,
                ),
                SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: new Text(
                    info,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: fontX,
                        fontWeight: FontWeight.normal),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ))
      ]));
}

Widget headerInfo(BuildContext context, Property info) {
  var totalInterest = 0.0;
  info.listTrack.forEach((f){
    if(f != null)
      totalInterest+=f;
  });
  return Container(
    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
    color: Color.fromRGBO(58, 66, 86, 1),
    child: new Center(
      child: Column(
        children: <Widget>[

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: labelWithText(
                      Icons.people, 'សរុប ${info.people.toString()} នាក់')),
              SizedBox(
                width: 4.0,
              ),
              Expanded(
                child: labelWithText(Icons.monetization_on,
                    '១ក្បាល​: \$${info.amount.toStringAsFixed(2)} '),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: labelWithText(Icons.person,
                      'ដេញហើយ ${info.listTrack.length.toString()} ក្បាល')),
              SizedBox(
                width: 4.0,
              ),
              Expanded(
                  child: labelWithText(Icons.date_range,
                      'ថ្ងៃលេង ${Utils.dateConvert(info.startOn)}')),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: labelWithText(Icons.monetization_on, 'ការសរុប \$ ${totalInterest.toStringAsFixed(2)}')),
              SizedBox(
                width: 4.0,
              ),
              Expanded(
                  child: labelWithText(Icons.monetization_on,
                      'ការខែមុន \$${info.interest.toString()}')),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildList(BuildContext context, Property snapshot) {
  List<String> list = new List();
  for (var i = 0; i < snapshot.people; i++) {
    list.add('${i + 1}');
  }

  return Container(


    color: Colors.blueGrey,
    child: ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        var isCurrentMonth = Utils.isDateMatch(Utils.addMonth(snapshot.startOn, index));
        return makeListItem(context, index, list[index], snapshot, isCurrentMonth);
      },
    ),
  );
}

Widget makeListItem(BuildContext context, int index, String info, Property snapshot, bool isCurrentMonth) {
  return Container(
      color: isCurrentMonth ? Colors.orangeAccent : index % 2 == 0 ? Colors.blueGrey : Color.fromRGBO(58, 66, 86, .2) ,
      child: makeListTile(context,index,  info, snapshot));
}

ListTile makeListTile(BuildContext context, int index, String info, Property property) {
  var isInterestAvailable = index < property.listTrack.length;
  var interest = isInterestAvailable ? property.listTrack[index].toStringAsFixed(2) : ' N/A';
  var amountToPay = isInterestAvailable ? (property.amount - property.listTrack[index]).toStringAsFixed(2) : ' N/A';
  if(property.isDead) {
    if (index >= property.listTrack.length) {
      amountToPay = property.amount.toStringAsFixed(2);
      interest = '0.00';
    }
  }

  return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
    leading: Container(
      padding: EdgeInsets.only(right: 8.0),
      decoration: new BoxDecoration(
          border: new Border(
              right: new BorderSide(width: 1.0, color: Colors.white24))),
      child: Text('$info', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
    ),
    title: Text(
      '${Utils.addMonth(property.startOn, index)}',
      style: TextStyle(color: Colors.lightBlue, fontSize: 12.0, fontWeight: FontWeight.normal),
    ),
    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

    subtitle: Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Padding(
              padding: EdgeInsets.only(left: 0.0),
              child: Text(
                  ' ការ​: \$$interest \n ដេញហើយ$info/${property.people} នាក់. \n បង់លុយ:\$ $amountToPay',
                  style: TextStyle(color: Colors.white))),
        )
      ],
    ),
    trailing: GestureDetector(onTap: ()=> _showBottomSheet(context, index, property)
        , child: Icon(Icons.edit, color: Colors.white, size: 20.0)),
    onTap: () {
      print('tap for more');

    },
  );


}

void _showBottomSheet(BuildContext context, int index, Property property){
  final tInterestController = TextEditingController();
  showModalBottomSheet(
      context: context,

      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text('ការប្រាក់សម្រាប់ខែទី ${index + 1}',)

              ),
              SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: tInterestController,
                  decoration: InputDecoration(
                    hintText: '(ex: 12.5\$ ) (\$ only)',
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0)),
                  ),


                ),
              ),
              SizedBox(
                height: 8.0,
              ),


              _buttonSubmit(context,index, property, tInterestController.text),
              SizedBox(height: 32),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text('លុបការប្រាក់សម្រាប់ខែទី ${index + 1}ចោល?',)

              ),
              _buttonDeleteInterest(context, index, property),

              SizedBox(height: 32),

              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text('បើអ្នកដេញរួចហើយ សុមចុចប៊ូតុងខាងក្រមនេះ',)

              ),

              _buttonBid(context, property),
            ],
          ),
        );
      });
}
Widget _buttonBid( BuildContext context, Property property){
  return new Center(
      child: new RaisedButton(
          onPressed: () {
            // Navigator.pushNamed(context, '/create');
            updateDoneBid(context, property);
            Navigator.pop(context);
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
                Icons.cloud_done,
                color: Colors.white,
                size: 24.0,
              ), tag: 'hero_1',
              ),
              SizedBox(
                width: 16.0,
              ),
              new Text(
                '\t DONE BID ? \t  \t \t' ,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )));
}
Widget _buttonSubmit( BuildContext context,int index, Property property, String interest){
  return new Center(
      child: new RaisedButton(
          onPressed: () {
           // Navigator.pushNamed(context, '/create');
            updateData(context, index, property, interest);
            Navigator.pop(context);
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
                Icons.donut_large,
                color: Colors.white,
                size: 24.0,
              ), tag: 'hero_2',
              ),
              SizedBox(
                width: 16.0,
              ),
              new Text(
                ' Click Here to Update Data' ,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )));
}

Widget _buttonDeleteInterest( BuildContext context,int index, Property property){
  return new Center(
      child: new RaisedButton(
          onPressed: () {
            // Navigator.pushNamed(context, '/create');
            updateRemoveInterest(context, index, property);
            Navigator.pop(context);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          color: Colors.grey,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Hero(child: new Icon(
                Icons.delete_sweep,
                color: Colors.white,
                size: 24.0,
              ), tag: 'hero_2',
              ),
              SizedBox(
                width: 16.0,
              ),
              new Text(
                ' ចុចដើម្បីលុបការប្រាក់ចោល' ,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )));
}

void updateData(BuildContext context, int index, Property property, String interest){
  if(interest.isEmpty) return;
  List<dynamic> list = property.listTrack;
  list[index] = double.parse(interest);
  property.listTrack = list;
  var productProvider = Provider.of<CRUDModel>(context);

  print('user id ${property.userId}');
  productProvider.updateProperty(property, property.userId, property.id);
}
void updateDoneBid(BuildContext context, Property property){
  var productProvider = Provider.of<CRUDModel>(context);

  property.isDead = true;
  print('user id ${property.userId}');
  productProvider.updateProperty(property, property.userId, property.id);
}
void updateRemoveInterest(BuildContext context, int index, Property property){

  List<dynamic> list = property.listTrack;
  list.removeAt(index);
  property.listTrack = list;
  var productProvider = Provider.of<CRUDModel>(context);

  print('user id ${property.userId}');
  productProvider.updateProperty(property, property.userId, property.id);
}