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
                          return  ListView.separated(
                              primary: false,
                              shrinkWrap: true,
                              itemCount:snapshot.data.length,

                              itemBuilder: (BuildContext context, int index) {
                                Products products= snapshot.data[index];
                                // double rate =double.parse(products.exchangeRate);
                                return  Column(
                                  children: [
                                    // removeCartFunction==null
                                // ?
                                    IconButton(icon: Icon(Icons.add_shopping_cart),
                                        onPressed: (){
                                      checkItemInCart(products.productId,context);
                                        }),
                                  // :
                                IconButton(icon: Icon(Icons.remove_shopping_cart), onPressed: null),
                                    Card(
                                      child: InkWell(
                                        onTap: ()=>{
                                        Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                            ProductDescription(status: null, picture:'https://weddinghub.co.zw/img/${products.picture}',
                                              qty: null, price: products.price, stockGroup: null,
                                        company: null, costing: null, category: products.category, branch: null, minimumLevel: null,
                                        ratioQnty: null, purchaseAcount: null, productId: null, tax: null, addon: null,
                                        fqty: null, productDescrip: products.productDescrip, salesAcc: null, addedby: null, id: null,
                                        reorderLevel: null, shareStock: null, typ: null, productCode: null,
                                        siUnit: null, tqty: null,),
                                        ))
                                        },
                                        child: ListTile(
                                          leading:
                                          Image.network('https://weddinghub.co.zw/img/${products.picture}'),
                                          title: Text('${products.productDescrip}'),
                                          subtitle:
                                          Text('${products.category}'),
                                          trailing: Text('\$${products.price}'),
                                        ),
                                      ),
                                    ),
                                  ],
                                );

                              }, separatorBuilder: (context, index) => Divider(),);
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