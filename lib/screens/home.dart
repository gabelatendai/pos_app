import 'dart:async';
import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crossplat_objectid/crossplat_objectid.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pos_app/Models/Cart.dart';
import 'package:pos_app/Models/Products.dart';
import 'package:pos_app/screens/CartPage.dart';
import 'package:pos_app/widgets/CircularProgress.dart';
import '../widgets/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';


import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'charge.dart';
import 'firestoreservices.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Products>_Prolist = [];
  bool loading =false;
  String _counter,_value;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController _chargeController = TextEditingController();
  TextEditingController  _controllerCart=new TextEditingController();
  Future <Products>getProducts() async {
    setState(() {
      loading = true;
    });
    _Prolist.clear();
    String urldata ="http://weddinghub.co.zw/pos.php?stock=stock";
    final response = await http.get(urldata);
    // final response = await http.get(url + "?id=${user_id}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        for (Map i in data) {
          _Prolist.add(Products.fromJson(i));
          loading = false;
        }
      });
    }
    print(urldata);
    print(_Prolist.length);

  }
  DocumentSnapshot documentSnapshot;
  TextEditingController _qntyController = TextEditingController();
  final TextStyle subtitle = TextStyle(fontSize: 12.0, color: Colors.grey);
  final TextStyle label = TextStyle(fontSize: 14.0, color: Colors.grey);
  int _currentQnty = 1;
  int _currentCategory = 1;
  multi(x, y) => x * y;
  double charge = 0.00;

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
  List<Cart> items;
  FirestoreService fireServ = new FirestoreService();
  StreamSubscription<QuerySnapshot> todoTasks;
  Future _scanStok() async{
    _counter = await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true, ScanMode.DEFAULT);
    setState(() {
      _value=_counter;
    });
    print("scan2:  $_value");
    Fluttertoast.showToast(msg: 'your barcode is : ${ _value}');
    // var userQuery = await db.collection('owner').document(idUser).collection('item').where('id_item',isEqualTo: _value).getDocuments();
    //
    // quantity = userQuery.documents[0].data['item_qty'];
    // print(quantity.toString());
    // print(userQuery.documents[0].data['item_name']);
    // docID=userQuery.documents[0].data['id_item'];
    // String itemname = userQuery.documents[0].data['item_name'];
    // String urlphoto = userQuery.documents[0].data['item_photo'];
    // int hargapcs = userQuery.documents[0].data['item_sellingprice'];
    // _inputQty(context,docID,quantity,hargapcs,urlphoto,itemname);
    // customlist._inputQty(context);
  }

  List carts = List();
bool   processing = false;

  void checkItemInCart(String productId, BuildContext context) async{
    DocumentSnapshot documentSnapshot;
    try {
      documentSnapshot = await firestore.collection('pos_db').doc(productId).get();
      print(documentSnapshot.data);
      Fluttertoast.showToast(msg: 'Item in Cart already');
    } catch (e) {
      print(e);
    }
  }
  void _addToCart(String product,double price,String name,String category) async{
    setState(() {
      loading =true;
    });
    double sub= price * int.parse(_qntyController.text);
    ObjectId id1 = new ObjectId();
    await firestore.collection('pos_db').doc('${product}').set({
      "id": product,
      "cartid": id1.toHexString(),
      "title": name,
      "price": price,
      "qnty":_currentQnty,
      "category": category,
      "subtotal": sub,
    });
    dynamic newproduct = {
      "id": product,
      "title": name,
      "price": price,
      "amount": _currentQnty,
      "category": category,
    };
    setState(() {
      carts.add(newproduct);
      _controllerCart.text += "${name.toString()}     ${price.toString()} ${product.toString()}    ${category.toString()}  ${_qntyController.text} subtotal: ${sub.toString()}\n ";
      loading= false;
    });
    _resetAmount();
    _calculateCharge();
    Navigator.pop(context);
  }

  void _removeFromCart(int id) {
    setState(() {
      carts.removeAt(id);
      firestore.collection('pos_db').doc(id.toString()).delete();
      _controllerCart.clear();
    });
    _calculateCharge();
  }

  void _calculateCharge() {
    double _charge = 0.00;
    carts.forEach((cart) {
      _charge += cart['price'] * cart['amount'];
      // _controllerCart= cart['title'];
    });
    print(_charge);
    setState(() {
      charge = _charge;
    });
  }

  void _resetAmount() {
    setState(() {
      _qntyController.text = '1';
      _currentQnty = 1;
    });
  }

  void _filterByCategory(int id) {
    setState(() {
      _currentCategory = id;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
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
      for (int i = 0; i < items.length; i++) {
        // Cart cart = Cart.map(items[0]);

     setState(() {
      // double subtotal = items[0].price * items[0].qnty;
      // charge += subtotal;
     });
//print("subtotal");
        print("Product Name: ${items[0].title },price: ${items[0].price }, Product Type: ${items[0].category}");
      }
print('price: ${items[0].price}');
    });
    _resetAmount();
    getProducts();

  }
  Widget _shoppingCartBadge() {
    return Badge(
      position: BadgePosition.topEnd(top: 0, end: 3),
      animationDuration: Duration(milliseconds: 300),
      animationType: BadgeAnimationType.slide,
      badgeContent: Text(
        items.length.toString(),
        style: TextStyle(color: Colors.white),
      ),
      child: IconButton(icon: Icon(Icons.shopping_basket), onPressed: () {
        Navigator.push(context,
                MaterialPageRoute(builder: (context) =>
                    CartPage()));
      }),
    );
  }
  @override
  Widget build(BuildContext context) {
    final _HEIGHT = MediaQuery.of(context).size.height;
    final _WIDTH = MediaQuery.of(context).size.width;

    print(_WIDTH);

    return Scaffold(
      appBar: AppBar(
        title: Text("HOME"),
        actions: <Widget>[
          _shoppingCartBadge(),
    //       IconButton(
    //         onPressed: () => Navigator.push(context,
    //     MaterialPageRoute(builder: (context) =>
    //         CartPage())),
    //         icon: Icon(Icons.shopping_basket),
    // )
        ],
      ),
      drawer: DrawerWidget(),
      body: Row(
        children: <Widget>[
          /* Products */
          Expanded(
            flex: 7,
            child: Container(
                height: _HEIGHT,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 11,
                      child: FutureBuilder(
                      future: fetchProducts(),
    builder: (context,snapshot) {
      if (snapshot.data == null) {
        return Container(
          child: CircularProgress(),

        );
        //child: Products(),
      } else {
       return GridView.builder(
          primary: false,
          shrinkWrap: true,
          // itemCount:snapshot.data.length,
          gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
          itemCount: snapshot.data.length,
         itemBuilder: (BuildContext context, int i) {
           Products pro= snapshot.data[i];
            double price = double.tryParse(_Prolist[i].price);
            int qnty = int.tryParse(pro.qty);
            return GestureDetector(
              onTap: () {
                if (qnty < 1) {
                  toastLong("You Out of Stock Please Reorder");
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Container(
                            height: 230,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(height: 10,),
                                Text("Enter Quantity",style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Poppins-Medium.ttf',
                                ),),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        child: Icon(Icons.remove,size: 70,),
                                        onTap: ()=>{
                                        setState(() {
                                        _currentQnty =
                                        _currentQnty < 2
                                        ? 1
                                            : _currentQnty - 1;
                                        _qntyController.text =
                                        '$_currentQnty';
                                        })

                                        },
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: TextField(

                                        onChanged: (value) {
                                          setState(() {
                                            _currentQnty =
                                                int.parse(value);
                                          });
                                        },
                                      style: TextStyle(fontSize: 20),
                                          textAlign:TextAlign.center,
                                        keyboardType: TextInputType
                                            .numberWithOptions(),
                                        controller: _qntyController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Color(0xFFF2F3F5),
                                          hintStyle: TextStyle(
                                              color: Color(0xFF666666),
                                              fontSize: 40),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        child: Icon(Icons.add,size: 70),
                                        onTap: () {
                                          setState(() {
                                            _currentQnty++;
                                            _qntyController.text =
                                            '$_currentQnty';
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 50.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    RaisedButton(
                                      padding: EdgeInsets.all(17.0),
                                      onPressed: ()async{
                                        if(int.parse(_qntyController.text) > qnty){
                                          toastLong("Your Quantity is greater than available stock");

                                        }else {
                                          bool proExists=(await FirebaseFirestore.instance.collection('pos_db').doc(pro.id).get()).exists;
                                          proExists
                                           ? Fluttertoast.showToast(msg: 'Item in Cart already')
                                          :
                                          _addToCart(
                                              pro.id, price, pro.productDescrip,
                                              pro.category);
                                          // _createCart(
                                          //     pro.id, price, pro.productDescrip,
                                          //     pro.category);
                                        }  },
                                      child: loading == false ? AutoSizeText('OK',
                                        style: GoogleFonts.varelaRound(fontSize: 18.0,
                                            color: Colors.purple),) :
                                      CircularProgressIndicator(backgroundColor: Colors.red,),

                                      color: Colors.green,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(15.0),
                                          side: BorderSide(color:Colors.white)),
                                    ),

                                    RaisedButton(
                                      padding: EdgeInsets.all(17.0),
                                      onPressed: (){
                                        Navigator.pop(context);


                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontFamily: 'Poppins-Medium.ttf',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      color: Color(0xFFBC1F26),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(15.0),
                                          side: BorderSide(color: Color(0xFFBC1F26))),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                  // _QuantityDialog();

                }
              },
              onLongPress: () {
              },
              child:
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          height: 180.0,
                  // margin:  EdgeInsetsDirectional.only(start: this.marginLeft, end: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: 'https://weddinghub.co.zw/img/${pro.picture}',
                      placeholder: (context, url) => Image.asset(
                        'assets/loading.gif',
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  )
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.only(
                          //       topLeft: Radius.circular(10.0),
                          //       topRight: Radius.circular(10.0),
                          //     ),
                          //     image: DecorationImage(
                          //       image: NetworkImage(
                          //           'https://weddinghub.co.zw/img/${pro
                          //               .picture}'),
                          //       fit: BoxFit.cover,
                          //     )),
                        ),
                        AutoSizeText(pro.productDescrip.toUpperCase(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            AutoSizeText(
                              'Category',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14.0,
                              ),
                            ),
                            // Spacer(),
                            AutoSizeText(
                              '${pro.category}'.toString(),
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            AutoSizeText(
                              "Quantity",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14.0,
                              ),
                            ),
                            // Spacer(),
                            AutoSizeText(
                              pro.qty,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 10.0,
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(height: 20.0),
                      ],
                    ),
                    Positioned(
                      top: 140,
                      left: 5.0,
                      child: Container(
                        color: Colors.red,
                        padding: const EdgeInsets.all(4.0),
                        child: AutoSizeText(
                          '\$${price}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.0,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),);
          },
          // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 1),
        );

    }
    }
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
                                border:
                                    categories[index]['id'] == _currentCategory
                                        ? Border(
                                            top: BorderSide(
                                                color: Colors.green, width: 2))
                                        : null,
                              ),
                              child: Text(
                                '${categories[index]['title'].toString().toUpperCase()}',
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: TextStyle(
                                    color: categories[index]['id'] ==
                                            _currentCategory
                                        ? Colors.green
                                        : Colors.black),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                )),
          ),

          /* Sidebar Cart */
          Expanded(
            flex: 5,
            child: Container(
              height: _HEIGHT,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: 1,
                    color: Colors.grey[300],
                  ),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _WIDTH > 800 ?  Expanded(
                          flex: 0,
                          child: Container(
                            padding: EdgeInsets.all(2.0),
                            child: Text("Customer"),
                          ),
                        ):Text(""),
                        Expanded(
                          flex: 1,
                          child: FlatButton(
                              padding: EdgeInsets.all(0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Icon(Icons.settings_overscan),
                                  Text("SCAN")
                                ],
                              ),
                              onPressed: () => {
                                _scanStok(),
                                print("object"),
                              }),),

                        Expanded(
                          flex: 1,
                          child:FlatButton(
                            padding: EdgeInsets.all(0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Icon(Icons.contacts),
                                Text("SEARCH")
                              ],
                            ),
                            onPressed: () => print("object"),
                          ),),
                        Expanded(
                          flex: 1,
                          child:FlatButton(
                            padding: EdgeInsets.all(0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Icon(Icons.person_add),
                                Text("ADD")
                              ],
                            ),
                            onPressed: () => print("object"),
                          ),),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                  ),
                  Expanded(
                    flex: 9,
                    child: ListView.separated(
                      itemCount: carts.length,
                      itemBuilder: (context, i) {
                        double subtotal=multi(carts[i]['price'] , carts[i]['amount']);
                        return ListTile(
                          onTap: () {
                            _removeFromCart(i);
                          },
                          title: RichText(
                            text: TextSpan(
                                text:
                                '${carts[i]['title'].toString().toUpperCase()}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: ' x ${carts[i]['amount']}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.orange,
                                      )),

                                ]
                            ),
                          ),
                          subtitle: Text('\$${carts[i]['price']}'),
                          trailing: Text(
                              '\$${subtotal.toStringAsFixed(2)}'),
                        );
                      },
                      separatorBuilder: (context, i) {
                        return Divider(
                          height: 1,
                        );
                      },
                    ),
                  ),
                  Divider(height: 1,),
                  Expanded(
                    child:TextField(
                      controller: _controllerCart,
                      onSubmitted: (text) {
                        carts.add(carts);
                        _controllerCart.clear();
                        setState(() {});
                      },
                    ),


                  ),

                  Divider(height: 1,),
                  Expanded(
                      flex: 1,
                      child: MaterialButton(
                        padding: EdgeInsets.all(0),
                        splashColor: Colors.blue,
                        onPressed: () {

                          if(charge<1)
                            toastLong("Nothing to Charge your Cart is Empty");
                          else
                            Navigator.push(
                              context,
                              // MaterialPageRoute(builder: (context) => CartScreen(charge: charge,receipt:_controllerCart.text.toString())),
                              MaterialPageRoute(builder: (context) =>
                                  ChargeScreen(charge: charge,receipt:_controllerCart.text.toString())),
                            );


                        },
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.lightGreen,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              AutoSizeText('Charge:  '+charge.toStringAsFixed(2),
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
              ),
            ),
          ),
          // Expanded(
          //   flex: 5,
          //   child: Container(
          //     height: _HEIGHT,
          //     decoration: BoxDecoration(
          //       border: Border(
          //         left: BorderSide(
          //           width: 1,
          //           color: Colors.grey[300],
          //         ),
          //       ),
          //     ),
          //     child: Column(
          //       children: <Widget>[
          //         Expanded(
          //           flex: 1,
          //           child: Row(
          //             mainAxisSize: MainAxisSize.max,
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: <Widget>[
          //               _WIDTH > 800 ?  Expanded(
          //                 flex: 0,
          //                 child: Container(
          //                   padding: EdgeInsets.all(2.0),
          //                   child: Text("Customer"),
          //                 ),
          //               ):Text(""),
          //               Expanded(
          //                 flex: 1,
          //                 child: FlatButton(
          //                 padding: EdgeInsets.all(0),
          //                 child: Column(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   mainAxisSize: MainAxisSize.max,
          //                   children: <Widget>[
          //                     Icon(Icons.settings_overscan),
          //                     Text("SCAN")
          //                   ],
          //                 ),
          //                 onPressed: () => {
          //                 _scanStok(),
          //                     print("object"),
          //                   }),),
          //
          //               Expanded(
          //                 flex: 1,
          //                 child:FlatButton(
          //                 padding: EdgeInsets.all(0),
          //                 child: Column(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   mainAxisSize: MainAxisSize.max,
          //                   children: <Widget>[
          //                     Icon(Icons.contacts),
          //                     Text("SEARCH")
          //                   ],
          //                 ),
          //                 onPressed: () => print("object"),
          //               ),),
          //               Expanded(
          //                 flex: 1,
          //                 child:FlatButton(
          //                 padding: EdgeInsets.all(0),
          //                 child: Column(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   mainAxisSize: MainAxisSize.max,
          //                   children: <Widget>[
          //                     Icon(Icons.person_add),
          //                     Text("ADD")
          //                   ],
          //                 ),
          //                 onPressed: () => print("object"),
          //               ),),
          //             ],
          //           ),
          //         ),
          //         Divider(
          //           height: 1,
          //         ),
          //         Expanded(
          //           flex: 9,
          //           child: ListView.separated(
          //             itemCount: items.length,
          //             itemBuilder: (context, i) {
          //               Cart receipt =items[i];
          //               // charge+=receipt.subtotal;
          //               double subtotal=multi(receipt.price , receipt.qnty);
          //               return ListTile(
          //                 onTap: () {
          //                   // _removeFromCart(i);
          //                   firestore.collection('pos_db').doc(receipt.cartid).delete();
          //                   // _delete(receipt.cartid);
          //                   _resetAmount();
          //                 },
          //                 title: RichText(
          //                   text: TextSpan(
          //                       text:
          //                           '${receipt.title.toString().toUpperCase()}',
          //                       style: TextStyle(
          //                         fontSize: 10,
          //                         color: Colors.black,
          //                         fontWeight: FontWeight.bold,
          //                       ),
          //                       children: <TextSpan>[
          //                         TextSpan(
          //                             text: ' x ${receipt.qnty}',
          //                             style: TextStyle(
          //                               fontSize: 15,
          //                               color: Colors.orange,
          //                             )),
          //
          //                       ]
          //                   ),
          //                 ),
          //                 subtitle: Text('\$${receipt.price}'),
          //                 trailing: Text(
          //                     '\$${subtotal.toStringAsFixed(2)}'),
          //               );
          //
          //               },
          //             separatorBuilder: (context, i) {
          //               return Divider(
          //                 height: 1,
          //               );
          //             },
          //           ),
          //         ),
          //         Divider(height: 1,),
          //         Expanded(
          //           child:TextField(
          //             controller: _controllerCart,
          //             onSubmitted: (text) {
          //               carts.add(carts);
          //               _controllerCart.clear();
          //               setState(() {});
          //             },
          //           ),
          //
          //
          //         ),
          //
          //         Divider(height: 1,),
          //         Expanded(
          //             flex: 1,
          //             child: MaterialButton(
          //               padding: EdgeInsets.all(0),
          //               splashColor: Colors.blue,
          //               onPressed: () {
          //
          //               if(charge<1)
          //                 toastLong("Nothing to Charge your Cart is Empty");
          //               else
          //                 Navigator.push(
          //                   context,
          //                   // MaterialPageRoute(builder: (context) => CartScreen(charge: charge,receipt:_controllerCart.text.toString())),
          //                   MaterialPageRoute(builder: (context) =>
          //                       ChargeScreen(charge: charge,receipt:_controllerCart.text.toString())),
          //                 );
          //
          //
          //               },
          //               child: Container(
          //                 alignment: Alignment.center,
          //                 color: Colors.lightGreen,
          //                 child: Row(
          //                   mainAxisSize: MainAxisSize.max,
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: <Widget>[
          //                     AutoSizeText('Charge:  '+charge.toStringAsFixed(2),
          //                       style: TextStyle(color: Colors.white),
          //                     ),
          //                     Padding(
          //                       padding: EdgeInsets.only(right: 5, left: 5),
          //                       child: Icon(
          //                         Icons.check_circle,
          //                         color: Colors.white,
          //                       ),
          //                     )
          //                   ],
          //                 ),
          //               ),
          //             )),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
  // _customAlertDialog(BuildContext context) {
}

Future<List<Products>> fetchProducts() async{
  String url ="http://weddinghub.co.zw/pos.php?stock=stock";
  final response = await http.get(url);
  return productsFromJson(response.body);

}