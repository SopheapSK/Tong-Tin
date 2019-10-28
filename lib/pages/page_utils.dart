
import 'package:TonTin/pages/home_page.dart';
import 'package:TonTin/pages/slide_with_footer.dart';
import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:flutter/material.dart';
import 'package:TonTin/util/constant.dart';
import '../login_page.dart';
import 'list_description.dart';
import 'list_report.dart';

class DrawerUtils  {
   static Menu drawermenu(){
      return  new Menu(
    items: [
      new MenuItem(
        id: '0',
        title: Global.HOME_MENU['home'],
        icon:  Icons.home,
      ),
      new MenuItem(
        id: '1',
        title: Global.HOME_MENU['wing_pay'],
        icon:  Icons.rv_hookup,
      ),
      new MenuItem(
        id: '2',
        title: Global.HOME_MENU['buy_ticket'],
        icon:  Icons.directions_bus,
      ),
      new MenuItem(
        id: '3',
        title: Global.HOME_MENU['report'],
        icon:  Icons.list,
      ),
      new MenuItem(
        id: '4',
        title: Global.HOME_MENU['logout'],
        icon:  Icons.exit_to_app,
      ),
    ],
  );
   }
  static Widget selectDrawerPages( String page){
   
   Widget me ;
   switch(page){
     case '1':
      me =  new HomeScreenWingPay();
      break;
     case '2' :
      me = new TestListNotificationReport();
      break;
      case ListDescription.tag : 
      me = ListDescription();
      break;

      default :
      me =  new HomeScreen();
   }
   return me;
  }
 static Widget headerView(BuildContext context) {
    return new Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            children: <Widget>[
              new Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage("assets/alucard.jpg")))),
              Container(
                  margin: EdgeInsets.only(left: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "John Witch",
                        style: Theme.of(context)
                            .textTheme
                            .subhead
                            .copyWith(color: Colors.grey),
                      ),
                      Text(
                        "test123@gmail.com",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle
                            .copyWith(color: Colors.grey),
                      )
                    ],
                  ))
            ],
          ),
        ),
        Divider(
          color: Colors.white.withAlpha(200),
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Divider(
            color: Colors.grey,
            height: 0.2,
          ),
        )
      ],
    );
  }

 static Widget footerView(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Divider(
          color: Colors.grey,
          height: 0.4,
        ),
        Divider(
          color: Colors.white.withAlpha(200),
          height: 0.4,
        ),
          Padding(
            padding: EdgeInsets.fromLTRB(48.0, 4.0,4.0,4.0),
            child: Text("version 1.0.9", style: TextStyle(fontSize: 12.0, ), textAlign: TextAlign.start, ),
          ),

      ],
    );
   }
}

