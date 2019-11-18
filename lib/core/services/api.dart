import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class Api {
  static final String USERS = 'users';
  final String PROPERTY = 'properties/props/';
  final String PROPS = 'properties/props';
  final String MEMBERS = 'properties/users/members';
  final String USER_MEMBERS = 'users/members';
  final Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;

  Api(this.path) {
    ref = _db.collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.getDocuments();
  }
  Future<QuerySnapshot> getPropertyCollection(String userID) {
    return ref.firestore.collection(PROPERTY + userID).orderBy('createOn', descending: true).getDocuments();
  }

  Future<QuerySnapshot> getUsersCollection() {
    return ref.getDocuments();
  }
  Stream<QuerySnapshot> streamPropertiesCollection(String userID) {
    return ref.firestore.collection(PROPERTY + userID).orderBy('createOn', descending: true).snapshots();
  }

  Stream<QuerySnapshot> streamMembersCollection() {
    return ref.firestore.collection(MEMBERS).snapshots();
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.document(id).get();
  }
  Future<DocumentSnapshot> getPropertyById(String id) {
    return ref.firestore.document(PROPERTY+id).get();
  }

  Future<void> removeDocument(String id) {
    return ref.document(id).delete();
  }
  Future<void> removeTongTin(String id,String userID) {
    return ref.firestore.collection(PROPERTY + userID ).document(id).delete();
  }

  Future<DocumentReference> addDocument(Map data) {
    return ref.add(data);
  }
  Future<DocumentReference> addProperty(Map data, String userID) {
    return ref.firestore.collection(PROPERTY+userID).add(data);
  }
  Future<DocumentReference> addNewUser(Map data) {
    return ref.firestore.collection(MEMBERS).add(data);
  }

  Future<void> updateDocument(Map data, String id) {
    return ref.document(id).updateData(data);
  }
  Future<void> updateDocumentProperty(Map data, String userID, String id) {
    return ref.firestore.collection(PROPERTY + userID).document(id).updateData(data);
  }

  Future<QuerySnapshot> getUserID(String phone) {
    return ref.firestore.collection(MEMBERS).where("phone", isEqualTo: phone).getDocuments();
  }

}
