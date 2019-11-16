import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String price;
  String name;
  String img;

  Product({this.id, this.price, this.name, this.img});

  Product.fromMap(Map snapshot, String id)
      :
        id = id ?? '',
        price = snapshot['price'] ?? '',
        name = snapshot['name'] ?? '',
        img = snapshot['img'] ?? '';

  toJson() {
    return {
      "price": price,
      "name": name,
      "img": img,
    };
  }
}

class Property {
  String id;
  String title;
  String userId;
  int createOn;
  int startOn;
  int people;
  int paidMonth;
  double amount;
  double interest;
  Map<dynamic, dynamic> listTrack;
  bool isDead;

  Property(
      { this.people, this.paidMonth, this.userId, this.createOn, this.startOn, this.title , this.interest, this.listTrack, this.isDead, this.amount});

  Property.fromMap(Map snapshot, String id)
      :
        id = id ?? '',
        paidMonth = snapshot['paidMonth'] != null ? snapshot['paidMonth'] : 0,
        createOn = snapshot['createOn'] != null ? snapshot['createOn'] : 0,
        startOn = snapshot['startOn'] != null ? snapshot['startOn'] : 0,
        title = snapshot['title'] != null ? snapshot['title'] : '',
        userId = snapshot['userId'] != null ? snapshot['userId'] :  '',
        isDead = snapshot['isDead'] != null ? snapshot['isDead'] : false,
        listTrack = snapshot['monthTrack'] != null ?  snapshot['monthTrack'] : new Map(),
        people  = snapshot['totalPeople'] != null ? snapshot['totalPeople'].toInt() : 0,
        amount = snapshot['amount'] != null ? snapshot['amount'].toDouble() : 0.0,
        interest =  snapshot['interest'] != null?  snapshot['interest'].toDouble() : 0.0;



  toJson() {
    return {
      "totalPeople" : people,
      "amount": amount,
      "interest": interest,
      "createOn" : createOn,
      "startOn" : startOn,
      "title" :title,
      "userId" : userId,
      "monthTrack" : listTrack,
      "isDead" : isDead

    };
  }

}

class Users {
  String id;
  String name;
  String phone;
  String password;
  int createOn;
  bool fingerPrint;

  Users({this.id, this.name, this.phone, this.password,  this.createOn, this.fingerPrint});

  Users.fromMap(Map snapshot, String id)
      :
        id = id ?? '',
        name = snapshot['name'] ?? '',
        phone = snapshot['phone'] ?? '',
        password = snapshot['password'] ?? '',
        createOn = snapshot['createOn'] ?? 0,
        fingerPrint = snapshot['fingerPrint'] ?? false;


  toJson() {
    return {
      "name": name,
      "phone": phone,
      "password": password,
      "createOn" : createOn,
      "fingerPrint" : fingerPrint
    };
  }
}

class PropertiesGroup{
  // type can be house , land...
  // Title is title they want like Land SR, Home VIP
  // id , userId bind with it
  // create on
  // start on

}
