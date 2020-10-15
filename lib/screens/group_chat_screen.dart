import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:turn_pages/screens/groupChat/messages.dart';
import 'package:turn_pages/screens/groupChat/new_message.dart';

class GroupChatScreen extends StatefulWidget {
  final String groupId;
  final String groupName;

  GroupChatScreen(this.groupId, this.groupName);

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final Color primaryColor = Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen = Color(0xff25bcbb);

  final _controller = new TextEditingController();
  var _enteredMessage = '';

  void _sendMessage(String groupId, String enteredMessage) async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();

    Firestore.instance
        .collection('groups')
        .document(groupId)
        .collection("chat")
        .add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['fullName']
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(widget.groupName, style: TextStyle(color: Colors.white, fontFamily: "Lato"),),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: primaryColor,
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages(widget.groupId),
            ),
            NewMessage(widget.groupId),
          ],
        ),
      ),
    );
  }
}
