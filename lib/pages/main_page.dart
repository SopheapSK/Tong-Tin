import 'package:TonTin/home_page.dart';
import 'package:TonTin/pages/list_description.dart';
import 'package:TonTin/pages/list_notification_report.dart';
import 'package:TonTin/pages/list_report.dart';
import 'package:TonTin/pages/page_utils.dart';
import 'package:TonTin/pages/slide_with_footer.dart';
import 'package:flutter/material.dart';
import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:badges/badges.dart';

import '../login_page.dart';
import 'list_report_stick.dart';


class DrawerSlideWithHeader extends StatefulWidget {
  static String tag = 'main_page';

  @override
  _DrawerSlideWithHeaderState createState() => _DrawerSlideWithHeaderState();
}

class _DrawerSlideWithHeaderState extends State<DrawerSlideWithHeader> {
  var _counter = 0;
  int currentPage = 0;

  var selectedMenuItemId = '0';


  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onBackPress,
      child: new DrawerScaffold(

        showAppBar: true,
        percentage: 0.9,
        cornerRadius: 10,
        appBar: AppBarProps(
          centerTitle: true,
          bottomOpacity: 0.9,
          iconTheme: IconThemeData(color: Colors.white),
            title: Center(child: Text("Home",textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontStyle: FontStyle.normal),)),
            backgroundColor: Color.fromARGB(255, 	176, 192, 37),
            actions: <Widget>[
              BadgeIconButton(
                  itemCount: _counter ,
                  badgeColor: Colors.red,
                  badgeTextColor: Colors.white,
                  icon: Icon(Icons.notifications, color: Colors.white,),
                  onPressed: () {
                    setState(() {
                      _counter = 0;
                    });
                  //  Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new ListNotificationReport()));
                    Navigator.pushNamed(context, '/list_notification');

                  }),
            ],
            //[IconButton(icon: Icon(Icons.notifications), onPressed: () {})]
        ),
        menuView: new MenuView(
          menu: DrawerUtils.drawermenu(),
          headerView: DrawerUtils.headerView(context),
          footerView: DrawerUtils.footerView(context),
          animation: false,
          alignment: Alignment.topLeft,
          //color: Theme.of(context).primaryColor,
          color: Colors.white,
          selectedItemId: selectedMenuItemId,
          onMenuItemSelected: (String itemId) {
            setState(() {
             selectedMenuItemId = itemId;
            });
            _switchPage(context, itemId);
          },
        ),
        contentView: Screen(
          contentBuilder: (context) => LayoutBuilder(
            builder: (context, constraint)  {
              return DrawerUtils.selectDrawerPages( selectedMenuItemId);

  }

          ),        color: Colors.white,
        ),

      ),
    );
  }

  void _switchPage(BuildContext context, String id){
    if(id.isEmpty || id == '0') return;

    switch (id){
      case '4': // log out
        Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new LoginPage()));
        break;
      case '3' : // report
        Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new ListReportSticky()));
        break;

    }

  }
  Future<bool> _onBackPress() {
    if(selectedMenuItemId == '0'){
     // Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new LoginPage()));
      Navigator.of(context).pop();
    }else {
      //Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => new DrawerSlideWithHeader()));
      setState(() {
        selectedMenuItemId = 'homePage'; // go main page
      });
    }
    return null;
  }
}

