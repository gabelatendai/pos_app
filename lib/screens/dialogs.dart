import 'dart:convert';

import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crossplat_objectid/crossplat_objectid.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pos_app/Models/Cart.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pos_app/Models/PayMethod.dart';
import 'package:pos_app/screens/ListViewPage.dart';
import 'package:pos_app/screens/pdf.dart';
import 'package:pos_app/widgets/CircularProgress.dart';
import 'package:http/http.dart' as http;
import 'package:pos_app/widgets/InputDeco_design.dart';
import 'dart:async';

import 'firestoreservices.dart';

class StepperScreen extends StatefulWidget {
  double charge;
  StepperScreen({Key key, @required this.charge}) : super(key: key);
  @override
  _StepperScreenState createState() => _StepperScreenState();
}

class _StepperScreenState extends State<StepperScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Stepper'),
            actions: [
              IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () => Navigator.push(
                        context,
                        // MaterialPageRoute(builder: (context) => CartScreen(charge: charge,receipt:_controllerCart.text.toString())),
                        MaterialPageRoute(builder: (context) => Page3()),
                      ))
            ],
          ),
          body: StepperBody(
            charge: widget.charge,
          )),
    );
  }
}

Divider _buildDivider() {
  return Divider(
    color: Colors.black,
  );
}

class StepperBody extends StatefulWidget {
  double charge;
  StepperBody({Key key, @required this.charge}) : super(key: key);
  @override
  _StepperBodyState createState() => _StepperBodyState();
}

class _StepperBodyState extends State<StepperBody> {
  final pdf = pw.Document();

  int currStep = 0;

  @override
  void initState() {
    super.initState();
    items = new List();

    todoTasks?.cancel();
    todoTasks = fireServ.getTaskList().listen((QuerySnapshot snapshot) {
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
  Future savePdf() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String documentPath = documentDirectory.path;

    File file = File("$documentPath/example.pdf");

    file.writeAsBytesSync(pdf.save());
  }

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
    // await firestore.collection('currency').doc('${id1.toString()}').set({
    //   // "id": product,
    //   "id": id1.toHexString(),
    //   "currency": curency,
    //   "amount": amount,
    //   "rate":rate,
    // });
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

  String name, email, phone;

  //TextController to read text entered in text field
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Widget verticalDivider() {
    return Container(height: 60, width: 2, color: Colors.black);
  }

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
        title: Text('Choose \n Currency', style: boldTextStyle())
            .paddingOnly(top: 20, bottom: 5),
        // Text('Name', style: primaryTextStyle()),
        isActive: currStep == 0,
        state: StepState.indexed,
        content: Column(
          children: [
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
                  : Text("loading"),
            ])
          ],
        ),
      ),
      Step(
        title: Text('Payment \n Summary', style: primaryTextStyle()),
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
                    Text("Total".toUpperCase(), style: bioTextStyle),
                  ]),
                ]),
            _buildDivider(),
            ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  Cart receipt = items[index];
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                receipt.qnty.toString(),
                                style: _statLabelTextStyle,
                                textAlign: TextAlign.start,
                              ),
                            ]),
                        Column(children: <Widget>[
                          Text(
                            receipt.title.toUpperCase(),
                            style: _statLabelTextStyle,
                          ),
                        ]),
                        Column(children: <Widget>[
                          Text(receipt.price.toString(),
                              style: _statLabelTextStyle),
                        ]),
                        Column(children: <Widget>[
                          Text(receipt.subtotal.toString(),
                              style: _statLabelTextStyle),
                        ]),
                      ]);
                }),
            _buildDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: _statLabelTextStyle,
                ),
                Text(
                  widget.charge.toString(),
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
        title: Text('Finish Payment', style: primaryTextStyle()),
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
                        name = value;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: TextFormField(
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
                        email = value;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: buildInputDecoration(Icons.phone, "Phone No"),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please enter phone no ';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        phone = value;
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

    return Container(
      child: Stepper(
        steps: steps,
        type: StepperType.horizontal,
        currentStep: this.currStep,
        controlsBuilder: (BuildContext context,
            {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
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
                    'Charge:  \$' + widget.charge.toStringAsFixed(2)),
              ),
              10.width,
              MaterialButton(
                  padding: EdgeInsets.all(0),
                  splashColor: Colors.blue,
                  onPressed: onStepCancel,
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.amber,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        AutoSizeText(
                          'Cancel:  ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 5, left: 5),
                          child: Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  )),
              FlatButton(
                onPressed: () async {
                  writeOnPdf();
                  await savePdf();

                  Directory documentDirectory =
                      await getApplicationDocumentsDirectory();

                  String documentPath = documentDirectory.path;

                  String fullPath = "$documentPath/example.pdf";

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PdfPreviewScreen(
                                path: fullPath,
                              )));
                },
                child: Text('PDF', style: secondaryTextStyle()),
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
              //currStep = 0;
              finish(context);
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
    );
  }

  writeOnPdf() {
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a5,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Header(level: 0, child: pw.Text("Receipt")),
          pw.Column(
            children: [
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: <pw.Widget>[
                    pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: <pw.Widget>[
                          pw.Text(
                            "Qty".toUpperCase(),
                            // style:bioTextStyle,
                            // textAlign: TextAlign.start,
                          ),
                        ]),
                    pw.Column(children: <pw.Widget>[
                      pw.Text(
                        "Item".toUpperCase(),
                        // style: bioTextStyle,
                      ),
                    ]),
                    pw.Column(children: <pw.Widget>[
                      pw.Text(
                        "Price".toUpperCase(),
                        // style: bioTextStyle
                      ),
                    ]),
                    pw.Column(children: <pw.Widget>[
                      pw.Text(
                        "Total".toUpperCase(),
                        // style: bioTextStyle
                      ),
                    ]),
                  ]),
              // pw._buildDivider(),
              pw.ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    Cart receipt = items[index];
                    return pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: <pw.Widget>[
                          pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: <pw.Widget>[
                                pw.Text(
                                  receipt.qnty.toString(),
                                  // pw.style: _statLabelTextStyle,
                                  // textAlign: TextAlign.start,
                                ),
                              ]),
                          pw.Column(children: <pw.Widget>[
                            pw.Text(
                              receipt.title.toUpperCase(),
                              // style: _statLabelTextStyle,
                            ),
                          ]),
                          pw.Column(children: <pw.Widget>[
                            pw.Text(
                              receipt.price.toString(),
                              // style: _statLabelTextStyle
                            ),
                          ]),
                          pw.Column(children: <pw.Widget>[
                            pw.Text(
                              receipt.subtotal.toString(),
                              // style: _statLabelTextStyle
                            ),
                          ]),
                        ]);
                  }),
              // _buildDivider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "Total",
                    // style:
                    // _statLabelTextStyle,
                  ),
                  pw.Text(
                    widget.charge.toString(),
                    // style: _statLabelTextStyle,
                  )
                ],
              ),
              pw.SizedBox(
                height: 10,
              ),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: <pw.Widget>[
                    pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: <pw.Widget>[
                          pw.Text(
                            "Currency Name".toUpperCase(),
                            // style: bioTextStyle,
                            // textAlign: TextAlign.start,
                          ),
                        ]),
                    pw.Column(children: <pw.Widget>[
                      pw.Text(
                        "Amount Paid".toUpperCase(),
                        // style: bioTextStyle,
                      ),
                    ]),
                    pw.Column(children: <pw.Widget>[
                      pw.Text(
                        "Rate Used".toUpperCase(),
                        // style: bioTextStyle
                      ),
                    ]),
                  ]),
              pw.ListView.separated(
                // shrinkWrap: true,
                // primary: false,
                itemCount: payment.length,
                itemBuilder: (context, i) {
                  return pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: <pw.Widget>[
                        pw.Column(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: <pw.Widget>[
                              pw.Text(payment[i]['curency']),
                            ]),
                        pw.Column(children: <pw.Widget>[
                          pw.Text(payment[i]['amount'].toString()),
                        ]),
                        pw.Column(children: <pw.Widget>[
                          pw.Text(payment[i]['rate'].toString()),
                        ]),
                      ]);
                },
                separatorBuilder: (context, i) {
                  return pw.Divider(
                    height: 1,
                  );
                },
              ),
            ],
          )
        ];
      },
    ));
  }

  _paymentSuccessDialog(
      BuildContext context, String name, double charge, String exc_rate) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Dialog(
              child: Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Thank You!",
                      style: TextStyle(color: Colors.green),
                    ),
                    Text(
                      "Are You Sure You want to pay using  " + name,
                      style: label,
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
                                    "enter amount you want to pay in ${name}",
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
            ),
          );
        });
  }
}

Future<List<PaymentMenthod>> fetchProducts() async {
  String url = "http://weddinghub.co.zw/pos.php?pay=pay";
  final response = await http.get(url);
  return paymentMenthodFromJson(response.body);
}
