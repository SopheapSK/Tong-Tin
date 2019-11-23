
import 'package:TonTin/pages/login_page_fire.dart';
import 'package:TonTin/pages/register_page_fire.dart';
import 'package:TonTin/ui/views/add_properties.dart';
import 'package:TonTin/ui/views/home_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/' :
        return  MaterialPageRoute(
          builder: (_)=>  LoginPage()
        );
      case '/home_tong_tin' :
        return  MaterialPageRoute(
            builder: (_)=>  ListPage(title: ' Personal ', userID: null,)
        );


      case '/login' :
        return MaterialPageRoute(
            builder: (_)=>  LoginPage()
        ) ;
      case '/register' :
        return MaterialPageRoute(
            builder: (_)=>  RegisterPage()
        ) ;

      case '/list_notification' :
        return MaterialPageRoute(
            builder: (_)=>  ListPage(title: 'Lessons')
        ) ;
      case '/home_loan' :
        return MaterialPageRoute(
            builder: (_)=>  ListPage(title: 'Lessons')
        ) ;
      case '/create' :
        return MaterialPageRoute(
            builder: (_)=>  CreateProperty()
        ) ;

        //CreateProperty
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Text('No route defined for ${settings.name}'),
              ),
            ));
    }
  }
}

/*
 LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
    DrawerSlideWithHeader.tag : (context) => DrawerSlideWithHeader(),
    ListNotificationReport.tag : (context) => ListNotificationReport(),
    "WingPay" : (context) => HomeScreenWingPay()
 */