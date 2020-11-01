import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/screens/CartPage.dart';
// import 'package:reference/screens/second.dart';

class Home extends StatelessWidget {
  // goToNext() {
  //   //Navigator.push(context, MaterialPageRoute(builder: (context)=>Second()));
  //   navigator.push(MaterialPageRoute(builder: (context) => DataPickerPage()));
  //   //Get.to(Second());
  // }
  TextEditingController  _controllerCart=new TextEditingController();


  _showSnackBar() {
    Get.snackbar(
      "Hey There",
      "Snackbar is easy",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  _showDialog() {
    Get.defaultDialog(
      title: "Simple Dialog",
      content: Text("Too Easy"),
    );
  }

  _showBottomSheet() {
    Get.bottomSheet(
      Container(
        child: Wrap(
          children: <Widget>[
         Container(
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
                                // setState(() {
                                //   _currentQnty =
                                //   _currentQnty < 2
                                //       ? 1
                                //       : _currentQnty - 1;
                                //   _qntyController.text =
                                //   '$_currentQnty';
                                // })

                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextField(

                              onChanged: (value) {
                                // setState(() {
                                //   _currentQnty =
                                //       int.parse(value);
                                // });
                              },
                              style: TextStyle(fontSize: 20),
                              textAlign:TextAlign.center,
                              keyboardType: TextInputType
                                  .numberWithOptions(),
                              controller: _controllerCart,
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
                                // setState(() {
                                //   _currentQnty++;
                                //   _qntyController.text =
                                //   '$_currentQnty';
                                // });
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
                            onPressed: (){
                              // if(int.parse(_qntyController.text) > qnty){
                              //   toastLong("Your Quantity is greater than available stock");
                              //
                              // }else {
                              //   _addToCart(
                              //       pro.id, price, pro.productDescrip,
                              //       pro.category);
                              // }
                              },
                            child: Text('OK',
                             ),

                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(15.0),
                                side: BorderSide(color:Colors.white)),
                          ),

                          RaisedButton(
                            padding: EdgeInsets.all(17.0),
                            onPressed: (){



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

          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get Package | Home"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("Go To Second"),
              onPressed: () => {}
                  // goToNext(),
            ),
            RaisedButton(
              child: Text("Snackbar"),
              onPressed: _showSnackBar,
            ),
            RaisedButton(
              child: Text("Dialog"),
              onPressed: _showDialog,
            ),
            RaisedButton(
              child: Text("Bottom Sheet"),
              onPressed: _showBottomSheet,
            ),
            SizedBox(
              height: 40,
            ),
            RaisedButton(
              child: Text("Name Route: /second"),
              onPressed: () {
                Get.toNamed("/second");
              },
            )
          ],
        ),
      ),
    );
  }
}