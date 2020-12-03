import 'dart:async';
import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crossplat_objectid/crossplat_objectid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_responsive/flutter_responsive.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pos_app/Models/Cart.dart';
import 'package:pos_app/Models/Products.dart';
import 'package:pos_app/Models/food.dart';
import 'package:pos_app/bloc/food_bloc.dart';
import 'package:pos_app/controllers/pdfhome.dart';
import 'package:pos_app/events/food_event.dart';
import 'package:pos_app/screens/Screen.dart';
import 'package:pos_app/screens/SearchScreen.dart';
import 'package:pos_app/widgets/CircularProgress.dart';
import '../widgets/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pos_app/Models/PayMethod.dart';
import 'package:pos_app/screens/ListViewPage.dart';
import 'package:pos_app/screens/pdf.dart';
import 'package:pos_app/widgets/InputDeco_design.dart';
import 'dart:async';

import 'CartPage.dart';
import 'Cart_list.dart';
import 'Cart_list_screen.dart';
import 'firestoreservices.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Products> _Prolist = [];
  bool loading = false;
  String _counter, _value;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController _chargeController = TextEditingController();

  // TextEditingController  _controllerCart=new TextEditingController();
  Future<Products> getProducts() async {
    setState(() {
      loading = true;
    });
    _Prolist.clear();
    String urldata = "http://weddinghub.co.zw/pos.php?stock=stock";
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
  final TextStyle label = TextStyle(fontSize: 20.0, color: Colors.grey);
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

  Future _scanStok() async {
    _counter = await FlutterBarcodeScanner.scanBarcode(
        "#004297", "Cancel", true, ScanMode.DEFAULT);
    setState(() {
      _value = _counter;
    });
    print("scan2:  $_value");
    Fluttertoast.showToast(msg: 'your barcode is : ${_value}');
    if (_value!=null){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: 230,
              child: Center(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceEvenly,
                  mainAxisSize:
                  MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Enter Quantity",
                      style: TextStyle(
                        color: Colors
                            .black,
                        fontSize: 18,
                        fontFamily:
                        'Poppins-Medium.ttf',
                      ),
                    ),
                    Text(
                      _value,
                      style: TextStyle(
                        color: Colors
                            .black,
                        fontSize: 18,
                        fontFamily:
                        'Poppins-Medium.ttf',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            child: Icon(
                              Icons
                                  .remove,
                              size: 70,
                            ),
                            onTap: () =>
                            {
                              setState(() {
                                _currentQnty =
                                _currentQnty <
                                    2
                                    ? 1
                                    : _currentQnty -
                                    1;
                                _qntyController
                                    .text =
                                '$_currentQnty';
                              })
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            onChanged:
                                (value) {
                              setState(() {
                                _currentQnty =
                                    int
                                        .parse(
                                        value);
                              });
                            },
                            style: TextStyle(
                                fontSize: 20),
                            textAlign:
                            TextAlign
                                .center,
                            keyboardType:
                            TextInputType
                                .numberWithOptions(),
                            controller:
                            _qntyController,
                            decoration:
                            InputDecoration(
                              border:
                              OutlineInputBorder(
                                borderRadius:
                                BorderRadius
                                    .all(
                                    Radius
                                        .circular(
                                        10.0)),
                                borderSide:
                                BorderSide(
                                  width: 0,
                                  style:
                                  BorderStyle
                                      .none,
                                ),
                              ),
                              filled: true,
                              fillColor: Color(
                                  0xFFF2F3F5),
                              hintStyle: TextStyle(
                                  color: Color(
                                      0xFF666666),
                                  fontSize:
                                  40),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            child: Icon(
                                Icons.add,
                                size: 70),
                            onTap: () {
                              setState(() {
                                _currentQnty++;
                                _qntyController
                                    .text =
                                '$_currentQnty';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceEvenly,
                      children: [
                        RaisedButton(
                          padding:
                          EdgeInsets.all(
                              17.0),
                          onPressed:
                              () async {


                          },
                          child: loading ==
                              false
                              ? AutoSizeText(
                            'OK',
                            style: GoogleFonts
                                .varelaRound(
                                fontSize:
                                18.0,
                                color: Colors
                                    .purple),
                          )
                              : CircularProgressIndicator(
                            backgroundColor:
                            Colors
                                .red,
                          ),
                          color: Colors
                              .green,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              new BorderRadius
                                  .circular(
                                  15.0),
                              side: BorderSide(
                                  color: Colors
                                      .white)),
                        ),
                        RaisedButton(
                          padding:
                          EdgeInsets.all(
                              17.0),
                          onPressed: () {
                            Navigator.pop(
                                context);
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors
                                  .white,
                              fontSize: 18,
                              fontFamily:
                              'Poppins-Medium.ttf',
                            ),
                            textAlign:
                            TextAlign
                                .center,
                          ),
                          color: Color(
                              0xFFBC1F26),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              new BorderRadius
                                  .circular(
                                  15.0),
                              side: BorderSide(
                                  color: Color(
                                      0xFFBC1F26))),
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
    }
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
  bool processing = false;

  var invoice =DateTime.now().millisecondsSinceEpoch.toString();
  void checkItemInCart(String productId, BuildContext context) async {
    DocumentSnapshot documentSnapshot;
    try {
      documentSnapshot =
      await firestore.collection('pos_db').doc(productId).get();
      print(documentSnapshot.data);
      Fluttertoast.showToast(msg: 'Item in Cart already');
    } catch (e) {
      print(e);
    }
  }

  void AddBloc(String name, String price, String product_id,) {
    BlocProvider.of<FoodBloc>(context).add(
        FoodEvent.add(Food(name, price, _qntyController.text, product_id)));
  }

  void _addToCart(String product, double price, String name,
      String category) async {
    setState(() {
      loading = true;
    });
    double sub = price * int.parse(_qntyController.text);
    ObjectId id1 = new ObjectId();
    await firestore.collection('pos_db').doc('${product}').set({
      "id": product,
      "cartid": id1.toHexString(),
      "title": name,
      "price": price,
      "qnty": _currentQnty,
      "category": category,
      "subtotal": sub,
      "invoice": invoice,
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
      // _controllerCart.text += "${name.toString()}     ${price.toString()} ${product.toString()}    ${category.toString()}  ${_qntyController.text} subtotal: ${sub.toString()}\n ";
      loading = false;
    });
    _resetAmount();
    _calculateCharge();
    Navigator.pop(context);
  }

  void _delete(String id) async {
    try {
      print(id);
      firestore.collection('pos_db').doc(id.toString()).delete();
    } catch (e) {
      print(e);
    }
  }

  void _removeFromCart(int id) {
    try {
      //
      setState(() {
        carts.removeAt(id);
        // firestore.collection('pos_db').doc(id.toString()).delete();
      });
    } catch (e) {
      print(e);
    }

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
  List<Products> _list = [];
  List<Products> _search = [];
  // var loading = false;
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    items = new List();

    todoTasks?.cancel();
    todoTasks = fireServ.getTaskList().listen((QuerySnapshot snapshot) {
      final List<Cart> tasks = snapshot.docs
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
        print(
            "Product Name: ${items[0].title},price: ${items[0]
                .price}, Product Type: ${items[0].category}");
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
        carts.length.toString(),
        style: TextStyle(color: Colors.white),
      ),
      child: IconButton(
          icon: Icon(Icons.shopping_basket),
          onPressed: () {
            // if (items.length < 1)
            //   toastLong("Your Cart is Empty");
            // else
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchScreen()));
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final _HEIGHT = MediaQuery
        .of(context)
        .size
        .height;
    final _WIDTH = MediaQuery
        .of(context)
        .size
        .width;

    print(_WIDTH);

    return Scaffold(
      appBar: AppBar(
        // bottom: TabBar(
        //   // controller: _tabController,
        //   tabs: T,
        // ),
        title: Text("HOME"),
        actions: <Widget>[
          _shoppingCartBadge(),
          //       IconButton(
          //         onPressed: () => Navigator.push(context,
          //     MaterialPageRoute(builder: (context) =>
          //         Home())),
          //         icon: Icon(Icons.shopping_basket),
          // )
        ],
      ),
      drawer: DrawerWidget(),
      body: Row(
        children: <Widget>[
          /* Products */
          Expanded(
            flex: 6,
            child: Container(
                height: _HEIGHT,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 11,
                      child:
                      ListView(
                        children: [
                          _list.length>0 ?
                          GridView.builder(
                                      primary: false,
                                      shrinkWrap: true,
                                      itemCount:_list.length,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: (orientation == Orientation.portrait) ? 1 : 2),
                                      itemBuilder: (BuildContext context, int index) {
                                        Products products = _list[index];
                                        // double rate =double.parse(products.exchangeRate);

                                            double price =
                                            double.tryParse(_list[index].price);
                                            int qnty = int.tryParse(products.qty);
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            // splashColor: Colors.yellow,
                                            onTap: (){

                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return Dialog(
                                                      child: Container(
                                                        height: 230,
                                                        child: Center(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                            mainAxisSize:
                                                            MainAxisSize.min,
                                                            children: <Widget>[
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                "Enter Quantity",
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 18,
                                                                  fontFamily:
                                                                  'Poppins-Medium.ttf',
                                                                ),
                                                              ),
                                                              Text(
                                                                invoice,
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 18,
                                                                  fontFamily:
                                                                  'Poppins-Medium.ttf',
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child: InkWell(
                                                                      child: Icon(
                                                                        Icons
                                                                            .remove,
                                                                        size: 70,
                                                                      ),
                                                                      onTap: () =>
                                                                      {
                                                                        setState(() {
                                                                          _currentQnty =
                                                                          _currentQnty <
                                                                              2
                                                                              ? 1
                                                                              : _currentQnty -
                                                                              1;
                                                                          _qntyController
                                                                              .text =
                                                                          '$_currentQnty';
                                                                        })
                                                                      },
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child: TextField(
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(() {
                                                                          _currentQnty =
                                                                              int
                                                                                  .parse(
                                                                                  value);
                                                                        });
                                                                      },
                                                                      style: TextStyle(
                                                                          fontSize: 20),
                                                                      textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                      keyboardType:
                                                                      TextInputType
                                                                          .numberWithOptions(),
                                                                      controller:
                                                                      _qntyController,
                                                                      decoration:
                                                                      InputDecoration(
                                                                        border:
                                                                        OutlineInputBorder(
                                                                          borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                              Radius
                                                                                  .circular(
                                                                                  10.0)),
                                                                          borderSide:
                                                                          BorderSide(
                                                                            width: 0,
                                                                            style:
                                                                            BorderStyle
                                                                                .none,
                                                                          ),
                                                                        ),
                                                                        filled: true,
                                                                        fillColor: Color(
                                                                            0xFFF2F3F5),
                                                                        hintStyle: TextStyle(
                                                                            color: Color(
                                                                                0xFF666666),
                                                                            fontSize:
                                                                            40),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child: InkWell(
                                                                      child: Icon(
                                                                          Icons.add,
                                                                          size: 70),
                                                                      onTap: () {
                                                                        setState(() {
                                                                          _currentQnty++;
                                                                          _qntyController
                                                                              .text =
                                                                          '$_currentQnty';
                                                                        });
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 50.0,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                                children: [
                                                                  RaisedButton(
                                                                    padding:
                                                                    EdgeInsets.all(
                                                                        17.0),
                                                                    onPressed:
                                                                        () async {
                                                                      if (int.parse(
                                                                          _qntyController
                                                                              .text) >
                                                                          qnty) {
                                                                        toastLong(
                                                                            "Your Quantity is greater than available stock");
                                                                      } else {
                                                                        bool proExists = (await FirebaseFirestore
                                                                            .instance
                                                                            .collection(
                                                                            'pos_db')
                                                                            .doc(
                                                                            products
                                                                                .id)
                                                                            .get())
                                                                            .exists;
                                                                        proExists
                                                                            ? Fluttertoast
                                                                            .showToast(
                                                                            msg:
                                                                            'Item in Cart already')
                                                                            :
                                                                        _addToCart(
                                                                            products
                                                                                .id,
                                                                            price,
                                                                            products
                                                                                .productDescrip,
                                                                            products
                                                                                .category);
                                                                        // AddBloc(
                                                                        //     products
                                                                        //         .productDescrip,
                                                                        //     products
                                                                        //         .price,
                                                                        //     products
                                                                        //         .id);
                                                                      }
                                                                    },
                                                                    child: loading ==
                                                                        false
                                                                        ? AutoSizeText(
                                                                      'OK',
                                                                      style: GoogleFonts
                                                                          .varelaRound(
                                                                          fontSize:
                                                                          18.0,
                                                                          color: Colors
                                                                              .purple),
                                                                    )
                                                                        : CircularProgressIndicator(
                                                                      backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                    ),
                                                                    color: Colors
                                                                        .green,
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                        new BorderRadius
                                                                            .circular(
                                                                            15.0),
                                                                        side: BorderSide(
                                                                            color: Colors
                                                                                .white)),
                                                                  ),
                                                                  RaisedButton(
                                                                    padding:
                                                                    EdgeInsets.all(
                                                                        17.0),
                                                                    onPressed: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                      "Cancel",
                                                                      style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize: 18,
                                                                        fontFamily:
                                                                        'Poppins-Medium.ttf',
                                                                      ),
                                                                      textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                    ),
                                                                    color: Color(
                                                                        0xFFBC1F26),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                        new BorderRadius
                                                                            .circular(
                                                                            15.0),
                                                                        side: BorderSide(
                                                                            color: Color(
                                                                                0xFFBC1F26))),
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


                                            },
                                            // onDoubleTap: () => showSnackBar(),
                                            child: Material(
                                              clipBehavior: Clip.antiAlias,
                                              elevation: 2.0,
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: <Widget>[
                                                  CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl:
                                                    'https://weddinghub.co.zw/img/${products
                                                        .picture}',
                                                    placeholder:
                                                        (context, url) =>
                                                        Image.asset(
                                                          'assets/loading.gif',
                                                          fit: BoxFit
                                                              .cover,
                                                        ),
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
                                                                    fontSize: 22.0,
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
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );

                                      })
                          :Center(
                            child: CircularProgress(),
                          ),
                        ],
                      )

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
                                '${categories[index]['title']
                                    .toString()
                                    .toUpperCase()}',
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
            flex: 6,
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
                        _WIDTH > 800
                            ? Expanded(
                          flex: 0,
                          child: Container(
                            padding: EdgeInsets.all(2.0),
                            child: Text("Customer"),
                          ),
                        )
                            : Text(""),
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
                              onPressed: () =>
                              {
                                _scanStok(),
                                print("object"),
                              }),
                        ),
                        Expanded(
                          flex: 1,
                          child: FlatButton(
                            padding: EdgeInsets.all(0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Icon(Icons.search),
                                Text("SEARCH")
                              ],
                            ),
                            onPressed: () => mCornerBottomSheet(context),
                          ),
                        ),
                        // Expanded(
                        //   flex: 1,
                        //   child: FlatButton(
                        //     padding: EdgeInsets.all(0),
                        //     child: Column(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       mainAxisSize: MainAxisSize.max,
                        //       children: <Widget>[
                        //         Icon(Icons.person_add),
                        //         Text("ADD")
                        //       ],
                        //     ),
                        //     onPressed: () => print("object"),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                  ),
                  Expanded(
                    flex: 9,
                    child:
                    // BlocConsumer<FoodBloc, List<Food>>(
                    //   buildWhen: (List<Food> previous, List<Food> current) {
                    //     return true;
                    //   },
                    //   listenWhen: (List<Food> previous, List<Food> current) {
                    //     if (current.length > previous.length) {
                    //       return true;
                    //     }
                    //
                    //     return false;
                    //   },
                    //   builder: (context, foodList) {
                    //     return ListView.separated(
                    //       physics: NeverScrollableScrollPhysics(),
                    //       shrinkWrap: true,
                    //       primary: false,
                    //       itemCount: foodList.length,
                    //       itemBuilder: (context, index) {
                    //         return ListTile(
                    //           onTap: () {
                    //             BlocProvider.of<FoodBloc>(context).add(
                    //                 FoodEvent.delete(index));
                    //             _removeFromCart(index);
                    //             _delete(foodList[index].product_id);
                    //           },
                    //           title: RichText(
                    //             text: TextSpan(
                    //                 text:
                    //                 foodList[index].name.toUpperCase(),
                    //                 style: TextStyle(
                    //                   fontSize: 10,
                    //                   color: Colors.black,
                    //                   fontWeight: FontWeight.bold,
                    //                 ),
                    //                 children: <TextSpan>[
                    //                   TextSpan(
                    //                       text: 'x${foodList[index].qnty}',
                    //                       style: TextStyle(
                    //                         fontSize: 15,
                    //                         color: Colors.orange,
                    //                       )),
                    //                 ]),
                    //           ),
                    //           subtitle: Text('\$${foodList[index].price}'),
                    //           trailing: Text('\$${multi(
                    //               double.parse(foodList[index].price),
                    //               double.parse(foodList[index].qnty))}'),
                    //         );
                    //       },
                    //       separatorBuilder: (context, i) {
                    //         return Divider(
                    //           height: 1,
                    //         );
                    //       },
                    //     );
                    //   },
                    //   listener: (BuildContext context, foodList) {
                    //     Fluttertoast.showToast(msg: "Added");
                    //     // Scaffold.of(context).showSnackBar(
                    //     //   SnackBar(content: Text('Added!')),
                    //     // );
                    //   },
                    // ),

                    ListView.separated(
                      itemCount: carts.length,
                      itemBuilder: (context, i) {
                        double subtotal =
                            multi(carts[i]['price'], carts[i]['amount']);
                        return ListTile(
                          onTap: () {
                            _removeFromCart(i);
                            _delete(carts[i]['id']);
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
                                ]),
                          ),
                          subtitle: Text('\$${carts[i]['price']}'),
                          trailing: Text('\$${subtotal.toStringAsFixed(2)}'),
                        );
                      },
                      separatorBuilder: (context, i) {
                        return Divider(
                          height: 1,
                        );
                      },
                    ),
                  ),

                  Divider(
                    height: 1,
                  ),
                  // Expanded(
                  //   child:TextField(
                  //     controller: _controllerCart,
                  //     onSubmitted: (text) {
                  //       carts.add(carts);
                  //       _controllerCart.clear();
                  //       setState(() {});
                  //     },
                  //   ),
                  //
                  //
                  // ),

                  Divider(
                    height: 1,
                  ),
                  Expanded(
                      flex: 1,
                      child: MaterialButton(
                        padding: EdgeInsets.all(0),
                        splashColor: Colors.blue,
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => FoodListScreen()));

                          if (charge < 1)
                            toastLong("Your Cart is Empty");
                          else
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                // CustomDialogw());
                                CustomDialogw(charge: charge,invoice:invoice));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.lightGreen,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              AutoSizeText(
                                'Charge:  ' + charge.toStringAsFixed(2),
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
        ],
      ),
    );
  }

  // _customAlertDialog(BuildContext context) {


  mCornerBottomSheet(BuildContext aContext) {
    final orientation = MediaQuery.of(context).orientation;
    showModalBottomSheet(
        // isScrollControlled: true,
        isDismissible: true,
        context: aContext,
        // backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (builder) {
          return ListView(
            children: [
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
              _search.length != 0 || controller.text.isNotEmpty
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
                      child: GestureDetector(
                        onTap: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: Container(
                                  height: 230,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceEvenly,
                                      mainAxisSize:
                                      MainAxisSize.min,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Enter Quantity",
                                          style: TextStyle(
                                            color: Colors
                                                .black,
                                            fontSize: 18,
                                            fontFamily:
                                            'Poppins-Medium.ttf',
                                          ),
                                        ),
                                        Text(
                                          invoice,
                                          style: TextStyle(
                                            color: Colors
                                                .black,
                                            fontSize: 18,
                                            fontFamily:
                                            'Poppins-Medium.ttf',
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceEvenly,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: InkWell(
                                                child: Icon(
                                                  Icons
                                                      .remove,
                                                  size: 70,
                                                ),
                                                onTap: () =>
                                                {
                                                  setState(() {
                                                    _currentQnty =
                                                    _currentQnty <
                                                        2
                                                        ? 1
                                                        : _currentQnty -
                                                        1;
                                                    _qntyController
                                                        .text =
                                                    '$_currentQnty';
                                                  })
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: TextField(
                                                onChanged:
                                                    (value) {
                                                  setState(() {
                                                    _currentQnty =
                                                        int
                                                            .parse(
                                                            value);
                                                  });
                                                },
                                                style: TextStyle(
                                                    fontSize: 20),
                                                textAlign:
                                                TextAlign
                                                    .center,
                                                keyboardType:
                                                TextInputType
                                                    .numberWithOptions(),
                                                controller:
                                                _qntyController,
                                                decoration:
                                                InputDecoration(
                                                  border:
                                                  OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius
                                                        .all(
                                                        Radius
                                                            .circular(
                                                            10.0)),
                                                    borderSide:
                                                    BorderSide(
                                                      width: 0,
                                                      style:
                                                      BorderStyle
                                                          .none,
                                                    ),
                                                  ),
                                                  filled: true,
                                                  fillColor: Color(
                                                      0xFFF2F3F5),
                                                  hintStyle: TextStyle(
                                                      color: Color(
                                                          0xFF666666),
                                                      fontSize:
                                                      40),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: InkWell(
                                                child: Icon(
                                                    Icons.add,
                                                    size: 70),
                                                onTap: () {
                                                  setState(() {
                                                    _currentQnty++;
                                                    _qntyController
                                                        .text =
                                                    '$_currentQnty';
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 50.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceEvenly,
                                          children: [
                                            RaisedButton(
                                              padding:
                                              EdgeInsets.all(
                                                  17.0),
                                              onPressed:
                                                  () async {
                                                if (int.parse(
                                                    _qntyController
                                                        .text) >
                                                    double.parse(products.qty)) {
                                                  toastLong(
                                                      "Your Quantity is greater than available stock");
                                                } else {
                                                  bool proExists = (await FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                      'pos_db')
                                                      .doc(
                                                      products
                                                          .id)
                                                      .get())
                                                      .exists;
                                                  proExists
                                                      ? Fluttertoast
                                                      .showToast(
                                                      msg:
                                                      'Item in Cart already')
                                                      :
                                                  _addToCart(
                                                      products
                                                          .id,
                                                      double.parse(products.price),
                                                      products
                                                          .productDescrip,
                                                      products
                                                          .category);
                                                  // AddBloc(
                                                  //     products
                                                  //         .productDescrip,
                                                  //     products
                                                  //         .price,
                                                  //     products
                                                  //         .id);
                                                }
                                              },
                                              child: loading ==
                                                  false
                                                  ? AutoSizeText(
                                                'OK',
                                                style: GoogleFonts
                                                    .varelaRound(
                                                    fontSize:
                                                    18.0,
                                                    color: Colors
                                                        .purple),
                                              )
                                                  : CircularProgressIndicator(
                                                backgroundColor:
                                                Colors
                                                    .red,
                                              ),
                                              color: Colors
                                                  .green,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  new BorderRadius
                                                      .circular(
                                                      15.0),
                                                  side: BorderSide(
                                                      color: Colors
                                                          .white)),
                                            ),
                                            RaisedButton(
                                              padding:
                                              EdgeInsets.all(
                                                  17.0),
                                              onPressed: () {
                                                Navigator.pop(
                                                    context);
                                              },
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                  color: Colors
                                                      .white,
                                                  fontSize: 18,
                                                  fontFamily:
                                                  'Poppins-Medium.ttf',
                                                ),
                                                textAlign:
                                                TextAlign
                                                    .center,
                                              ),
                                              color: Color(
                                                  0xFFBC1F26),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  new BorderRadius
                                                      .circular(
                                                      15.0),
                                                  side: BorderSide(
                                                      color: Color(
                                                          0xFFBC1F26))),
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
                        },
                        // splashColor: Colors.yellow,
                        // onDoubleTap: () => showSnackBar(),
                        child: Material(
                          clipBehavior: Clip.antiAlias,
                          elevation: 2.0,
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                          CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          imageUrl:
                                                          'https://weddinghub.co.zw/img/${products
                                                              .picture}',
                                                          placeholder:
                                                              (context, url) =>
                                                              Image.asset(
                                                                'assets/loading.gif',
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                          ),
                              // Image.network(
                              //   "https://weddinghub.co.zw/img/${products.picture}",
                              //   fit: BoxFit.cover,
                              // ),
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
              child: GestureDetector(
                onTap: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Container(
                          height: 230,
                          child: Center(
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceEvenly,
                              mainAxisSize:
                              MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Enter Quantity",
                                  style: TextStyle(
                                    color: Colors
                                        .black,
                                    fontSize: 18,
                                    fontFamily:
                                    'Poppins-Medium.ttf',
                                  ),
                                ),
                                Text(
                                  invoice,
                                  style: TextStyle(
                                    color: Colors
                                        .black,
                                    fontSize: 18,
                                    fontFamily:
                                    'Poppins-Medium.ttf',
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceEvenly,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        child: Icon(
                                          Icons
                                              .remove,
                                          size: 70,
                                        ),
                                        onTap: () =>
                                        {
                                          setState(() {
                                            _currentQnty =
                                            _currentQnty <
                                                2
                                                ? 1
                                                : _currentQnty -
                                                1;
                                            _qntyController
                                                .text =
                                            '$_currentQnty';
                                          })
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: TextField(
                                        onChanged:
                                            (value) {
                                          setState(() {
                                            _currentQnty =
                                                int
                                                    .parse(
                                                    value);
                                          });
                                        },
                                        style: TextStyle(
                                            fontSize: 20),
                                        textAlign:
                                        TextAlign
                                            .center,
                                        keyboardType:
                                        TextInputType
                                            .numberWithOptions(),
                                        controller:
                                        _qntyController,
                                        decoration:
                                        InputDecoration(
                                          border:
                                          OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius
                                                .all(
                                                Radius
                                                    .circular(
                                                    10.0)),
                                            borderSide:
                                            BorderSide(
                                              width: 0,
                                              style:
                                              BorderStyle
                                                  .none,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Color(
                                              0xFFF2F3F5),
                                          hintStyle: TextStyle(
                                              color: Color(
                                                  0xFF666666),
                                              fontSize:
                                              40),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        child: Icon(
                                            Icons.add,
                                            size: 70),
                                        onTap: () {
                                          setState(() {
                                            _currentQnty++;
                                            _qntyController
                                                .text =
                                            '$_currentQnty';
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 50.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceEvenly,
                                  children: [
                                    RaisedButton(
                                      padding:
                                      EdgeInsets.all(
                                          17.0),
                                      onPressed:
                                          () async {
                                        if (int.parse(
                                            _qntyController
                                                .text) >
                                            double.parse(products.qty)) {
                                          toastLong(
                                              "Your Quantity is greater than available stock");
                                        } else {
                                          bool proExists = (await FirebaseFirestore
                                              .instance
                                              .collection(
                                              'pos_db')
                                              .doc(
                                              products
                                                  .id)
                                              .get())
                                              .exists;
                                          proExists
                                              ? Fluttertoast
                                              .showToast(
                                              msg:
                                              'Item in Cart already')
                                              :
                                          _addToCart(
                                              products
                                                  .id,
                                              double.parse(products.price),
                                              products
                                                  .productDescrip,
                                              products
                                                  .category);
                                          // AddBloc(
                                          //     products
                                          //         .productDescrip,
                                          //     products
                                          //         .price,
                                          //     products
                                          //         .id);
                                        }
                                      },
                                      child: loading ==
                                          false
                                          ? AutoSizeText(
                                        'OK',
                                        style: GoogleFonts
                                            .varelaRound(
                                            fontSize:
                                            18.0,
                                            color: Colors
                                                .purple),
                                      )
                                          : CircularProgressIndicator(
                                        backgroundColor:
                                        Colors
                                            .red,
                                      ),
                                      color: Colors
                                          .green,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          new BorderRadius
                                              .circular(
                                              15.0),
                                          side: BorderSide(
                                              color: Colors
                                                  .white)),
                                    ),
                                    RaisedButton(
                                      padding:
                                      EdgeInsets.all(
                                          17.0),
                                      onPressed: () {
                                        Navigator.pop(
                                            context);
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          color: Colors
                                              .white,
                                          fontSize: 18,
                                          fontFamily:
                                          'Poppins-Medium.ttf',
                                        ),
                                        textAlign:
                                        TextAlign
                                            .center,
                                      ),
                                      color: Color(
                                          0xFFBC1F26),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          new BorderRadius
                                              .circular(
                                              15.0),
                                          side: BorderSide(
                                              color: Color(
                                                  0xFFBC1F26))),
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
                },
                // splashColor: Colors.yellow,
                // onDoubleTap: () => showSnackBar(),
                child: Material(
                  clipBehavior: Clip.antiAlias,
                  elevation: 2.0,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl:
                        'https://weddinghub.co.zw/img/${products.picture}',
                        placeholder: (context, url) =>
                            Image.asset('assets/loading.gif',
                              fit: BoxFit.cover,
                            ),
                      ),
                      // Image.network(
                      //   "https://weddinghub.co.zw/img/${products.picture}",
                      //   fit: BoxFit.cover,
                      // ),
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

          }),
            ],
          );
        });
  }
}
Future<List<Products>> fetchPrdoducts() async {
  String url = "http://weddinghub.co.zw/pos.php?stock=stock";
  final response = await http.get(url);
  return productsFromJson(response.body);
}

class CustomDialogw extends StatefulWidget {
  double charge;
  String invoice;
  CustomDialogw ({Key key, @required this.charge, @required this.invoice}) : super(key: key);


  @override
  _CustomDialogwState createState() => _CustomDialogwState();
}

class _CustomDialogwState extends State<CustomDialogw> {


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      width: 1000,
      // margin: EdgeInsets.only(top: 5),
      child:StepperBody(charge: widget.charge,invoice:widget.invoice
             )
    );
  }
}
class StepperBody extends StatefulWidget {
  double charge;
  String invoice;
  StepperBody({Key key, @required this.charge, @required this.invoice}) : super(key: key);
  @override
  _StepperBodyState createState() => _StepperBodyState();
}

class _StepperBodyState extends State<StepperBody> {

  int currStep = 0;

  Stream<QuerySnapshot> getPaySummary({int offset, int limit}) {

    Stream<QuerySnapshot> snapshots =FirebaseFirestore.instance.collection("pos_db").where("invoice",isEqualTo: widget.invoice).snapshots();
    // yourNeeds.add(snapshots);
    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }
    if (limit != null) {
      snapshots = snapshots.take(limit);
    }
    return snapshots;
  }
  @override
  void initState() {
    super.initState();
    items = new List();

    todoTasks?.cancel();
    todoTasks = getPaySummary().listen((QuerySnapshot snapshot) {
      final List<Cart> tasks = snapshot.docs
          .map((documentSnapshot) => Cart.fromMap(documentSnapshot.data()))
          .toList();
      setState(() {
        this.items = tasks;
      });
    });
    getProducts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Cart> items;
  FirestoreService fireServ = new FirestoreService();
  StreamSubscription<QuerySnapshot> todoTasks;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextStyle subtitle = TextStyle(fontSize: 12.0, color: Colors.grey);
  final TextStyle label = TextStyle(fontSize: 14.0, color: Colors.grey);
  double cartcharge;
  List<PaymentMenthod> selectedList = [];
  onSelectedRow(bool selected, PaymentMenthod paymentMenthod) async {
    setState(() {
      if (selected) {
        selectedList.add(paymentMenthod);
      } else {
        selectedList.remove(paymentMenthod);
      }
    });
  }

  final ValueNotifier<double> _counter = ValueNotifier<double>(0);
  final ValueNotifier<String> currency = ValueNotifier<String>('');
  TextEditingController _chargeController = TextEditingController();
  TextEditingController _controllerCart = TextEditingController();


  List<PaymentMenthod> _Prolist = [];
  var loading = false;
  Future<PaymentMenthod> getProducts() async {
    setState(() {
      loading = true;
    });
    _Prolist.clear();
    String urldata = "http://weddinghub.co.zw/pos.php?pay=pay";
    final response = await http.get(urldata);
    // final response = await http.get(url + "?id=${user_id}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        for (Map i in data) {
          _Prolist.add(PaymentMenthod.fromJson(i));
          loading = false;
        }
      });
    }
    print(urldata);
    print(_Prolist.length);
  }

  List payment = List();
  void _addPayment(String curency, double amount, double rate) async {
    setState(() {
      loading = true;
    });
    // ObjectId id1 = new ObjectId();
    await firestore.collection('paymethod').doc().set({
      "currency": curency,
      "amount": amount,
      "invoice": widget.invoice,
      "rate":rate,
    });
    dynamic newproduct = {
      "curency": curency,
      "amount": amount,
      "rate": rate,
    };
    setState(() {
      payment.add(newproduct);
      // print(newproduct);
    });
    _resetAmount(curency, amount, rate);
    // _calculateCharge();
    Navigator.pop(context);
  }

  void _resetAmount(String curency, double amount, double rate) {
    setState(() {
      _chargeController.text = '';
      curency = "";
      rate = double.parse('');
    });
  }

  void _calculateCharge() {
    double _charge = 0.00;
    payment.forEach((cart) {
      _charge += cart['price'] * cart['amount'];
      // _controllerCart= cart['title'];
    });
    print(_charge);
    setState(() {
      // charge = _charge;
    });
  }

  // String name, email, phone;

  //TextController to read text entered in text field
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _mobilecontroller = TextEditingController();
  // TextEditingController confirmpassword = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Widget verticalDivider() {
    return Container(height: 60, width: 2, color: Colors.black);
  }
  Divider _buildDivider() {
    return Divider(
      color: Colors.black,
    );
  }
  multi(x, y) => x * y;
  @override
  Widget build(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 12.0,
      fontWeight: FontWeight.w200,
    );
    TextStyle _statLabelTextStyle = TextStyle(
      color: Colors.black54,
      fontSize: 14.0,
      //fontWeight: FontWeight.bold,
    );
    List<Step> steps = [
      Step(
        title:Icon(Icons.monetization_on)
            .paddingOnly(top: 20, bottom: 5),
        // Text('Name', style: primaryTextStyle()),
        isActive: currStep == 0,
        state: StepState.indexed,
        content: Column(
          children: [
            Text(widget.invoice),
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Currency\n Name'),
                  Text('Exchange\n Rate'),
                  Text('Transaction \nCharge'),
                  Text('Paid'),
                  Text('Balance'),
                ],
              ),
              _buildDivider(),
              // SizedBox(height: 10,),
              _Prolist.length > 0
                  ? ValueListenableBuilder(
                builder:
                    (BuildContext context, double value, Widget child) {
                  return ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: _Prolist.length,
                      itemBuilder: (context, index) {
                        PaymentMenthod receipt = _Prolist[index];
                        return InkWell(
                          onTap: () => _paymentSuccessDialog(
                              context,
                              receipt.currency,
                              widget.charge,
                              receipt.exchangeRate),
                          child: Card(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(receipt.currency),
                                Text(receipt.exchangeRate),
                                Text(
                                    (widget.charge *
                                        double.parse(
                                            receipt.exchangeRate))
                                        .toStringAsFixed(2) +
                                        "${receipt.symbol}",
                                    style: secondaryTextStyle()),
                                // Text(widget.charge.toString()),
                                Text(
                                    (value *
                                        double.parse(
                                            receipt.exchangeRate))
                                        .toStringAsFixed(2),
                                    style: secondaryTextStyle()),
                                if (receipt.currency ==
                                    currency.value.toString())
                                  Text(
                                      ((widget.charge - value) *
                                          double.parse(
                                              receipt.exchangeRate))
                                          .toStringAsFixed(2),
                                      style: secondaryTextStyle())
                                else
                                  Text(
                                      (widget.charge *
                                          double.parse(receipt
                                              .exchangeRate) -
                                          value *
                                              double.parse(receipt
                                                  .exchangeRate))
                                          .toStringAsFixed(2),
                                      style: secondaryTextStyle()),
                              ],
                            ),
                          ),
                        );
                      });
                },
                valueListenable: _counter,
              )
                  :Center(
                child: CircularProgress(),
              ),
            ])
          ],
        ),
      ),
      Step(
        title: Icon(Icons.description),
        isActive: currStep == 1,
        state: StepState.indexed,
        content: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "Qty".toUpperCase(),
                          style: bioTextStyle,
                          textAlign: TextAlign.start,
                        ),
                      ]),
                  Column(children: <Widget>[
                    Text(
                      "Item".toUpperCase(),
                      style: bioTextStyle,
                    ),
                  ]),
                  Column(children: <Widget>[
                    Text("Price".toUpperCase(), style: bioTextStyle),
                  ]),
                  Column(children: <Widget>[
                    Text("Sub Total".toUpperCase(), style: bioTextStyle),
                  ]),
                ]),
            _buildDivider(),
            // ignore: missing_required_param
            Text('Simple Data table', style: boldTextStyle()).paddingBottom(5),
            DataTable(
              columnSpacing:10 ,
              columns: <DataColumn>[
                DataColumn(label: Text('Qnty'.toUpperCase(),style: bioTextStyle), tooltip: 'Rank'),
                DataColumn(label: Text('ITEM'.toUpperCase(),style: bioTextStyle)),
                DataColumn(label: Text('Price'.toUpperCase(),style: bioTextStyle)),
                DataColumn(label: Text('SubTotal'.toUpperCase(),style: bioTextStyle)),

              ],
              rows: items
                  .map(
                    (data) => DataRow(
                  cells: [
                    DataCell(Text(data.qnty.toString(), style: secondaryTextStyle())),
                    DataCell(Text(data.title, style: secondaryTextStyle())),
                    DataCell(Text("\$${data.price.toStringAsFixed(2)}", style: secondaryTextStyle())),
                    DataCell(Text("\$${multi(data.price,data.qnty)}", style: secondaryTextStyle())),

                  ],
                ),
              )
                  .toList(),
            ).visible(items.isNotEmpty),
               // ListView.builder(
               //      physics: NeverScrollableScrollPhysics(),
               //      shrinkWrap: true,
               //      primary: false,
               //      padding: EdgeInsets.all(16),
               //      itemCount: items.length,
               //      itemBuilder: (context, index) {
               //        return Row(
               //            mainAxisAlignment: MainAxisAlignment.spaceBetween,
               //            children: <Widget>[
               //              Column(
               //                  // mainAxisAlignment: MainAxisAlignment.end,
               //                  children: <Widget>[
               //                    Text(
               //                      items[index].qnty.toString(),
               //                      style: _statLabelTextStyle,
               //                      textAlign: TextAlign.start,
               //                    ),
               //                  ]),
               //              Column(children: <Widget>[
               //                Text(
               //                  items[index].title.toUpperCase(),
               //                  style: _statLabelTextStyle,
               //                ),
               //              ]),
               //              Column(children: <Widget>[
               //                Text(items[index].price.toString(),
               //                    style: _statLabelTextStyle),
               //              ]),
               //              Column(children: <Widget>[
               //                Text('\$${multi(items[index].price,items[index].qnty)}',
               //                    style: _statLabelTextStyle),
               //              ]),
               //            ]);
               //      }
               //  ),


            _buildDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: _statLabelTextStyle,
                ),
                Text(
                  widget.charge.toStringAsFixed(2),
                  style: _statLabelTextStyle,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "Currency Name".toUpperCase(),
                          style: bioTextStyle,
                          textAlign: TextAlign.start,
                        ),
                      ]),
                  Column(children: <Widget>[
                    Text(
                      "Amount Paid".toUpperCase(),
                      style: bioTextStyle,
                    ),
                  ]),
                  Column(children: <Widget>[
                    Text("Rate Used".toUpperCase(), style: bioTextStyle),
                  ]),
                ]),
            ListView.separated(
              shrinkWrap: true,
              primary: false,
              itemCount: payment.length,
              itemBuilder: (context, i) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(payment[i]['curency']),
                          ]),
                      Column(children: <Widget>[
                        Text(payment[i]['amount'].toString()),
                      ]),
                      Column(children: <Widget>[
                        Text(payment[i]['rate'].toString()),
                      ]),
                    ]);
              },
              separatorBuilder: (context, i) {
                return Divider(
                  height: 1,
                );
              },
            ),

          ],
        ),
      ),
      Step(
        title: Icon(Icons.border_color),
        isActive: currStep == 2,
        state: StepState.indexed,
        content: Column(
          children: [
            Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: TextFormField(
                      controller: _namecontroller,
                      keyboardType: TextInputType.text,
                      decoration:
                      buildInputDecoration(Icons.person, "Full Name"),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please Enter Name';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        _namecontroller.text = value;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: TextFormField(
                      controller: _emailcontroller,
                      keyboardType: TextInputType.text,
                      decoration: buildInputDecoration(Icons.email, "Email"),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please a Enter';
                        }
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return 'Please a valid Email';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        _emailcontroller.text = value;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: TextFormField(
                      controller: _mobilecontroller,
                      keyboardType: TextInputType.number,
                      decoration: buildInputDecoration(Icons.phone, "Phone No"),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter phone no ';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        _mobilecontroller.text = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ];

    return Stack(
      // color: Colors.white,
      children: [
     Container(
    padding: EdgeInsets.only(
    top: 18.0,),
       margin: EdgeInsets.only(top: 80.0, right: 8.0),
       decoration: BoxDecoration(
           color: Colors.white,
           shape: BoxShape.rectangle,
           borderRadius: BorderRadius.circular(16.0),
           boxShadow: <BoxShadow>[
             BoxShadow(
               color: Colors.black26,
               blurRadius: 0.0,
               offset: Offset(0.0, 0.0),
             ),
             //#60003F
             //#901c6c
           ]),
       child: Stepper(
          steps: steps,
          type: StepperType.horizontal,
          currentStep: this.currStep,
          controlsBuilder: (BuildContext context,
              {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
            return ResponsiveRow(
              // mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                RaisedButton(
                  color: Colors.green,
                  onPressed: onStepContinue
                  // if(_formkey.currentState.validate())
                  // {
                  //    print("successful");
                  //  ;
                  //   return;
                  // }else{
                  //   print("UnSuccessfull");
                  // }
                  ,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      side: BorderSide(color: Colors.greenAccent, width: 2)),
                  textColor: Colors.white,
                  child: AutoSizeText(
                      'Finish Payment:  \$' + widget.charge.toStringAsFixed(2)),
                ),
               SizedBox(width: 30,),
                RaisedButton(
                  color: Colors.amber,
                  onPressed: onStepCancel
            ,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      side: BorderSide(color: Colors.greenAccent, width: 2)),
                  textColor: Colors.white,
                  child: AutoSizeText(
                      'Cancel'),
                ),

              ],
            );
          },
          onStepContinue: () {
            setState(() {
              // payment.add(payment);
              // payment.forEach((cart) {
              //   // _charge += cart['price'] * cart['amount'];
              //   print(payment[0]['Rate'].toString());  // _controllerCart= cart['title'];
              // });

              if (currStep < steps.length - 1) {
                currStep = currStep + 1;
              } else {
                // print(_namecontroller.text);
               if(_namecontroller.text==""){
                 Fluttertoast.showToast(msg: "Name is Required");
               }
               else if(_emailcontroller.text==""){
                 Fluttertoast.showToast(msg: "Email is Required");
               }
               else if(_mobilecontroller.text==""){
                 Fluttertoast.showToast(msg: "Mobile is Required");
               }else{
              Navigator.push(
              context,
              // MaterialPageRoute(builder: (context) => CartScreen(charge: charge,receipt:_controllerCart.text.toString())),
              MaterialPageRoute(
              builder: (context) => PdfHome(
              charge: widget.charge, name: _namecontroller.text, mobile: _mobilecontroller.text, email: _emailcontroller.text, invoice:widget.invoice,
              )),
              );}
                //currStep = 0;
                // finish(context);
              }
            });
          },
          onStepCancel: () {
            finish(context);
            setState(() {
              if (currStep > 0) {
                currStep = currStep - 1;
              } else {
                currStep = 0;
              }
            });
          },
          onStepTapped: (step) {
            setState(() {
              currStep = step;
            });
          },
        ),
     ),
        Positioned(
          //right: 0.0,
          right: 5,
          top: 73,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 14.0,
                backgroundColor: Colors.white,
                child: Icon(
                  // Icons.cloud_circle
                    Icons.close,
                    color: Colors.black),
              ),
            ),
          ),
        ),
    ]);
  }
  _paymentSuccessDialog(
      BuildContext context, String name, double charge, String exc_rate) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: Stack(
              children: [
                Container(
                  height: 300,
                  padding: EdgeInsets.only(
                    top: 18.0,
                  ),
                  margin: EdgeInsets.only(top: 80.0, right: 8.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 0.0,
                          offset: Offset(0.0, 0.0),
                        ),
                        //#60003F
                        //#901c6c
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Thank You!",
                        style: TextStyle(color: Colors.green),
                      ),
                      Text(
                        "Are You Sure You want to pay using  " + name,
                        style: TextStyle(fontSize: 20),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Flexible(
                          flex: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextField(
//                    onChanged: (String value) {
//                      vs.validateEmail(value);
//                    },
                                keyboardType: TextInputType.phone,
                                controller: _chargeController,
                                showCursor: true,
                                decoration: InputDecoration(
//                      errorText: vs.email.error,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Color(0xFFF2F3F5),
                                  hintStyle: TextStyle(
                                    color: Color(0xFF666666),
                                  ),
                                  hintText:
                                  "enter amount you want to pay using ${name}",
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  RaisedButton(
                                    padding: EdgeInsets.all(17.0),
                                    onPressed: () {
                                      if (name != 'Usd')
                                        _counter.value +=
                                            double.parse(_chargeController.text) /
                                                double.parse(exc_rate);
                                      else
                                        _counter.value +=
                                            double.parse(_chargeController.text);
                                      _addPayment(
                                          name,
                                          double.parse(_chargeController.text),
                                          double.parse(exc_rate));
                                      currency.value = name;
                                      Navigator.pop(context, name);
                                    },
                                    child: Text(
                                      "Pay",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'Poppins-Medium.ttf',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    color: Colors.green,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        new BorderRadius.circular(15.0),
                                        side: BorderSide(color: Colors.white)),
                                  ),
                                  RaisedButton(
                                    padding: EdgeInsets.all(17.0),
                                    onPressed: () {
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
                                        borderRadius:
                                        new BorderRadius.circular(15.0),
                                        side:
                                        BorderSide(color: Color(0xFFBC1F26))),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  //right: 0.0,
                  right: 5,
                  top: 73,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        radius: 14.0,
                        backgroundColor: Colors.white,
                        child: Icon(
                          // Icons.cloud_circle
                            Icons.close,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),

          );
        });
  }
}
