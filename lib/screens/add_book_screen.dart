import 'package:turn_pages/models/book.dart';
import 'package:turn_pages/models/userModel.dart';
import 'package:turn_pages/root/root_file.dart';
import 'package:turn_pages/services/dbFuture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';

class AddBookScreen extends StatefulWidget {
  final bool onGroupCreation;
  final bool onError;
  final String groupName;
  final UserModel currentUser;

  AddBookScreen({
    this.onGroupCreation,
    this.onError,
    this.groupName,
    this.currentUser,
  });
  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final addBookKey = GlobalKey<ScaffoldState>();

  TextEditingController _bookNameController = TextEditingController();
  TextEditingController _authorController = TextEditingController();
  TextEditingController _lengthController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  final Color primaryColor = Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen = Color(0xff25bcbb);

  FocusNode authorNode;
  FocusNode lengthNode;

  @override
  void dispose() {
    authorNode.dispose();
    lengthNode.dispose();
    super.dispose();
  }

  initState() {
    super.initState();
    _selectedDate = DateTime(_selectedDate.year, _selectedDate.month,
        _selectedDate.day, _selectedDate.hour, 0, 0, 0, 0);
    authorNode = FocusNode();
    lengthNode = FocusNode();
  }

  Future<void> _selectDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2222));

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = DateTime(picked.year, picked.month, picked.day,
            _selectedDate.hour, 0, 0, 0, 0);
      });
    }
  }

  Future _selectTime() async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new NumberPickerDialog.integer(
          minValue: 0,
          maxValue: 23,
          initialIntegerValue: 0,
          infiniteLoop: true,
        );
      },
    ).then((num value) {
      if (value != null) {
        setState(() {
          _selectedDate = DateTime(_selectedDate.year, _selectedDate.month,
              _selectedDate.day, value, 0, 0, 0, 0);
        });
      }
    });
  }

  void _addBook(BuildContext context, String groupName, BookModel book) async {
    String _returnString;

    if (_selectedDate.isAfter(DateTime.now().add(Duration(days: 1)))) {
      if (widget.onGroupCreation) {
        _returnString =
            await DBFuture().createGroup(groupName, widget.currentUser, book);
      } else if (widget.onError) {
        _returnString =
            await DBFuture().addCurrentBook(widget.currentUser.groupId, book);
      } else {
        _returnString =
            await DBFuture().addNextBook(widget.currentUser.groupId, book);
      }

      if (_returnString == "success") {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => OurRoot(),
            ),
            (route) => false);
      }
    } else {
      addBookKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Due date should be more than a day from now"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      key: addBookKey,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[BackButton()],
            ),
          ),
          SizedBox(
            height: 40,
          ),
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
                    controller: _bookNameController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      labelText: "Book Name",
                      labelStyle: TextStyle(color: Colors.white),
                      icon: Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => authorNode.requestFocus(),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: secondaryColor,
                      border: Border.all(color: Colors.blue)),
                  child: TextFormField(
                    focusNode: authorNode,
                    controller: _authorController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      labelText: "Author's Name",
                      labelStyle: TextStyle(color: Colors.white),
                      icon: Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => lengthNode.requestFocus(),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: secondaryColor,
                      border: Border.all(color: Colors.blue)),
                  child: TextFormField(
                    focusNode: lengthNode,
                    controller: _lengthController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      labelText: "Length of the books",
                      labelStyle: TextStyle(color: Colors.white),
                      icon: Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(DateFormat.yMMMMd("en_US").format(_selectedDate),
                    style: TextStyle(color: Colors.white, fontFamily: "Lato")),
                Text(DateFormat("H:00").format(_selectedDate),
                    style: TextStyle(color: Colors.white, fontFamily: "Lato")),
                Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                        child: Text("Change Date",
                            style: TextStyle(
                                color: Colors.white, fontFamily: "Lato")),
                        onPressed: () => _selectDate(),
                      ),
                    ),
                    Expanded(
                      child: FlatButton(
                        child: Text("Change Time",
                            style: TextStyle(
                                color: Colors.white, fontFamily: "Lato")),
                        onPressed: () => _selectTime(),
                      ),
                    ),
                  ],
                ),
                MaterialButton(
                elevation: 0,
                minWidth: double.maxFinite,
                height: 50,
                onPressed: () {
                  BookModel book = BookModel();
                    if (_bookNameController.text == "") {
                      addBookKey.currentState.showSnackBar(SnackBar(
                        content: Text("Need to add book name"),
                      ));
                    } else if (_authorController.text == "") {
                      addBookKey.currentState.showSnackBar(SnackBar(
                        content: Text("Need to add author"),
                      ));
                    } else if (_lengthController.text == "") {
                      addBookKey.currentState.showSnackBar(SnackBar(
                        content: Text("Need to add book length"),
                      ));
                    } else {
                      book.name = _bookNameController.text;
                      book.author = _authorController.text;
                      book.length = int.parse(_lengthController.text);
                      book.dateCompleted = Timestamp.fromDate(_selectedDate);

                      _addBook(context, widget.groupName, book);
                    }
                },
                color: logoGreen,
                child: Text('Create',
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
        ],
      ),
    );
  }
}