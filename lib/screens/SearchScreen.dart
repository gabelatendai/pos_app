import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:pos_app/Models/Products.dart';


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Products> _list = [];
  List<Products> _search = [];
  var loading = false;
  Future<Null> fetchData() async {
    setState(() {
      loading = true;
    });
    _list.clear();
    final response =
    await http.get("http://weddinghub.co.zw/pos.php?stock=stock");
    // await http.get("http://snagasportswear.com/app/api.php?search=get");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        for (Map i in data) {
          _list.add(Products.fromJson(i));
          loading = false;
        }
      });
    }
  }

  TextEditingController controller = new TextEditingController();

  onSearch(String text) async {
    _search.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _list.forEach((f) {
      if (f.productDescrip.contains(text) || f.id.toString().contains(text))
        _search.add(f);
    });

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(title: Text("Search Screen"),),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.green,
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.search),
                  title: TextField(
                    controller: controller,
                    onChanged: onSearch,
                    decoration: InputDecoration(
                        hintText: "Search", border: InputBorder.none),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      controller.clear();
                      onSearch('');
                    },
                    icon: Icon(Icons.cancel),
                  ),
                ),
              ),
            ),
            loading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : Expanded(
              child: _search.length != 0 || controller.text.isNotEmpty
                  ?
              GridView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount:_search.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
                  itemBuilder: (BuildContext context, int index) {
                    Products products = _search[index];
                    // double rate =double.parse(products.exchangeRate);
                    return Padding(
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
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5)),
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
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10.0),
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
                    //   Column(
                    //   children: [
                    //     // removeCartFunction==null
                    // // ?
                    //     IconButton(icon: Icon(Icons.add_shopping_cart),
                    //         onPressed: (){
                    //       checkItemInCart(products.productId,context);
                    //         }),
                    //   // :
                    // IconButton(icon: Icon(Icons.remove_shopping_cart), onPressed: null),
                    //     Card(
                    //       child: InkWell(
                    //         onTap: ()=>{
                    //         Navigator.push(
                    //         context,
                    //         MaterialPageRoute(builder: (context) =>
                    //             ProductDescription(status: null, picture:'https://weddinghub.co.zw/img/${products.picture}',
                    //               qty: null, price: products.price, stockGroup: null,
                    //         company: null, costing: null, category: products.category, branch: null, minimumLevel: null,
                    //         ratioQnty: null, purchaseAcount: null, productId: null, tax: null, addon: null,
                    //         fqty: null, productDescrip: products.productDescrip, salesAcc: null, addedby: null, id: null,
                    //         reorderLevel: null, shareStock: null, typ: null, productCode: null,
                    //         siUnit: null, tqty: null,),
                    //         ))
                    //         },
                    //         child: ListTile(
                    //           leading:
                    //           Image.network('https://weddinghub.co.zw/img/${products.picture}'),
                    //           title: Text('${products.productDescrip}'),
                    //           subtitle:
                    //           Text('${products.category}'),
                    //           trailing: Text('\$${products.price}'),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // );

                  })
                  :
              GridView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount:_list.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
                  itemBuilder: (BuildContext context, int index) {
                    Products products = _list[index];
                    // double rate =double.parse(products.exchangeRate);
                    return Padding(
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
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5)),
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
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10.0),
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
                    //   Column(
                    //   children: [
                    //     // removeCartFunction==null
                    // // ?
                    //     IconButton(icon: Icon(Icons.add_shopping_cart),
                    //         onPressed: (){
                    //       checkItemInCart(products.productId,context);
                    //         }),
                    //   // :
                    // IconButton(icon: Icon(Icons.remove_shopping_cart), onPressed: null),
                    //     Card(
                    //       child: InkWell(
                    //         onTap: ()=>{
                    //         Navigator.push(
                    //         context,
                    //         MaterialPageRoute(builder: (context) =>
                    //             ProductDescription(status: null, picture:'https://weddinghub.co.zw/img/${products.picture}',
                    //               qty: null, price: products.price, stockGroup: null,
                    //         company: null, costing: null, category: products.category, branch: null, minimumLevel: null,
                    //         ratioQnty: null, purchaseAcount: null, productId: null, tax: null, addon: null,
                    //         fqty: null, productDescrip: products.productDescrip, salesAcc: null, addedby: null, id: null,
                    //         reorderLevel: null, shareStock: null, typ: null, productCode: null,
                    //         siUnit: null, tqty: null,),
                    //         ))
                    //         },
                    //         child: ListTile(
                    //           leading:
                    //           Image.network('https://weddinghub.co.zw/img/${products.picture}'),
                    //           title: Text('${products.productDescrip}'),
                    //           subtitle:
                    //           Text('${products.category}'),
                    //           trailing: Text('\$${products.price}'),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // );

                  }),
            ),
          ],
        ),
      ),
    );
  }
}
