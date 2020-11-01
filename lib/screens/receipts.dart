import 'package:flutter/material.dart';
import '../widgets/drawer.dart';

class ReceiptScreen extends StatefulWidget {
  @override
  _ReceiptScreenState createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {

  TextEditingController _searchReceiptContoller = TextEditingController();
  String _searchReceipt = '';

  List receipts = [
    {
      "id": 1,
      "invoice": "#10-1122",
      'carts': [
        {
          "id": 1,
          "title": "Product 1",
          "price": 10.00,
          "amount": 1,
          "category": {
            "id": 1,
            "title": "category 1",
          }
        },
        {
          "id": 2,
          "title": "Product 2",
          "price": 20.00,
          "amount": 2,
          "category": {
            "id": 2,
            "title": "category 2",
          }
        },
        {
          "id": 3,
          "title": "Product 3",
          "price": 30.00,
          "amount": 3,
          "category": {
            "id": 3,
            "title": "category 3",
          }
        },
        
      ],
      "total": 25.00,
      "discount": 0.00,
      "charged": 25.00,
      "user": {"id": 1, "name": "Jonette"},
      "customer": {"id": 1, "name": "Steven Hawlking"},
      "created_at": "12-09-2019"
    },
    {
      "id": 2,
      "invoice": "#10-1222",
      'carts': [
        {
          "id": 1,
          "title": "Product 1",
          "price": 10.00,
          "amount": 1,
          "category": {
            "id": 1,
            "title": "category 1",
          }
        },
        {
          "id": 2,
          "title": "Product 2",
          "price": 20.00,
          "amount": 2,
          "category": {
            "id": 2,
            "title": "category 2",
          }
        },
        {
          "id": 3,
          "title": "Product 3",
          "price": 30.00,
          "amount": 3,
          "category": {
            "id": 3,
            "title": "category 3",
          }
        }
      ],
      "total": 25.00,
      "discount": 0.00,
      "charged": 25.00,
      "user": {"id": 1, "name": "Jonette"},
      "customer": {"id": 2, "name": "Steven Hawlking"},
      "created_at": "12-09-2019"
    },
    {
      "id": 3,
      "invoice": "#10-1333",
      'carts': [
        {
          "id": 1,
          "title": "Product 1",
          "price": 10.00,
          "amount": 1,
          "category": {
            "id": 1,
            "title": "category 1",
          }
        },
        {
          "id": 2,
          "title": "Product 2",
          "price": 20.00,
          "amount": 2,
          "category": {
            "id": 2,
            "title": "category 2",
          }
        },
        {
          "id": 3,
          "title": "Product 3",
          "price": 30.00,
          "amount": 3,
          "category": {
            "id": 3,
            "title": "category 3",
          }
        }
      ],
      "total": 25.00,
      "discount": 0.00,
      "charged": 25.00,
      "user": {"id": 1, "name": "Jonette"},
      "customer": {"id": 3, "name": "Steven Hawlking"},
      "created_at": "12-09-2019"
    },
    {
      "id": 4,
      "invoice": "#10-1444",
      'carts': [
        {
          "id": 1,
          "title": "Product 1",
          "price": 10.00,
          "amount": 1,
          "category": {
            "id": 1,
            "title": "category 1",
          }
        },
        {
          "id": 2,
          "title": "Product 2",
          "price": 20.00,
          "amount": 2,
          "category": {
            "id": 2,
            "title": "category 2",
          }
        },
        {
          "id": 3,
          "title": "Product 3",
          "price": 30.00,
          "amount": 3,
          "category": {
            "id": 3,
            "title": "category 3",
          }
        }
      ],
      "total": 25.00,
      "discount": 0.00,
      "charged": 25.00,
      "user": {"id": 1, "name": "Jonette"},
      "customer": {"id": 4, "name": "Steven Hawlking"},
      "created_at": "12-09-2019"
    }
  ];

  Map _receipt;

  void _viewReceiptDetail(Map receipt) {
    setState(() {
      _receipt = receipt;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receipts"),
        actions: <Widget>[
          FlatButton(
            onPressed: () => print("Refund"),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                Text(
                  "REFUND",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          FlatButton(
            onPressed: () => print("Remove"),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.remove_shopping_cart,
                  color: Colors.white,
                ),
                Text(
                  "CANCEL",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: DrawerWidget(),
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Card(
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: TextField(
                        controller: _searchReceiptContoller,
                        onChanged: (value){
                          setState(() {
                            _searchReceipt = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search),
                          hintText: "Enter receipt number"
                        ),
                      ),
                    ),
                  ),
                  Divider(height: 1,),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Text("Tuesday, 15 February 2018", style: TextStyle(color: Colors.green),),
                    )
                  ),
                  Divider(height: 1,),

                  Expanded(
                    flex: 10,
                    child: ListView.separated(
                      itemCount: receipts.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: _receipt != null && receipts[index]['id'] == _receipt['id']
                              ? Colors.green[100]
                              : Colors.white,
                          child: ListTile(
                            onTap: () {
                              _viewReceiptDetail(receipts[index]);
                            },
                            leading: Icon(Icons.attach_money),
                            title: Text('${receipts[index]['total']}'),
                            subtitle: Text('${receipts[index]['created_at']}'),
                            trailing: Text('${receipts[index]['invoice']}'),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.grey[300],
            height: 1,
          ),
          Expanded(
            flex: 8,
            child: Container(
              alignment: Alignment.center,
              child: ReceiptWidget(receipt: _receipt),
            ),
          )
        ],
      ),
    );
  }
}

class ReceiptWidget extends StatelessWidget {
  final Map<String, dynamic> receipt;

  const ReceiptWidget({Key key, this.receipt}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return receipt != null
        ? Container(
            padding: EdgeInsets.only(right: 50, left: 50, top: 10),
            color: Colors.grey[100],
            child: Card(
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(15),
                    alignment: Alignment.topCenter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            this.receipt['invoice'],
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          'Total',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 8, 8, 8),
                    child: Text('Casheir : ${receipt['user']['name']}'),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 8, 8, 8),
                    child: Text('Casheir : ${receipt['customer']['name']}'),
                  ),
                  Divider(),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 1000),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: receipt['carts'].length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('${receipt['carts'][index]['title']}'),
                          subtitle: Text(
                              '${receipt['carts'][index]['amount']} x ${receipt['carts'][index]['price']}0'),
                          trailing: Text(
                              '${receipt['carts'][index]['amount'] * receipt['carts'][index]['price']}'),
                        );
                      },
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      "Points earned",
                      style: TextStyle(color: Colors.green),
                    ),
                    trailing: Text(
                      "3.09",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Points Redeemed",
                      style: TextStyle(color: Colors.green),
                    ),
                    trailing: Text(
                      "0.00",
                      style: TextStyle(color: Colors.green),
                    ),
                  )
                ],
              ),
            ),
          )
        : Container(
            child: Text("Select any receipt to see detail"),
          );
  }
}
