import 'package:turn_pages/models/userModel.dart';
import 'package:turn_pages/screens/create_group_screen.dart';
import 'package:turn_pages/screens/join_group_screen.dart';
import 'package:turn_pages/root/root_file.dart';
import 'package:turn_pages/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoGroupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xff18203d);
    final Color logoGreen = Color(0xff25bcbb);
    UserModel _currentUser = Provider.of<UserModel>(context);

    void _goToJoin(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JoinGroupScreen(
            userModel: _currentUser,
          ),
        ),
      );
      print(_currentUser);
    }

    void _goToCreate(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateGroupScreen(_currentUser),
        ),
      );
    }

    void _signOut(BuildContext context) async {
      String _returnString = await Auth().signOut();
      if (_returnString == "success") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => OurRoot(),
          ),
          (route) => false,
        );
      }
    }

    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 20, 0),
                child: IconButton(
                  onPressed: () => _signOut(context),
                  icon: Icon(Icons.exit_to_app),
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Spacer(flex: 1,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              "Turn Pages",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: "Roboto",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "You are not in any of the Turn Pages Club, either join or create one!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontFamily: "Lato",
              ),
            ),
          ),
          Spacer(
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MaterialButton(
                  elevation: 0,
                  height: 50,
                  onPressed: () => _goToCreate(context),
                  color: logoGreen,
                  child: Text("Create"),
                  textColor: Colors.white,
                ),
                MaterialButton(
                  elevation: 0,
                  height: 50,
                  onPressed: () => _goToJoin(context),
                  color: Colors.blue,
                  child: Text(
                    "Join",
                    style: TextStyle(color: Colors.white),
                  ),
                  textColor: Colors.white,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
