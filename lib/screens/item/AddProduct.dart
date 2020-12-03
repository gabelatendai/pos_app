import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'inputField.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

// import 'package:image/image.dart';

void main() => runApp(AddItemPage());

class TambahItem extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add New Item',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes:  <String, WidgetBuilder>{
      },
      home: AddItemPage(),
    );
  }
}

File image;
String filename;

class RIKeys {
  static final riKey1 = const Key('rikey1');
  static final riKey2 = const Key('rikey2');
  static final riKey3 = const Key('rikey3');
}

class AddItemPage extends StatefulWidget {
  // final FirebaseUser emailReg;

  final String email,passwordValue;
  final TabController controller;
  AddItemPage({Key key, this.email, this.passwordValue,this.controller}) : super(key: key);

  @override
  _AddItemPageState createState() => _AddItemPageState();

}
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

DecorationImage backgroundImage = new DecorationImage(
  image: new ExactAssetImage('assets/img/login_logo.png'),
  fit: BoxFit.cover,
);

TextStyle headingStyle = new TextStyle(
  color: Colors.white,
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
);

class _AddItemPageState extends State<AddItemPage>
{
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  String _name,_galleryImage;
  int _sellingPrice;
  var _category;
  String dropdownValue;
  final db = FirebaseFirestore.instance;
  // String _uid;
  String id;
  String idUser;
  String _email;
  String role;

  bool autoValidate=false;
  bool emailExist=false;
  
  @override
  void initState(){
   
    _loadUid();
     super.initState();
  }
    _loadUid() async {             
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idUser = (prefs.getString ('uid')??'');
      _email = (prefs.getString ('email')??'');
      role = (prefs.getString ('role')??'');
      if(idUser==null){
         CircularProgressIndicator();
      }
      print("Load IdUSer");
      print(idUser);
      print(_email);
    });
  }

/*  final _formKeyBusiness = GlobalKey<FormState>();*/
  TextEditingController itemNameController = new TextEditingController();
  TextEditingController categoryController = new TextEditingController(); 
  // MoneyMaskedTextController supplierPriceController = new MoneyMaskedTextController(leftSymbol: 'Rp', thousandSeparator: '.');
  // MoneyMaskedTextController sellingPriceController = new MoneyMaskedTextController(leftSymbol: 'Rp', thousandSeparator: '.');
  TextEditingController qtyController = new TextEditingController();
  // TextEditingController supplierPriceController = new TextEditingController();
  TextEditingController sellingPriceController = new TextEditingController();

  final FocusNode myFocusNodeStoreName = FocusNode();
  final FocusNode myFocusNodeCategory = FocusNode();
  final FocusNode myFocusNodeOwner = FocusNode();
  final FocusNode myFocusNodeAddress = FocusNode();
  final FocusNode myFocusNodePhone = FocusNode();
  String _counter;
  String _barcode;
  bool useBarcode=false;

  Future _scanStok() async{
    _counter = await FlutterBarcodeScanner.scanBarcode("#004297", "Cancel", true, ScanMode.DEFAULT);
    useBarcode=true;
    setState(() {
     _barcode=_counter; 
    });
    print('bar code  $_barcode');
  }

 Future _getImage() async{
    var selectedImage =  await ImagePicker.pickImage(source: ImageSource.gallery);
    setState((){
      image=selectedImage;
      filename=basename(image.path);
      print(image.path);
      print(filename);
    });
  }

  Future<Null> refreshList() async {
    // image=null;
    refreshKey.currentState?.show(atTop: false);
    
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      new AddItemPage(controller: this.widget.controller,);
    });

    return null;
  }

  Widget uploadArea(){
    return Column(
      children: <Widget>[
        Image.file(image, width:300, height: 200,),
      ],
    );
  }
   SpeedDial buildSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      // child: Icon(Icons.add),
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.image, color: Colors.white),
          backgroundColor: Colors.blueAccent[50],
          onTap: () => _getImage(),
          label: 'Add Image',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.white,
        ),
        SpeedDialChild(
          child: Icon(Icons.settings_overscan, color: Colors.white),
          backgroundColor: Colors.blueAccent[50],
          onTap: () => _scanStok(),
          label: 'Scan Barcode',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.white,
        ),
        ],
    );
  }

  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    //print(context.widget.toString());
    return new Scaffold(
        key: RIKeys.riKey2,
        // drawer: buildDrawer(context,idUser,_email,role),
        body: new SingleChildScrollView(
          child: new Container(
            padding: new EdgeInsets.all(15.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new SizedBox(
                    height: 50.0 ,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          "Add New Item",
                          textAlign: TextAlign.center,
                          // style: headingStyle,
                        )
                      ],
                    )),

                new SizedBox(
                  height: screenSize.height,
                  child: new Column(
                    children: <Widget>[
                      new Form(
                        //onWillPop: _warnUserAboutInvalidData,
                          child: new Column(
                            children: <Widget>[
                              image == null ?
                          Container(
                            width: 200,
                            height: 200,
                            child: Image.asset("assets/img.png"),
                          )
                              :uploadArea(),
                              SizedBox(height: 15.0,),
                              new InputField(
                                controllerFunction: itemNameController,
                                hintText: "Product Name",
                                obscureText: false,
                                textInputType: TextInputType.text,
                                // textStyle: textStyle,
                                // textFieldColor: textFieldColor,
                                icon: Icons.text_fields,
                                iconColor: Colors.black,
                                bottomMargin: 10.0,
                                validateFunction: (value){
                                  if(value.isEmpty){
                                    return 'Please enter the value';
                                  }
                                  return null;
                                }
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                      Icons.category,
                                      size: 22.0,
                                        color: Colors.black
                                  ),
                                  SizedBox(width:20.0),
                                  Expanded(
                                    // kalau streambuilder hasilnya null awalnya maka error 18/7/19
                                    child: StreamBuilder<QuerySnapshot>(
                                    stream: db.collection("categories").snapshots(),
                                    builder: (context, snapshot) {
                                    if(snapshot.data == null) return CircularProgressIndicator();
                                    if (!snapshot.hasData && snapshot.data.docs.length<=0)
                                      return const Text("Loading.....");
                                    else {
                                      List<DropdownMenuItem> itemKategori = [];
                                      if(snapshot.data.docs.length>0){
                                        for (int i = 0; i < snapshot.data.docs.length; i++) {
                                        DocumentSnapshot snap = snapshot.data.docs[i];
                                        itemKategori.add(
                                        DropdownMenuItem(
                                            child: Text(

                                              snap['title'].toString(),
                                              style: TextStyle(color: Colors.grey[800]),
                                            ),
                                              // value: "hahah",
                                              value: "${snap['title']}",
                                            ),
                                          );
                                        }
                                      }
                                        return Container(
                                          key:RIKeys.riKey2,
                                          width: 300.0,
                                          child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                items: itemKategori,
                                                value:  _category,
                                                hint:  new Text(
                                                         "Category",
                                                         style: TextStyle(color:Colors.grey[800]),
                                                        ),
                                                onChanged:(currencyValue) {
                                                  // final snackBar = SnackBar(
                                                  // content: Text(
                                                  //   'Selected Currency value is $currencyValue',
                                                  //    style: TextStyle(color: Color(0xff11b719)),
                                                  //  ),
                                                  // );
                                                  // Scaffold.of(context).showSnackBar(snackBar);
                                                    setState(() {
                                                     _category = currencyValue;
                                                    });
                                                  },
                                                style: TextStyle(
                                                  color: Colors.grey[800],
                                                ),

                                            ),
                                          )
                                      );
                                      }
                                    },
                                    ),
                                  )
                                ],
                              ),
                              // new InputField(
                              //   hintText: "Supplier Price",
                              //   obscureText: false,
                              //   textInputType: TextInputType.number,
                              //   icon: Icons.people,
                              //   iconColor: Colors.black,
                              //   bottomMargin: 10.0,
                              //   controllerFunction: supplierPriceController,
                              // ),
                              new InputField(
                                hintText: "Selling Price",
                                obscureText: false,
                                textInputType: TextInputType.number,
                                icon: Icons.account_balance,
                                iconColor: Colors.black,
                                bottomMargin: 10.0,
                                controllerFunction: sellingPriceController,
                              ),
                               new MaterialButton(
                                child: new Text("Create", style: new TextStyle(color: Colors.white),),
                                color: Colors.lightBlue,
                                onPressed: (){
                                  createData(context);
                                }
                               ),
                            ],
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton:  buildSpeedDial()
        );
  }

    void deleteImage(image){
      image=null;
    }
    @override
    void dispose() {
      image=null;
      super.dispose();
    }
 
    Future<void> createData(context) async{
      Reference ref = FirebaseStorage.instance.ref().child(filename);
      UploadTask uploadTask = ref.putFile(image);

      var url = await(await uploadTask).ref.getDownloadURL();
      _galleryImage = url.toString();
        DateTime now = DateTime.now();
      // var userQuery = await db.collection('owner').document(idUser).collection('promo').where('promo_code',isEqualTo: promoCodeStr).getDocuments();
      String formattedTime = DateFormat('yyyy-MM-dd hh:mm').format(now);
      _name=itemNameController.text;
      _sellingPrice=int.tryParse(sellingPriceController.text);

            try{
              db.collection('products').doc().set({
            // final docRef = await db.collection('owner').doc().collection('products').add({
              'id_item': '$_barcode',
              'time_added' : formattedTime,
              'item_name': '$_name ',
              'item_category': '$_category',
              'item_qty': 0,
              'item_supplierprice': 0,
              'item_sellingprice': _sellingPrice,
              'item_photo': '$_galleryImage',
              'status_active': true
            });

            _showDialog(context);
            itemNameController.clear();
            sellingPriceController.clear();
            // _category="";
            
          }catch(e){
            print(e.toString());
          }


    }
    
  void _showDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Success"),
          content: new Text("Item Sucesfully Added"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}

