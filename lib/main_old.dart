import 'package:TonTin/pages/home_page.dart';
import 'package:TonTin/pages/list_notification_report.dart';
import 'package:TonTin/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
    DrawerSlideWithHeader.tag : (context) => DrawerSlideWithHeader(),
    ListNotificationReport.tag : (context) => ListNotificationReport(),
    "WingPay" : (context) => HomeScreenWingPay()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MeApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
        pageTransitionsTheme: PageTransitionsTheme(builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
   }),
      ),
      home: LoginPage(),
      routes: routes,
      
    );
  }
}
