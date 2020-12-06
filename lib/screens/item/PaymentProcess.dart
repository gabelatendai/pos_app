import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive/flutter_responsive.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pos_app/Models/Cart.dart';
import 'package:pos_app/Models/PayMethod.dart';
import 'package:pos_app/controllers/pdfhome.dart';
import 'package:pos_app/widgets/CircularProgress.dart';
import 'package:pos_app/widgets/InputDeco_design.dart';
import 'package:http/http.dart' as http;




class ProcessDialoge extends StatefulWidget {
  double charge;
  String invoice;
  ProcessDialoge ({Key key, @required this.charge, @required this.invoice}) : super(key: key);


  @override
  _ProcessDialogeState createState() => _ProcessDialogeState();
}

class _ProcessDialogeState extends State<ProcessDialoge> {


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
  DateTime now = new DateTime.now();

  Stream<QuerySnapshot> getPaySummary({int offset, int limit}) {

    Stream<QuerySnapshot> snapshots =FirebaseFirestore.instance.collection("cart").where("invoice",isEqualTo: widget.invoice).snapshots();
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
  // FirestoreService fireServ = new FirestoreService();
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
            // Text(widget.invoice),
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
                                        .toStringAsFixed(2),
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


            // ignore: missing_required_param
            Text('Transaction Summary', style: boldTextStyle()).paddingBottom(5),
            _buildDivider(),
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
                    DataCell(Text("\$${multi(data.price,data.qnty).toStringAsFixed(2)}", style: secondaryTextStyle())),

                  ],
                ),
              )
                  .toList(),
            ).visible(items.isNotEmpty),
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
                setState(() async{
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
                      await firestore.collection('sales_db').doc(widget.invoice).set({
                        "seller_location": "",
                        "transaction_date": "${DateFormat('yMd').format(now)}",
                        "customer_mobile": _mobilecontroller.text,
                        "customer_email": _emailcontroller.text,
                        "castomer_name": _namecontroller.text,
                        "total": widget.charge,
                        "id": widget.invoice,
                      });

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
