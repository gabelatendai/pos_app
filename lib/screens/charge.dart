import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pos_app/Models/PayMethod.dart';
import 'package:http/http.dart' as http;
import 'package:pos_app/widgets/CircularProgress.dart';

import 'dialogs.dart';
import 'notifier.dart';
import 'CartPage.dart';
import 'home.dart';

class ChargeScreen extends StatefulWidget {
  double charge;
  String receipt;


  ChargeScreen({Key key,this.charge,
    @required this.receipt}): super(key: key);
  @override
  _ChargeScreenState createState() => _ChargeScreenState();
}

class _ChargeScreenState extends State<ChargeScreen> {
  final TextStyle subtitle = TextStyle(fontSize: 12.0, color: Colors.grey);
  final TextStyle label = TextStyle(fontSize: 14.0, color: Colors.grey);
  double cartcharge;
  final ValueNotifier<double> _counter = ValueNotifier<double>(0);
  final ValueNotifier<String> currency = ValueNotifier<String>('');
  TextEditingController _chargeController = TextEditingController();
  TextEditingController _controllerCart = TextEditingController();
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
  List<PaymentMenthod>_Prolist = [];
  var loading = false;
  Future <PaymentMenthod>getProducts() async {
    setState(() {
      loading = true;
    });
    _Prolist.clear();
    String urldata ="http://weddinghub.co.zw/pos.php?pay=pay";
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProducts();
    getProducts();
    cartcharge= widget.charge;
  }
  @override
  Widget build(BuildContext context) {
    Widget mHeading(var value) {
      return Text(value, style: boldTextStyle());
    }
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
        body:ListView(
            shrinkWrap: true,
            children:<Widget> [
              Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Icon(Icons.check_circle_outline, size: 130, color: Theme.of(context).primaryColor,),
                    ),
                    Expanded(
                      flex: 9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.charge.toString()),
                          // Text(widget.receipt?? cart,maxLines: 10),
                          Text(widget.receipt,maxLines: 10),
                          Text("Paid: ${_controllerCart.text}", style: TextStyle(fontSize: 20),)
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
                        onPressed: () =>{
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) =>  TableScreen()),
                        // ),
                            print("send receipt"),},
                        child: Text("SEND"),
                      )),
                ),
              ),
              Text('Data Table with multiple selections', style: boldTextStyle()).paddingOnly(top: 20, bottom: 5),
    ValueListenableBuilder(
    // ignore: missing_return
    builder: (BuildContext context, double value, Widget child) {
     return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Center(
          child: loading ?
          CircularProgress()
              : DataTable(
            columns: <DataColumn>[
              // DataColumn(label: mHeading('#'), tooltip: 'Rank'),
              DataColumn(label: mHeading('Currency\n Name')),
              DataColumn(label: mHeading('Exchange\n Rate')),
              DataColumn(label: mHeading('Transaction \nCharge')),
              DataColumn(label: mHeading('Paid')),
              DataColumn(label: mHeading('Balance')),
            ],

            rows: _Prolist.map(
                  (data) =>
                  DataRow(
                    selected: selectedList.contains(data),
                    onSelectChanged: (b) {
                      onSelectedRow(b, data);
                      toast(data.currency);
                      _paymentSuccessDialog(
                          context, data.currency, widget.charge, data.exchangeRate);
                      },
                    cells: [


                      // DataCell(Text(data.id, style: secondaryTextStyle())),
                      DataCell(
                          Text(data.currency, style: secondaryTextStyle())),
                      DataCell(
                          Text(data.exchangeRate, style: secondaryTextStyle())),

                      DataCell(Text("${widget.charge *
                          double.parse(data.exchangeRate).round()} ${data
                          .symbol}", style: secondaryTextStyle())),

                      DataCell(Text("${value * double.parse(data.exchangeRate)}", style: secondaryTextStyle())),
                      if(data.currency==currency.value.toString())
                        DataCell(Text("${(widget.charge - value) *
                            double.parse(data.exchangeRate).round()}",
                            style: secondaryTextStyle()))
                      else

      DataCell(Text("${widget.charge *
    double.parse(data.exchangeRate) - value * double.parse(data.exchangeRate).round()}",
      style: secondaryTextStyle())),
                    ],
                  ),
            ).toList(),
          ).visible(_Prolist.isNotEmpty),
        ),
      );
    },
      valueListenable: _counter,
      // child: Text('Payed'),
    ),
              Container(
                padding: EdgeInsets.all(8),
                child: RaisedButton(
                  onPressed: () {
                    print("back to home");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  Notifier()),
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
              TextField(
                controller: _controllerCart,
                maxLines: null,
                // expands: true,
                keyboardType: TextInputType.multiline,
              ),
            ] )
    );


  }
  List payment = List();
  void _addToPayment(String name,String price,String balance) async{
    // double sub= price * int.parse(_amountController.text);
    dynamic newproduct = {
      // "id": product,
      "title": name,
      "price": price,
      "amount": balance,
      // "category": category,
    };
    setState(() {
      payment.add(newproduct);

      _controllerCart.text += "${name}   ${price}  ${balance}";
      // _controllerCart.text += "${name.toString()}     ${price.toString()} ${product.toString()}    ${category.toString()}  ${_amountController.text} subtotal: ${sub.toString()}\n ";
    });

  }
  _paymentSuccessDialog(BuildContext context,String name, double charge,String exc_rate) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Dialog(
              child: Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Text(
                      "Thank You!",
                      style: TextStyle(color: Colors.green),
                    ),
                    Text(
                      "Are You Sure You want to pay using  "+ name,
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
                                ),
                                hintText: "enter amount you want to pay in ${name}",
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

                                    if(name!='Usd')
                                      _counter.value += double.parse(_chargeController.text)/double.parse(exc_rate);
                                    else
                                    _counter.value += double.parse(_chargeController.text);
                                     // currency.value = name;
                                     Navigator.pop(context,name);
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


Future<List<PaymentMenthod>> fetchProducts() async{
  String url ="http://weddinghub.co.zw/pos.php?pay=pay";
  final response = await http.get(url);
  return paymentMenthodFromJson(response.body);

}
