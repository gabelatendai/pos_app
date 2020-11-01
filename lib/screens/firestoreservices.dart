import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pos_app/Models/Cart.dart';



final CollectionReference myCollection = FirebaseFirestore.instance.collection('pos_db');

class FirestoreService {

  Future<Cart> createProductsList(  String id,
  String cartid,
  String title,
  double price,
  int qnty,
  String category,
  double subtotal, ) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(myCollection.doc());

      final Cart task = new Cart(id,cartid,title,price,qnty,category,subtotal);
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
