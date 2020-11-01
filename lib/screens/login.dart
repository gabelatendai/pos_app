import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _email = '';
  String _password = '';
  bool _showpass = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SIGN IN"),
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
                      onTap: (){
                        setState(() {
                          _showpass = ! _showpass;
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
                  "LOGIN",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pushNamed('/forget'),
              child: Text(
                "Forget password?",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
