import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _db = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
User _user;

class ChatPage extends StatefulWidget{
  static const String id = 'chat_screen';
  final String title = 'Chat';

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageTextController = TextEditingController();
  String messageText;

  @override
  void initState() {
    super.initState();

    _user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              onPressed: (){
                _auth.signOut();
                Navigator.pop(context);
              },
              icon: Icon(Icons.close)
          )
        ],
        title: Text(widget.title),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              child:Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: TextField(
                        controller: messageTextController,
                        onChanged: (value){
                          messageText = value;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0
                          ),
                          hintText: 'Type your message here...',
                          border: InputBorder.none,
                        ),
                      )
                  ),
                  TextButton(
                      onPressed: (){
                        messageTextController.clear();
                        _db.collection('messages').add(
                          {
                            'text': messageText,
                            'sender': _user.email,
                            'time': FieldValue.serverTimestamp(),
                          }
                        );
                      },
                      child: Text(
                      'Send',
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                  )
                ],
              )
            )
          ],
        ),
      )
    );
  }
}

class MessageStream extends StatelessWidget{
  @override
  Widget build(BuildContext context){}
    return StreamBuilder<QuerySnapshot>(
      stream _db
        .collection('messages')
        .orderBy('time', descending:true)
        .limit(50)
        .snapshots(),
      builder: (context, snapshot){}
        if(!snapshot.hasData){}
        
      )
}
