import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  final String sender, receiver,message;

  
  ChatScreen({this.sender, this.receiver, this.message});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = <ChatMessage>[];

  final TextEditingController _textController = new TextEditingController();

  getMessages() async {

    var url = 'http://192.168.42.93:8000/messages/';
    Map<String, dynamic> details = {
      "username": this.widget.sender,
      "reciever": this.widget.receiver
    };
    var body = json.encode(details);
    var resp = await http.post(url, body: body);
    var res = json.decode(resp.body.toString());
    return res["messages"];
  }

  void _handleSubmitted(String text) async{
   
    Map<String, dynamic> details = {
      "username": this.widget.sender,
      "reciever": this.widget.receiver,
      "message": text
    };
    print(details);
    var body = json.encode(details);
    var url = "http://192.168.42.93:8000/savemessages/";
    var resp = await http.post(url, body:body);
    var res = json.decode(resp.body.toString());
    _messages.clear();
    _textController.clear();
    getMessages();
    setState((){
    });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Box'),
      ),
      body: FutureBuilder(
          future: getMessages(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != null) {
              if (snapshot.data.length == 0) {
                return Center(child: Text("Empty"));
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ChatMessage(
                        name: snapshot.data[index]["username"],
                        text: snapshot.data[index]["message"],
                      );
                    });
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Widget _buildTextComposer(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              ),
            ),
            new Divider(
              height: 1.0,
            ),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(context),
            ),
            TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration.collapsed(
                hintText: "Send a message",
              ),
            ),
            Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // _handleSubmitted(_textController.text);
                  },
                )),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text, name;
  ChatMessage({this.text, this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              child: Text(name[0]),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(name, style: Theme.of(context).textTheme.subhead),
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Text(text),
              )
            ],
          )
        ],
      ),
    );
  }
}
