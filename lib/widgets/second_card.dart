import 'package:turn_pages/models/book.dart';
import 'package:turn_pages/models/groupModel.dart';
import 'package:turn_pages/models/userModel.dart';
import 'package:turn_pages/screens/add_book_screen.dart';
import 'package:turn_pages/services/dbFuture.dart';
import 'package:turn_pages/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SecondCard extends StatefulWidget {
  @override
  _SecondCardState createState() => _SecondCardState();
}

class _SecondCardState extends State<SecondCard> {
  final Color secondaryColor = Color(0xff232c51);
  GroupModel _groupModel;
  UserModel _currentUser;
  UserModel _pickingUser;
  BookModel _nextBook;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _groupModel = Provider.of<GroupModel>(context);
    _currentUser = Provider.of<UserModel>(context);
    
    if (_groupModel != null) {
      _pickingUser = await DBFuture()
          .getUser(_groupModel.members[_groupModel.indexPickingBook]);
      if (_groupModel.nextBookId != "waiting") {
        _nextBook = await DBFuture()
            .getCurrentBook(_groupModel.id, _groupModel.nextBookId);
      }

      if (this.mounted) {
        setState(() {});
      }
    }
  }

  void _goToAddBook(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddBookScreen(
          onGroupCreation: false,
          onError: false,
          currentUser: _currentUser,
        ),
      ),
    );
  }

  Widget _displayText() {
    Widget retVal;

    if (_pickingUser != null) {
      if (_groupModel.nextBookId == "waiting") {
        if (_pickingUser.uid == _currentUser.uid) {
          retVal = Container(
            width: double.maxFinite,
            height: 50,
            child: FlatButton(
              onPressed: () => _goToAddBook(context),
              color: Colors.white,
              child: Text(
                'Select Next Book',
                style: TextStyle(
                    color: secondaryColor, fontSize: 16, fontFamily: "Roboto"),
              ),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(0),
                  topLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
            ),
          );
        }
      } else {
        retVal = Column(
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Next Book is:",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Lato",
                  color: secondaryColor,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                (_nextBook != null)
                    ? _nextBook.name
                    : CircularProgressIndicator(),
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.blue,
                  fontFamily: "Roboto",
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: Text(
                (_nextBook != null)
                    ? "- " + _nextBook.author
                    : CircularProgressIndicator(),
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  fontFamily: "Roboto",
                ),
              ),
            ),
          ],
        );
      }
    } else {
      retVal = Text("loading..");
    }

    return retVal;
  }

  @override
  Widget build(BuildContext context) {
    return _pickingUser.uid != _currentUser.uid
        ? _groupModel.nextBookId != "waiting"
            ? ShadowContainer(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: _displayText(),
                ),
              )
            : Container()
        : ShadowContainer(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: _displayText(),
            ),
          );
  }
}
