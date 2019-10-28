import 'package:TonTin/pages/main_page.dart';
import 'package:TonTin/pages/main_page.dart' as prefix0;
import 'package:TonTin/util/constant.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  List listHomeMenu = [HomeMenuItem(Global.HOME_MENU['register'], Icons.people), HomeMenuItem(Global.HOME_MENU['buy_ticket'], Icons.directions_bus)];


  @override
  Widget build(BuildContext context) {
    ListTile makeListTile(HomeMenuItem homeMenu) => ListTile(

        contentPadding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        leading: Container(
          padding: EdgeInsets.only(right: 4.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white))),
          child: Icon(homeMenu.iconData, color: Colors.blue, size: 48,),
        ),
        title: Text(
          homeMenu.name,
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
       );

    Column makeCard(HomeMenuItem homeMenuItem) => Column(
      children: <Widget>[
        makeListTile(homeMenuItem),
        Divider(thickness: 0.5,)
      ],

    );
    final makeBody = Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: listHomeMenu.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(listHomeMenu[index]);
        },
      ),
    );





    return Container(
      padding: EdgeInsets.all(16.0),
      child: makeBody,
    );
  }

}

class FirstFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Center(
      child: new Text("Hello Fragment 1"),
    );
  }

}

class SecondFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Center(
      child: new Text("Hello Fragment 2"),
    );
  }

}

class ThirdFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Center(
      child: new Text("Wow So Awesome"),
    );
  }



}

class HomeMenuItem {
      final String name;
      final IconData iconData;
      HomeMenuItem(this.name, this.iconData);
}