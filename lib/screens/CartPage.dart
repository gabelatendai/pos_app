import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pos_app/Models/Cart.dart';
import 'package:pos_app/Models/Products.dart';

import 'firestoreservices.dart';


class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Cart> items;
  FirestoreService fireServ = new FirestoreService();
  StreamSubscription<QuerySnapshot> todoTasks;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    items=new List();

    todoTasks?.cancel();
    todoTasks=fireServ.getTaskList().listen((QuerySnapshot snapshot){
      final List<Cart> tasks=snapshot.docs
          .map((documentSnapshot) => Cart.fromMap(documentSnapshot.data()))
          .toList();
      setState(() {
        this.items = tasks;
      });

    });

  }
  void _delete(String cartid) async {
    try {
      print(cartid);
      firestore.collection('pos_db').doc(cartid).delete();
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(title: Text('Cart'),),
        // resizeToAvoidBottomInset: false,
        body:   items != null
            ? Center(

          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                Cart receipt =items[index];
                return  Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(

                        child: ListTile(
                          title: Text('${receipt.title}'),
                          subtitle: Text(
                              '${receipt.qnty} X \$${receipt.price}'),
                          trailing: Text(
                              '\$${receipt.qnty * receipt.price}'),
                        ),
                     
                      ),
                      IconButton(icon: Icon(Icons.delete), onPressed: () {
                        _delete(receipt.id);
                        // checkItemInCart(receipt.cartid,context);
                        print(receipt.cartid);

                      }   )
                    ],
                  ),
                );;
              }
          ),
        )
            :
            Center(
              child: Text('Cart is Empty'),
            ),

    );
  }
  void checkItemInCart(String productId, BuildContext context) async{
    DocumentSnapshot documentSnapshot;
    try {
      documentSnapshot = await firestore.collection('pos_db').document(productId).get();
      print(documentSnapshot.data);
      Fluttertoast.showToast(msg: 'Item in Cart already');
    } catch (e) {
      print(e);
    }
  }


}
