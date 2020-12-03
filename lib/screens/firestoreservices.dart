import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pos_app/Models/Cart.dart';
import 'package:pos_app/Models/Pay.dart';



final CollectionReference myCollection = FirebaseFirestore.instance.collection('pos_db');
final CollectionReference myCollection2 = FirebaseFirestore.instance.collection('paymethod');

class FirestoreService {

  Future<Cart> createProductsList(  String id,
  String currency,
  String amount,
  double rate,
  int qnty,
  String category,
  double subtotal, ) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(myCollection.doc());

      final Cart task = new Cart(id,currency,amount,rate,qnty,category,subtotal);
      final Map<String, dynamic> data = task.toMap();
      await tx.set(ds.reference, data);
      return data;
    };

    return FirebaseFirestore.instance.runTransaction(createTransaction).then((mapData) {
      return Cart.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }

  Stream<QuerySnapshot> getTaskList({int offset, int limit}) {
    Stream<QuerySnapshot> snapshots = myCollection.snapshots();

    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }
    if (limit != null) {
      snapshots = snapshots.take(limit);
    }
    return snapshots;
  }


}
class FirestoreService2 {

  Future<Pay> createProductsList(
  String currency,
  double amount,
  double rate,
 ) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(myCollection2.doc());

      final Pay task = new Pay(currency,amount,rate);
      final Map<String, dynamic> data = task.toMap();
      await tx.set(ds.reference, data);
      return data;
    };

    return FirebaseFirestore.instance.runTransaction(createTransaction).then((mapData) {
      return Pay.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }

  Stream<QuerySnapshot> getPayToList({int offset, int limit}) {
    Stream<QuerySnapshot> snapshots = myCollection2.snapshots();

    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }
    if (limit != null) {
      snapshots = snapshots.take(limit);
    }
    return snapshots;
  }


}
