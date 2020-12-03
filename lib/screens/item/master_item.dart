import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AddStock.dart' as addStok;
import 'AddProduct.dart' as addDesc;
import 'showItem.dart';


class RIKeys {
  static final riKey1 = const Key('rikey1');
  static final riKey2 = const Key('rikey2');
  static final riKey3 = const Key('rikey3');
}
//SEMENTARA UNTUK LOAD MASTER ITEM MENGGUNAKAN ExampleScreen
class ExampleScreen extends StatefulWidget {
  @override
  _ExampleScreenState createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> with SingleTickerProviderStateMixin {
  String idUser,_email,role;
  final db= Firestore.instance;
  TabController controller;

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
  
  @override
  void initState(){
    
    controller = new TabController(vsync: this, length: 3);
    super.initState();
    _loadUid();
  }
  
  @override
  Widget build(BuildContext context) {
       return new Scaffold(
        appBar: new AppBar(
          actions: <Widget>[
            
          ],
        title: 
        InkWell(
          child:  new Text('Master Item'),
          onTap:(){
            print("jjjaja");
              // Navigator.push(
              //     context,
              //   MaterialPageRoute(builder: (context) => Home()) ,
              // );
          }
        ),    
        // backgroundColor: Colors.amber,
        bottom: new TabBar(
          controller: controller,
          tabs: <Tab>[
            new Tab(icon: new Icon(Icons.home), text: "List",),
            new Tab(icon: new Icon(Icons.list),text: "Add Item",),      
            new Tab(icon: new Icon(Icons.add),text: "Add Stock",),    
          ]
        ),
      ),
      // drawer:buildDrawer(context,idUser,_email,role),
        body: new TabBarView(
          controller: controller,
          key: RIKeys.riKey1,
          children: <Widget>[
            new ShowItem(controller: controller,),
            new addDesc.AddItemPage(controller: controller,),
             new addStok.AddStokPage(controller: controller,),
          ]
        ),

      );
  }
 
}

