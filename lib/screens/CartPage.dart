import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pos_app/Models/Cart.dart';
import 'package:pos_app/Models/Products.dart';
import 'package:pos_app/screens/charge.dart';

import 'firestoreservices.dart';


class CartPage extends StatefulWidget {
  // double charge;
  // CartPage({Key key,
  //   @required this.charge}): super(key: key);
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
  void _delete(String id) async {
    try {
      print(id);
      firestore.collection('pos_db').doc(id).delete();
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
        body:  ListView(
          shrinkWrap: true,
          children: [
             ListView.builder(
                 primary: false,
                 shrinkWrap: true,
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
            Expanded(
                flex: 1,
                child: MaterialButton(
                  padding: EdgeInsets.all(0),
                  splashColor: Colors.blue,
                  onPressed: () {
                    // if(widget.charge<1)
                    //   toastLong("Nothing to Charge your Cart is Empty");
                    // else
                      // Navigator.push(
                      //   context,
                      //   // MaterialPageRoute(builder: (context) => CartScreen(charge: charge,receipt:_controllerCart.text.toString())),
                      //   MaterialPageRoute(builder: (context) =>
                      //       ChargeScreen(charge:widget.charge,)),
                      // );


                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.lightGreen,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        AutoSizeText('Charge:  ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 5, left: 5),
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          ],
        )



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
