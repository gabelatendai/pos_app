import 'package:flutter/material.dart';

class SingleProductScreen extends StatefulWidget {
  @override
  _SingleProductScreenState createState() => _SingleProductScreenState();
}

class _SingleProductScreenState extends State<SingleProductScreen> {
  List categories = [
    {"id": 1, "title": "Category 1"},
    {"id": 2, "title": "Category 2"},
    {"id": 3, "title": "Category 3"},
    {"id": 4, "title": "Category 4"}
  ];

  int category;
  List<DropdownMenuItem<int>> getDropdownItems() {
    List<DropdownMenuItem<int>> items = List();
    for (var category in categories) {
      items.add(DropdownMenuItem(
        value: category['id'],
        child: Text('${category['title']}'),
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Add New Item"),
      ),
      body: Container(
          padding: EdgeInsets.all(15),
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Item Description",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              "Name",
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: null,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  "Select Category",
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.all(8),
                                  child: DropdownButtonFormField(
                                    hint: Text("Select a Category"),
                                    items: getDropdownItems(),
                                    value: category,
                                    onChanged: (value) {
                                      setState(() => {
                                            category = value,
                                          });
                                      print(category.toString());
                                    },
                                  )),
                            ],
                          )),
                    )
                  ],
                ),

                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Price",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        width: 400,
                        child: TextFormField(),
                      )
                    ],
                  ),
                ),

                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "SKU CODE",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        width: 400,
                        child: TextFormField(),
                      )
                    ],
                  ),
                ),

                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "BARCODE",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        width: 400,
                        child: TextFormField(),
                      )
                    ],
                  ),
                )

                
              ],
            ),
          ),),

          floatingActionButton: RaisedButton(
            color: Colors.lightGreen,
            onPressed: ()=> print("save product"),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.save, color: Colors.white,),
                ),
                Text("SAVE", style: TextStyle(color: Colors.white),)
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
