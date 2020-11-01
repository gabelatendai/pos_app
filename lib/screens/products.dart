import 'package:flutter/material.dart';
import 'package:pos_app/Models/Products.dart';
import 'package:pos_app/widgets/CircularProgress.dart';
import '../widgets/drawer.dart';
import 'package:http/http.dart' as http;

import 'ProductDetail.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {


  int _currentCategory = 1;
  List categories = [
    {
      "id": 1,
      "title": "big cloth",
    },
    {
      "id": 2,
      "title": "small cloth",
    },
    {
      "id": 3,
      "title": "long cloth",
    },
    {
      "id": 4,
      "title": "short cloth",
    },
    {
      "id": 5,
      "title": "super long and short cloth",
    }
  ];

  void _filterByCategory(int id) {
    setState(() {
      _currentCategory = id;
    });
  }

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
                  flex: 4,
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            contentPadding: EdgeInsets.all(10),
                            leading: Icon(Icons.list),
                            title: Text("Items"),
                            onTap: () => print("items"),
                          ),
                          Divider(
                            height: 1,
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.all(10),
                            leading: Icon(Icons.line_style),
                            title: Text("Categories"),
                            onTap: () => print("categories"),
                          ),
                          Divider(
                            height: 1,
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.all(10),
                            leading: Icon(Icons.turned_in),
                            title: Text("Discounts"),
                            onTap: () => print("discounts"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
                                return  InkWell(
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

          Expanded(
            flex: 1,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _filterByCategory(categories[index]['id']);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: categories[index]['id'] == _currentCategory
                          ? Border(
                              top: BorderSide(color: Colors.green, width: 2))
                          : null,
                    ),
                    child: Text(
                      '${categories[index]['title'].toString().toUpperCase()}',
                      style: TextStyle(
                          color: categories[index]['id'] == _currentCategory
                              ? Colors.green
                              : Colors.black),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add_shopping_cart),
      //   onPressed: () => Navigator.of(context).pushNamed('/singleproduct'),
      // ),
    );
  }
}
Future<List<Products>> fetchProducts() async{
  String url ="http://weddinghub.co.zw/pos.php?stock=stock";
  final response = await http.get(url);
  return productsFromJson(response.body);

}