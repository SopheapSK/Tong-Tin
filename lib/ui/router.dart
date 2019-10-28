import 'package:TonTin/home_page.dart';
import 'package:TonTin/login_page.dart';
import 'package:TonTin/pages/list_notification_report.dart';
import 'package:TonTin/pages/main_page.dart';
import 'package:TonTin/ui/views/add_properties.dart';
import 'package:TonTin/ui/views/home_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './views/addProduct.dart';
import './views/productDetails.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/' :
        return  MaterialPageRoute(
          builder: (_)=>  ListPage(title: ' Personal ')
        );
      case '/addProduct' :
        return MaterialPageRoute(
          builder: (_)=> AddProduct()
        ) ;
      case '/productDetails' :
        return MaterialPageRoute(
            builder: (_)=> ProductDetails()
        ) ;
      case '/login' :
        return MaterialPageRoute(
            builder: (_)=>  LoginPage()
        ) ;
      case '/home' :
        return MaterialPageRoute(
            builder: (_)=>  DrawerSlideWithHeader()
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