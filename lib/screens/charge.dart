import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/Models/PayMethod.dart';
import 'package:http/http.dart' as http;
import 'package:pos_app/screens/dialogs.dart';
import 'package:pos_app/widgets/CircularProgress.dart';
import 'home.dart';

class ChargeScreen extends StatefulWidget {
  double charge;
  String receipt;

  ChargeScreen({Key key, this.charge, @required this.receipt})
      : super(key: key);
  @override
  _ChargeScreenState createState() => _ChargeScreenState();
}

class _ChargeScreenState extends State<ChargeScreen> {
  final TextStyle subtitle = TextStyle(fontSize: 12.0, color: Colors.grey);
  final TextStyle label = TextStyle(fontSize: 14.0, color: Colors.grey);
  double cartcharge;

  TextEditingController _chargeController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProducts();
    cartcharge = widget.charge;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Charge"),
          actions: <Widget>[
            IconButton(
              onPressed: () => print("print"),
              icon: Icon(Icons.print),
            )
          ],
        ),
        body: ListView(shrinkWrap: true, children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 130,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(widget.charge.toString()),
                      // Text(widget.receipt?? cart,maxLines: 10),
                      Text(widget.receipt, maxLines: 10),
                      Text(
                        "Change: 8.00",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  hintText: "Customer email...",
                  suffix: RaisedButton(
                    onPressed: () => print("send receipt"),
                    child: Text("SEND"),
                  )),
            ),
          ),
          FutureBuilder(
              future: fetchProducts(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: CircularProgress(),
                  );
                  //child: Products(),
                } else {
                  return ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        PaymentMenthod products = snapshot.data[index];
                        double rate = double.parse(products.exchangeRate);
                        return InkWell(
                          onTap: () {
                            // showDialog(
                            //     context: context,
                            //     builder: (BuildContext context) =>
                            //         AddQuote());
                            _paymentSuccessDialog(
                                context, products.currency, cartcharge);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(products.currency),
                              Text(products.exchangeRate),
                              Text("${cartcharge * rate}"),
                              Text(products.symbol),
                              Text("kkkk"),
                              Divider(),
                              SizedBox(
                                height: 30,
                              )
                            ],
                          ),
                        );
                      });
                }
              }),
          Container(
            padding: EdgeInsets.all(8),
            child: RaisedButton(
              onPressed: () {
                print("back to home");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
                // Navigator.of(context).pushNamed('/home');
              },
              color: Colors.lightGreen,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "New sale",
                    style: TextStyle(color: Colors.white),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.check_circle, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ]));
  }

  _paymentSuccessDialog(BuildContext context, String name, double charge) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: SizedBox(
              height: 370,
              child: Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
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
                                controller: _chargeController,
                                showCursor: true,

                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  filled: true,
                                  // prefixIcon: Icon(
                                  //   Icons.phone,
                                  //   color: Color(0xFF666666),
                                  //   // size: defaultIconSize,
                                  // ),
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
                              Container(
                                width: double.infinity,
                                child: RaisedButton(
                                  padding: EdgeInsets.all(17.0),
                                  onPressed:
//                        (!vs.isValid) ? null:
                                      () => {
                                    print(cartcharge -
                                        double.parse(_chargeController.text))
                                  },
                                  child: Text(
                                    "Sign In",
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
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFF2F3F7)),
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
