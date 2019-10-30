
import 'package:TonTin/util/share_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'dart:convert' as JSON;

class Utils{

  static void showToast(BuildContext context, String message){
    Toast.show(message, context, gravity: Toast.BOTTOM);
  }
  static void showToastError(BuildContext context, String message){
    Toast.show(message, context, gravity: Toast.BOTTOM, backgroundColor:  Colors.red, textColor: Colors.white);
  }
  static void showToastInfo(BuildContext context, String message){
    Toast.show(message, context, gravity: Toast.BOTTOM, backgroundColor:  Colors.blue, textColor: Colors.white);
  }


  static String messageErrorController(String org){
    //{"error":"invalid_grant","error_description":"Bad credentials","error_code":"APPE0005","message":"Phone number not found.","message_ch":"找不到电话号码","message_kh":"លេខទូរសព្ទ័មិនមាននៅក្នុងប្រព័ន្ធ"}
    try {
      Map me = JSON.jsonDecode(org);
      if(me.containsKey("message_kh")){
        return me["message_kh"];
      }
      else if(me.containsKey("error_description")){
        return me["error_description"];
      }else if(me.containsKey("error_message")){
        return me[ "error_message"];
      }
    } catch (e){
      return "Technical Error";
    }

    return "General Failed Exception";
  }

  static Future<bool>  isTokeExpire() async {

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    var tokenMilli =  await  _prefs.then((SharedPreferences prefs){
      return (prefs.getInt(PrefUtil.TOKEN_TIME) ?? 0);
    });
    var current = new DateTime.now().millisecondsSinceEpoch;
    var remain = current - tokenMilli;
    return (remain >  1000* 30) || remain <0 ;
  }


  static  String dateConvert(int milli){
    final df = new DateFormat('dd-MM-yyyy');
   return df.format(new DateTime.fromMillisecondsSinceEpoch(milli*1000));
  }

  static  String addMonth(int milli, int month){
    final df = new DateFormat('dd-MM-yyyy');
    var date = new DateTime.fromMillisecondsSinceEpoch(milli*1000);
    var dateAddMonth = new DateTime(date.year,  date.month + month,  date.day);
    return df.format(dateAddMonth);
  }

  static bool isDateMatch(String compareDate){
    print('how many call ???');
    var sub = compareDate.substring(3);
    var now = new DateTime.now();
    var formatter = new DateFormat('MM-yyyy');
    String currentDate = formatter.format(now);

    return sub == currentDate;
  }
}