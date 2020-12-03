import 'package:flutter/material.dart';
import '../widgets/drawer.dart';

class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  List faqs = [
    {
      "id": 1,
      "question": "This is question 1",
      "answer": "This is the answer 1",
    },
    {
      "id": 2,
      "question": "This is question 2",
      "answer": "This is the answer 2",
    },/**/
    {
      "id": 3,
      "question": "This is question 3",
      "answer": "This is the answer 3",
    },
    {
      "id": 4,
      "question": "This is question 4",
      "answer": "This is the answer 4",
    },
    {
      "id": 5,
      "question": "This is question 5",
      "answer": "This is the answer 5",
    },
    {
      "id": 6,
      "question": "This is question 6",
      "answer": "This is the answer 6",
    },
    {
      "id": 7,
      "question": "This is question 7",
      "answer": "This is the answer 7",
    },
    {
      "id": 8,
      "question": "This is question 8",
      "answer": "This is the answer 8",
    },
    {
      "id": 9,
      "question": "This is question 9",
      "answer": "This is the answer 9",
    },
    {
      "id": 10,
      "question": "This is question 10",
      "answer": "This is the answer 10",
    }
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Support"),
      ),
      drawer: DrawerWidget(),
      body:  _currentIndex == 1
              ? Message()
              : Container(
                  alignment: Alignment.center,
                  child: Text("Support"),
                ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            _currentIndex, // this will be set when a new tab is tapped
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.mail),
            title: new Text('Messages'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.headset_mic),
            title: Text('HELP'),
          )
        ],
      ),
    );
  }
}
class Message extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  String _name = '';
  String _email = '';
  String _message = '';

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Card(
        child: Container(
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(15),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      this._name = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Your name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      this._email = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Your email',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    prefixIcon: Icon(Icons.alternate_email),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: TextField(
                  maxLines: 8,
                  onChanged: (value) {
                    setState(() {
                      this._message = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Your question',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal),
                    ),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.all(15),
                child: RaisedButton(
                  color: Colors.green[100],
                  onPressed: ()=> print("Send"),
                  child: Text("SEND TO US"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
