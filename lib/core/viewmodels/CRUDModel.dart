import 'dart:async';
import 'package:flutter/material.dart';
import '../../locator.dart';
import '../services/api.dart';
import '../models/productModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CRUDModel extends ChangeNotifier {
  Api _api = locator<Api>();

  List<Product> products;
  List<Property> properties;
  List<Users> users;


  Future<List<Product>> fetchProducts() async {
    var result = await _api.getDataCollection();
    products = result.documents
        .map((doc) => Product.fromMap(doc.data, doc.documentID))
        .toList();
    return products;
  }

  Stream<QuerySnapshot> fetchProductsAsStream() {
    return _api.streamDataCollection();
  }

  Stream<QuerySnapshot> fetchAllMembers() {
    return _api.streamMembersCollection();
  }
  Stream<QuerySnapshot> fetchAllProperties(String userID) {
    return _api.streamPropertiesCollection(userID);
  }

  Future<Product> getProductById(String id) async {
    var doc = await _api.getDocumentById(id);
    return  Product.fromMap(doc.data, doc.documentID) ;
  }

  Future<Property> getPropertyById(String id) async {
    var doc = await _api.getPropertyById(id);
    return  Property.fromMap(doc.data, doc.documentID) ;
  }

  Future removeProduct(String id) async{
     await _api.removeDocument(id) ;
     return ;
  }
  Future updateProduct(Product data,String id) async{
    await _api.updateDocument(data.toJson(), id) ;
    return ;
  }
  Future updateProperty(Property data, String userID,String id) async{
    await _api.updateDocumentProperty(data.toJson(), userID, id) ;
    return ;
  }


  Future addProduct(Product data) async{
    var result  = await _api.addDocument(data.toJson()) ;

    return ;

  }


  Future addUser(Users data) async{
    return await _api.addNewUser(data.toJson()) ;

  }

  Future addNewProperty(Property data, String userID) async{
    print('result: ${data.toJson()}' );
    await _api.addProperty(data.toJson(), userID) ;

    return ;

  }

  Future<List<Property>> fetchAll() async {
    var result = await _api.getDataCollection();
    properties = result.documents
        .map((doc) => Property.fromMap(doc.data, doc.documentID))
        .toList();
    for (var me in result.documents){
      print('<> ${me.data.values}');
    }
    print('<--> ${result.documents[0].data.values}');
    return properties;
  }


  Future<List<Users>> fetchUsers() async {
   // var result = await _api.getDataCollection();
    return null;
  }


}
