import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  List _countries = ['Cambodia', 'Thailand', 'Vietname'];

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _businessController = TextEditingController();
  String _email = '';
  String _password = '';
  String _business = '';
  String _country = '';
  bool _agree = false;
  bool _showpass = false;

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = List();
    for (String country in _countries) {
      items.add(
        DropdownMenuItem(value: country, child: Text(country)),
      );
    }
    return items;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _country = _countries[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("REGISTRATION"),
      ),
      body: Container(
        color: Colors.white,
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(15),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: "Email",
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: TextField(
                obscureText: !_showpass,
                controller: _passwordController,
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Password",
                    contentPadding: EdgeInsets.all(15),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showpass = !_showpass;
                        });
                      },
                      child: _showpass
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                    )),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _business = value;
                  });
                },
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.business),
                  hintText: "Business name",
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Country",
                  prefixIcon: Icon(Icons.language),
                ),
                value: _country,
                items: getDropDownMenuItems(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: _agree,
                    onChanged: (value) {
                      setState(() {
                        _agree = value;
                      });
                    },
                    activeColor: Colors.green,
                  ),
                  Text("I understand and agree to NAGAPOS "),
                  Text(
                    "Term of Use",
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                  Text(" and "),
                  Text(
                    "Privacy Policy",
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              color: Colors.green,
              onPressed: () => Navigator.of(context).pushNamed('/home'),
              padding: EdgeInsets.all(0),
              child: Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.green)),
                width: 500,
                child: Text(
                  "SIGN UP",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
