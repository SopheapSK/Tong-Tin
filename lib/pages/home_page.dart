import 'package:TonTin/pages/list_notification_report.dart';
import 'package:TonTin/pages/wingpay_report.dart';
import 'package:TonTin/util/constant.dart';
import 'package:flutter/material.dart';


class HomeScreenWingPay extends StatelessWidget {
  List listHomeMenu = [HomeMenuItem(Global.HOME_MENU['register'], Icons.people), HomeMenuItem(Global.HOME_MENU['buy_ticket'], Icons.directions_bus)];
  Hero logo (String id, String imageName) {
    return Hero(
      tag: 'hero_$id',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset(imageName),
      ),
    );
  }

  Card makeDashboardItem(BuildContext context, String id,  String title, String iconName) {
    return Card(
        elevation: 0.0,
        margin: new EdgeInsets.all(1.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: new InkWell(
            onTap: () {_handleClick(context, id);},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 20.0),
                Center(
                    child: logo(id, iconName)
                ),
                SizedBox(height: 20.0),
                new Center(
                  child: new Text(title,
                      style:
                      new TextStyle(fontSize: 18.0, color: Colors.black)),
                )
              ],
            ),
          ),
        ));
  }

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
    final promotionBanner =  Container(
        height: 60.0,
        decoration: new BoxDecoration(
            color:  Color.fromARGB(255, 	176, 192, 37),
            border: new Border(

            )),
    );
    final bottomContainer = Container(
      height: 90.0,
      decoration: new BoxDecoration(
        color: Colors.blue,
          border: new Border(

             )),
      child:  Column(

      children: <Widget>[

      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                child: new Column(children: <Widget>[
                  SizedBox(height: 16.0),
                  Center(
                      child: Icon(Icons.account_balance_wallet, size: 40.0, color: Colors.white,)),
                  SizedBox(height: 6.0),
                  new Center(

                    child: SizedBox( width: 80.0,
                      child: new Text('Balance (USD)',
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                          style:
                          new TextStyle(fontSize: 12.0, color: Colors.white, )),
                    ),
                  )
                ],),
              ),
              Container(color: Colors.white, height: 90.0, width: 0.5,),
              InkWell(

                child: new Column(children: <Widget>[
                  SizedBox(height: 16.0),
                  Center(
                      child: Icon(Icons.account_balance_wallet, size: 40.0, color: Colors.white,)),
                  SizedBox(height: 6.0),
                  new Center(

                    child: SizedBox( width: 80.0,
                      child: new Text('Balance (KHR)',
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                          style:
                          new TextStyle(fontSize: 12.0, color: Colors.white, )),
                    ),
                  )
                ],),
              ),

            ],),
          ),
          Container(color: Colors.white, height: 90.0, width: 0.5,),
          Expanded(
            child: Container( height: 90.0, color: Colors.blue,
              child: Column(children: <Widget>[
                Container(color: Colors.lightBlue , width: double.infinity, height: 30.0,
                    child: Center(
                        child: new Text('FX Rate',style: new TextStyle(fontSize: 14.0, color: Colors.white),))),
                Expanded(child: Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      child: new Column(children: <Widget>[

                        SizedBox(height: 8.0),
                        new Text('ASK',
                            style:
                            new TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4.0),
                        new Center(

                          child: SizedBox( width: 60.0,
                            child: new Text('4045 KHR',
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                softWrap: false,
                                style:
                                new TextStyle(fontSize: 12.0, color: Colors.white, )),
                          ),
                        )
                      ],),
                    ),
                    Container(color: Colors.white, height: 50.0, width: 0.5,),
                    InkWell(
                      child: new Column(children: <Widget>[
                        SizedBox(height: 8.0),
                        new Text('BID',
                            style:
                            new TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.bold )),
                        SizedBox(height: 4.0),
                        new Center(

                          child: SizedBox( width: 60.0,
                            child: new Text('4010 KHR',
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                softWrap: false,
                                style:
                                new TextStyle(fontSize: 12.0, color: Colors.white, )),
                          ),
                        )
                      ],),
                    ),
                  ],
                ),)

              ],
              ),
            )

          )

        ],
      ),
      ],
      ));

    final contentBody =  Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
      child: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(3.0),
        children: <Widget>[
          makeDashboardItem(context,  '1',  "Scan And Pay", 'assets/logo.png'),
          makeDashboardItem(context,'2', "Create QR", 'assets/logo.png'),
          makeDashboardItem(context,'3', "Cash In", 'assets/logo.png'),
          makeDashboardItem(context,'4', "Report", 'assets/logo.png'),

        ],
      ));

    final mainBody =  new Column(children: <Widget>[
      Expanded(child: contentBody),
      bottomContainer,
      promotionBanner
    ],
    );


    return Container(
      padding: EdgeInsets.all(0.0),
      child: mainBody,
    );
  }

  void _handleClick(BuildContext context, String id){
    if(id == '4'){
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new WingPayReport()));
    }
  }

}



class HomeMenuItem {
  final String name;
  final IconData iconData;
  HomeMenuItem(this.name, this.iconData);
}

