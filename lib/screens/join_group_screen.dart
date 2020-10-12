import 'package:turn_pages/models/userModel.dart';
import 'package:turn_pages/root/root_file.dart';
import 'package:turn_pages/services/dbFuture.dart';
import 'package:flutter/material.dart';

class JoinGroupScreen extends StatefulWidget {
  final UserModel userModel;

  JoinGroupScreen({this.userModel});
  @override
  _JoinGroupScreenState createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  final Color primaryColor = Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen = Color(0xff25bcbb);

  void _joinGroup(BuildContext context, String groupId) async {
    UserModel _currentUser = widget.userModel;
    String _returnString = await DBFuture().joinGroup(groupId, _currentUser);
    if (_returnString == "success") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => OurRoot(),
          ),
          (route) => false);
    } else {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(_returnString),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  TextEditingController _groupIdController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[BackButton(color: Colors.white)],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: secondaryColor,
                      border: Border.all(color: Colors.blue)),
                  child: TextFormField(
                    controller: _groupIdController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      labelText: "Group Id",
                      labelStyle: TextStyle(color: Colors.white),
                      icon: Icon(
                        Icons.group,
                        color: Colors.white,
                      ),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                MaterialButton(
                  elevation: 0,
                  minWidth: double.maxFinite,
                  height: 50,
                  onPressed: () {
                    _joinGroup(context, _groupIdController.text);
                  },
                  color: Colors.blue,
                  child: Text('Join',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(0),
                      topLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
