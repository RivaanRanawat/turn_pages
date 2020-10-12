import 'package:turn_pages/models/authModel.dart';
import 'package:turn_pages/models/groupModel.dart';
import 'package:turn_pages/root/root_file.dart';
import 'package:turn_pages/services/dbFuture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewScreen extends StatefulWidget {
  final GroupModel groupModel;

  ReviewScreen({@required this.groupModel});
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final Color primaryColor = Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen = Color(0xff25bcbb);
  final reviewKey = GlobalKey<ScaffoldState>();
  TextEditingController _reviewController = TextEditingController();
  int _dropdownValue;
  AuthModel _authModel;

  @override
  void didChangeDependencies() {
    _authModel = Provider.of<AuthModel>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      key: reviewKey,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      "Rate book 1-10:",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: "Lato",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DropdownButton<int>(
                      dropdownColor: secondaryColor,
                      value: _dropdownValue,
                      icon: Icon(Icons.arrow_downward, color: Colors.white),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      underline: Container(
                        height: 2,
                        color: primaryColor,
                      ),
                      onChanged: (int newValue) {
                        setState(() {
                          _dropdownValue = newValue;
                        });
                      },
                      items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                          .map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Center(
                            child: Text(
                              value.toString(),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: secondaryColor,
                      border: Border.all(color: Colors.blue)),
                  child: TextFormField(
                    controller: _reviewController,
                    maxLines: 6,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      alignLabelWithHint: true,
                      labelText: "Add A Review",
                      labelStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                    ),
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
                    if (_dropdownValue != null) {
                      DBFuture().finishedBook(
                          widget.groupModel.id,
                          widget.groupModel.currentBookId,
                          _authModel.uid,
                          _dropdownValue,
                          _reviewController.text);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OurRoot(),
                        ),
                        (route) => false,
                      );
                    } else {
                      reviewKey.currentState.showSnackBar(SnackBar(
                        content: Text("Need to add rating!"),
                      ));
                    }
                  },
                  color: logoGreen,
                  child: Text('Add Review',
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
