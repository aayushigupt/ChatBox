import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './list.dart';

import 'package:login/screens/list.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
  }

  TextEditingController usernameController = new TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: BluePainter(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(left: 150.0, bottom: 80.0),
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  )),
              
     Container(
       width: 320,
       
       padding: EdgeInsets.only(bottom: 50.0),
        child: Form(
      child: Column(
        children: <Widget>[
          Material(
            color: Colors.blue[700],
            elevation: 8,
            shadowColor: Colors.blue[900],
            child: TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: 'Your Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: Colors.grey[600]),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Colors.grey[700]))),
            ),
          )
        ],
      ),
    )),

            ],
          ),
        ),
      ),

     floatingActionButton: FloatingActionButton(
      onPressed: () async{
          setState(() {});
          Map<String, dynamic> positionDetails = {
            "username": usernameController.text
          };
          var temp = json.encode(positionDetails);
          var url = 'http://192.168.42.93:8000/login/';
          var res = await http.post(url, body:temp);
          
          var t = res.body;
          var body = json.decode(t.toString());
          print(body);
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Listing(
            username: usernameController.text
          )));
        }, 
        child: Icon(Icons.check)
      ), 
    );
  }

  
}

class BluePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = Colors.blue.shade500;
    canvas.drawPath(mainBackground, paint);

    Path ovalPath = Path();

    ovalPath.moveTo(0, height * 0.2);

    ovalPath.quadraticBezierTo(
        width * 0.45, height * 0.25, width * 0.51, height * 0.5);

    ovalPath.quadraticBezierTo(width * 0.58, height * 0.8, width * 0.1, height);

    ovalPath.lineTo(0, height);

    ovalPath.close();

    paint.color = Colors.blue.shade400;
    canvas.drawPath(ovalPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
