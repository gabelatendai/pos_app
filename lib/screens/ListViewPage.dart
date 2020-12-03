import 'package:flutter/material.dart';

class Page3 extends StatefulWidget {
  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
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
    final sizeX = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Center(
            child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Clear All",
                        style: TextStyle(color: Colors.purple),
                      ),
                      Flexible(fit: FlexFit.tight, child: SizedBox()),
                      Icon(Icons.delete_forever),
                    ],
                  ),
                  Expanded(
                      child: ListView(
                        children: <Widget>[
                          SizedBox(
                            height: 15,
                          ),
                          _history(),
                          _buildDivider(),
                          SizedBox(
                            height: 15,
                          ),
                          _history(),
                          SizedBox(
                            height: 15,
                          ),
                          _buildDivider(),
                          SizedBox(
                            height: 15,
                          ),
                          _history(),
                          SizedBox(
                            height: 15,
                          ),
                          _buildDivider(),
                          SizedBox(
                            height: 15,
                          ),
                          _history(),
                          SizedBox(
                            height: 15,
                          ),
                          _buildDivider(),
                          SizedBox(
                            height: 15,
                          ),
                          _history(),
                          SizedBox(
                            height: 15,
                          ),
                          _buildDivider(),
                          SizedBox(
                            height: 15,
                          ),
                          _history(),
                          SizedBox(
                            height: 15,
                          ),
                          _buildDivider(),
                          SizedBox(
                            height: 15,
                          ),
                          _history(),
                          SizedBox(
                            height: 15,
                          ),
                          _buildDivider(),
                        ],
                      ))
                ]
              // child:Center(child: Text("page 3"),)
            ))
    );
  }

  Widget verticalDivider() {
    return Container(height: 60, width: 2, color: Colors.black);
  }
  _history() {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 12.0,
      fontWeight: FontWeight.w200,
    );
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "Order ID".toUpperCase(),
                  style: bioTextStyle,
                  textAlign: TextAlign.start,
                ),
                Text(
                  "123abcd456".toUpperCase(),
                ),
              ]),
          Column(children: <Widget>[
            Text(
              "Date".toUpperCase(),
              style: bioTextStyle,
            ),
            Text("09/09/19".toUpperCase()),
          ]),
          Column(children: <Widget>[
            Text("Total".toUpperCase(), style: bioTextStyle),
            Text("Aed 12,345.67".toUpperCase()),
          ]),
        ]);
  }
}

Divider _buildDivider() {
  return Divider(
    color: Colors.black,
  );
}

class Week extends StatelessWidget {
  const Week({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // padding: EdgeInsets.only(left:20),
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 15,
              ),
              Text(
                "Clear All",
                style: TextStyle(color: Colors.purple),
              ),
              Flexible(fit: FlexFit.tight, child: SizedBox()),
              Icon(Icons.delete_forever),
            ],
          ),
          Expanded(
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  _history(),
                  _buildDivider(),
                  SizedBox(
                    height: 15,
                  ),
                  _history(),
                  SizedBox(
                    height: 15,
                  ),
                  _buildDivider(),
                  SizedBox(
                    height: 15,
                  ),
                  _history(),
                  SizedBox(
                    height: 15,
                  ),
                  _buildDivider(),
                  SizedBox(
                    height: 15,
                  ),
                  _history(),
                  SizedBox(
                    height: 15,
                  ),
                  _buildDivider(),
                  SizedBox(
                    height: 15,
                  ),
                  _history(),
                  SizedBox(
                    height: 15,
                  ),
                  _buildDivider(),
                  SizedBox(
                    height: 15,
                  ),
                  _history(),
                  SizedBox(
                    height: 15,
                  ),
                  _buildDivider(),
                  SizedBox(
                    height: 15,
                  ),
                  _history(),
                  SizedBox(
                    height: 15,
                  ),
                  _buildDivider(),
                ],
              ))
        ]
          // child:Center(child: Text("page 3"),)
        ));
  }

  _history() {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 12.0,
      fontWeight: FontWeight.w200,
    );
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "Order ID".toUpperCase(),
                  style: bioTextStyle,
                  textAlign: TextAlign.start,
                ),
                Text(
                  "123abcd456".toUpperCase(),
                ),
              ]),
          Column(children: <Widget>[
            Text(
              "Date".toUpperCase(),
              style: bioTextStyle,
            ),
            Text("09/09/19".toUpperCase()),
          ]),
          Column(children: <Widget>[
            Text("Total".toUpperCase(), style: bioTextStyle),
            Text("Aed 12,345.67".toUpperCase()),
          ]),
        ]);
  }
}

class Month extends StatelessWidget {
  const Month({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // padding: EdgeInsets.only(left:20),
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 15,
              ),
              Text(
                "Clear All",
                style: TextStyle(color: Colors.purple),
              ),
              Flexible(fit: FlexFit.tight, child: SizedBox()),
              Icon(Icons.delete_forever),
            ],
          ),
          Expanded(
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  _history(),
                  _buildDivider(),
                  SizedBox(
                    height: 15,
                  ),
                  _history(),
                  SizedBox(
                    height: 15,
                  ),
                  _buildDivider(),
                  SizedBox(
                    height: 15,
                  ),
                  _history(),
                  SizedBox(
                    height: 15,
                  ),
                  _buildDivider(),
                  SizedBox(
                    height: 15,
                  ),
                  _history(),
                  SizedBox(
                    height: 15,
                  ),
                  _buildDivider(),
                  SizedBox(
                    height: 15,
                  ),
                  _history(),
                  SizedBox(
                    height: 15,
                  ),
                  _buildDivider(),
                  SizedBox(
                    height: 15,
                  ),
                  _history(),
                  SizedBox(
                    height: 15,
                  ),
                  _buildDivider(),
                  SizedBox(
                    height: 15,
                  ),
                  _history(),
                  SizedBox(
                    height: 15,
                  ),
                  _buildDivider(),
                ],
              ))
        ]
          // child:Center(child: Text("page 3"),)
        ));
  }

  _history() {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 12.0,
      fontWeight: FontWeight.w200,
    );
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(children: <Widget>[
            Text(
              "Order ID".toUpperCase(),
              style: bioTextStyle,
              textAlign: TextAlign.start,
            ),
            Text(
              "123abcd456".toUpperCase(),
            ),
          ]),
          Column(children: <Widget>[
            Text(
              "Date".toUpperCase(),
              style: bioTextStyle,
            ),
            Text("09/09/19".toUpperCase()),
          ]),
          Column(children: <Widget>[
            Text("Total".toUpperCase(), style: bioTextStyle),
            Text("Aed 12,345.67".toUpperCase()),
          ]),
        ]);
  }
}

class Year extends StatelessWidget {
  const Year({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // padding: EdgeInsets.only(left:20),
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 15,
              ),
              Text(
                "Clear All",
                style: TextStyle(color: Colors.purple),
              ),
              Flexible(fit: FlexFit.tight, child: SizedBox()),
              Icon(Icons.delete_forever),
            ],
          ),
          Expanded(
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  _history(),
                  _buildDivider(),
                  SizedBox(
                    height: 15,
                  ),
                  _history(),
                  SizedBox(
                    height: 15,
                  ),
                  _buildDivider(),
                  SizedBox(
                    height: 15,
                  ),
                  _history(),
                  SizedBox(
                    height: 15,
                  ),
                  _buildDivider(),
                  SizedBox(
                    height: 15,
                  ),
                  _history(),
                  SizedBox(
                    height: 15,
                  ),
                  _buildDivider(),
                  SizedBox(
                    height: 15,
                  ),
                  _history(),
                  SizedBox(
                    height: 15,
                  ),
                  _buildDivider(),
                  SizedBox(
                    height: 15,
                  ),
                  _history(),
                  SizedBox(
                    height: 15,
                  ),
                  _buildDivider(),
                  SizedBox(
                    height: 15,
                  ),
                  _history(),
                  SizedBox(
                    height: 15,
                  ),
                  _buildDivider(),
                ],
              ))
        ]
          // child:Center(child: Text("page 3"),)
        ));
  }

  _history() {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 12.0,
      fontWeight: FontWeight.w200,
    );
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(children: <Widget>[
            Text(
              "Order ID".toUpperCase(),
              style: bioTextStyle,
              textAlign: TextAlign.start,
            ),
            Text(
              "123abcd456".toUpperCase(),
            ),
          ]),
          Column(children: <Widget>[
            Text(
              "Date".toUpperCase(),
              style: bioTextStyle,
            ),
            Text("09/09/19".toUpperCase()),
          ]),
          Column(children: <Widget>[
            Text("Total".toUpperCase(), style: bioTextStyle),
            Text("Aed 12,345.67".toUpperCase()),
          ]),
        ]);
  }
}
