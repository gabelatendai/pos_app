import 'package:flutter/material.dart';
import '../widgets/drawer.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List _countries = ['Cambodia', 'Thailand', 'Vietname'];

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  String _email = '';
  String _password = '';
  String _phone = '';
  String _country = '';

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
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Profile"),
        ),
        drawer: DrawerWidget(),
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(15),
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 300,
                    height: 300,
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(
                        Radius.circular(150),
                      ),
                    ),
                    child: Opacity(
                      opacity: 0.7,
                      child: Container(
                        height: 150,
                        foregroundDecoration: BoxDecoration(
                            color: Colors.grey[400],
                            backgroundBlendMode: BlendMode.darken,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(150),
                              bottomRight: Radius.circular(150),
                            )),
                        alignment: Alignment.center,
                        child: IconButton(
                          icon: Icon(Icons.photo_camera),
                          onPressed: () => print("take photo"),
                        ),
                      ),
                    ),
                  ),
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
                        ),
                      ),
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
                          _phone = value;
                        });
                      },
                      controller: _phoneController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        hintText: "Phone number",
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
                  MaterialButton(
                    color: Colors.green,
                    onPressed: () => print("save"),
                    padding: EdgeInsets.all(0),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.green)),
                      width: 500,
                      child: Text(
                        "SAVE",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    onPressed: () => print("log out"),
                    padding: EdgeInsets.all(0),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.green)),
                      width: 500,
                      child: Text(
                        "LOG OUT",
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
