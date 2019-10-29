import 'package:TonTin/core/models/productModel.dart';
import 'package:TonTin/model/lesson_model.dart';
import 'package:flutter/material.dart';

import '../../util/utils.dart';

class DetailTongTinPage extends StatelessWidget {
  final Property property;

  DetailTongTinPage({Key key, this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levelIndicator = Container(
      child: Container(
        child: LinearProgressIndicator(
            backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
            value: 80.0,
            valueColor: AlwaysStoppedAnimation(Colors.green)),
      ),
    );

    final coursePrice = Container(
      padding: const EdgeInsets.all(7.0),
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0)),
      child: new Text(
        "\$" + property.amount.toString(),
        style: TextStyle(color: Colors.white),
      ),
    );

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 30.0),
        Text(
          property.title,
          style: TextStyle(color: Colors.white, fontSize: 20.0),
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

    final bottomContentText = Text(
      property.title,
      style: TextStyle(fontSize: 18.0),
    );
    final readButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          onPressed: () => {},
          color: Color.fromRGBO(58, 66, 86, 1.0),
          child:
              Text("TAKE THIS LESSON", style: TextStyle(color: Colors.white)),
        ));
    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[bottomContentText, readButton],
        ),
      ),
    );

    return Scaffold(
      body: Container(
        color: Color.fromRGBO(58, 66, 86, 1.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 60.0,
            ),
            topContent,
            headerInfo(context, property),
            new Expanded(child: _buildList(context, property))
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
                      'ដេញហើយ ${info.paidMonth.toString()} ក្បាល')),
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
                  child: labelWithText(Icons.monetization_on, 'ការសរុប N/A')),
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

  return ListView.builder(
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    itemCount: list.length,
    itemBuilder: (BuildContext context, int index) {
      return makeListItem(context, index, list[index], snapshot);
    },
  );
}

Widget makeListItem(
    BuildContext context, int index, String info, Property snapshot) {
  return Ink(
      color: index % 2 == 0 ? Colors.lightBlue : Colors.lightBlueAccent,
      child: makeListTile(context, info, snapshot));
}

ListTile makeListTile(BuildContext context, String info, Property property) {
  return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
    leading: Container(
      padding: EdgeInsets.only(right: 12.0),
      decoration: new BoxDecoration(
          border: new Border(
              right: new BorderSide(width: 1.0, color: Colors.white24))),
      child: Icon(Icons.label, color: Colors.white),
    ),
    title: Text(
      '$info  ${property.title}',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

    subtitle: Row(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                  ' ១ក្បាល​: \$${property.amount.toStringAsFixed(2)} \n ដេញហើយ${property.paidMonth}/${property.people} នាក់. \n ការខែមុន:\$${property.amount * property.interest}',
                  style: TextStyle(color: Colors.white))),
        )
      ],
    ),
    trailing: new Hero(
        tag: info, child: Icon(Icons.info, color: Colors.white, size: 16.0)),
    onTap: () {
      if (true) return;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailTongTinPage(property: property)));
    },
  );
}
