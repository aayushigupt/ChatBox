import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:login/screens/page.dart';
import 'page.dart';


class Listing extends StatefulWidget
{
  final String username;
  Listing({this.username});
  @override
  _ListingState createState() => _ListingState();
}


class _ListingState extends State<Listing> {
  fetchChatHeads() async{
    var url = 'http://192.168.42.93:8000/get/chats/';
    var resp = await http.get(url);
    Map<String, dynamic> data = json.decode(resp.body.toString());
    return data["listOfUsernames"];
  }
@override
  Widget build(BuildContext context){
	return Scaffold(
		body: FutureBuilder(
			future: fetchChatHeads(),
			builder: (BuildContext context, AsyncSnapshot snapshot){
				if(snapshot.data != null){
          print(snapshot.data);
      
					 if(snapshot.data.length != 0){
					 	return ListView.builder(
					 		itemCount: snapshot.data.length,
					 		itemBuilder: (BuildContext context, int index){
					 			return ListTile(
                  onTap: (){
                    var rec = snapshot.data[index]["username"];
                    var sender = widget.username;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ChatScreen(
                          sender: sender,
                          receiver: rec,
                        )
                      )
                    );
                  },
									leading: CircleAvatar(
					 					radius: 28,
					 					child: Icon(Icons.person_outline)
									),
					 				title: Text(
					 					snapshot.data[index]["username"]
					 				)
					 			);
					 		}
					 	);
					 }
					 else{
					 	return Center(
					 		child: Text(
					 			"No users found!"
					 		)
					 	);
					 }
				}
				else{
					return Center(
						child: CircularProgressIndicator()
					);
				}
			}
		),
    floatingActionButton: FloatingActionButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> ChatScreen()));
      },
    ),
	);
}
 
}
