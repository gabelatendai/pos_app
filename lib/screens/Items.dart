import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/Models/Products.dart';
import 'package:pos_app/widgets/CircularProgress.dart';
import '../widgets/drawer.dart';
import 'package:http/http.dart' as http;

import 'ProductDetail.dart';

class ItemScreen extends StatefulWidget {
  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: Text("Items"),
        actions: <Widget>[
          // IconButton(
          //   onPressed: () => Navigator.of(context).pushNamed('/singleproduct'),
          //   icon: Icon(Icons.add_shopping_cart),
          // )
        ],
      ),
      drawer: DrawerWidget(),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 11,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: FutureBuilder(
                      future: fetchProducts(),
                      builder: (context,snapshot){
                        if(snapshot.data==null){
                          return Container(
                            child:  CircularProgress(),

                          );
                          //child: Products(),
                        }else{
                          return  GridView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount:snapshot.data.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
                              itemBuilder: (BuildContext context, int index) {
                                Products products= snapshot.data[index];
                                // double rate =double.parse(products.exchangeRate);
                                return  Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    splashColor: Colors.yellow,
                                    // onDoubleTap: () => showSnackBar(),
                                    child: Material(
                                      clipBehavior: Clip.antiAlias,
                                      elevation: 2.0,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: <Widget>[
                                          Image.network(
                                            "https://weddinghub.co.zw/img/${products.picture}",
                                            fit: BoxFit.cover,
                                          ),
                                      Positioned(
                                      bottom: 0.0,
                                      left: 0.0,
                                      right: 0.0,
                                      child: Container(
                                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  products.productDescrip,
                                                  softWrap: true,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                              Text("\$${products.price}",
                                                  style: TextStyle(
                                                      color: Colors.yellow,
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.bold))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                          Positioned(
                                            top: 0.0,
                                            left: 0.0,
                                            child: Container(
                                              padding: EdgeInsets.all(4.0),
                                              decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.9),
                                                  borderRadius: BorderRadius.only(
                                                      topRight: Radius.circular(10.0),
                                                      bottomRight: Radius.circular(10.0))),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.cyanAccent,
                                                    size: 10.0,
                                                  ),
                                                  SizedBox(
                                                    width: 2.0,
                                                  ),
                                                  Text(
                                                    5.toString(),
                                                    style: TextStyle(color: Colors.white, fontSize: 10.0),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );

                              });
                        }
                      }
                  ),
                )
              ],
            ),
          ),
          Divider(
            height: 1,
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add_shopping_cart),
      //   onPressed: () => Navigator.of(context).pushNamed('/singleproduct'),
      // ),
    );
  }

  void checkItemInCart(String productId, BuildContext context) async{
    DocumentSnapshot documentSnapshot;
    try {
      documentSnapshot = await firestore.collection('pos_db').document(productId).get();
      print(documentSnapshot.data);
    } catch (e) {
      print(e);
    }
  }
}
Future<List<Products>> fetchProducts() async{
  String url ="http://weddinghub.co.zw/pos.php?stock=stock";
  final response = await http.get(url);
  return productsFromJson(response.body);

}