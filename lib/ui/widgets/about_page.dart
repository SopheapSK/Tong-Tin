
import 'package:TonTin/util/lang.dart';
import 'package:TonTin/util/share_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return new Stack(
      children: <Widget>[
        ClipPath(
          child: Container(color: Colors.black.withOpacity(0.1)),
          clipper: getClipper(),
        ),
        Positioned(
            width: MediaQuery.of(context).size.width,
            top: MediaQuery.of(context).size.height / 5,
            child: Column(
              children: <Widget>[


               Icon(Icons.wifi_tethering, size: 90.0, color:  Colors.blueAccent,),


            SizedBox(height: MediaQuery.of(context).size.height / 10.0),
                Text(
                  Language.app_name(),
                  style: TextStyle(
                    color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Version 1.0',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.0,
                      fontStyle: FontStyle.normal,
                      fontFamily: 'Montserrat'),
                ),




              ],
            ))
      ],
    );
  }



}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}