import 'dart:async';

import 'package:turn_pages/models/authModel.dart';
import 'package:turn_pages/models/book.dart';
import 'package:turn_pages/models/groupModel.dart';
import 'package:turn_pages/models/userModel.dart';
import 'package:turn_pages/screens/add_book_screen.dart';
import 'package:turn_pages/screens/review_screen.dart';
import 'package:turn_pages/services/dbFuture.dart';
import 'package:turn_pages/utils/time_left.dart';
import 'package:turn_pages/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopCard extends StatefulWidget {
  @override
  _TopCardState createState() => _TopCardState();
}

class _TopCardState extends State<TopCard> {
  final Color secondaryColor = Color(0xff232c51);
  String _timeUntil = "loading...";
  AuthModel _authModel;
  bool _doneWithBook = true;
  Timer _timer;
  BookModel _currentBook;
  GroupModel _groupModel;

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (this.mounted) {
        setState(() {
          _timeUntil = TimeLeft().timeLeft(_groupModel.currentBookDue.toDate());
        });
      }
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _authModel = Provider.of<AuthModel>(context);
    _groupModel = Provider.of<GroupModel>(context);
    if (_groupModel != null) {
      isUserDoneWithBook();
      _currentBook = await DBFuture()
          .getCurrentBook(_groupModel.id, _groupModel.currentBookId);
      _startTimer();
    }
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  isUserDoneWithBook() async {
    if (await DBFuture().isUserCompletedBook(
        _groupModel.id, _groupModel.currentBookId, _authModel.uid)) {
      _doneWithBook = true;
    } else {
      _doneWithBook = false;
    }
  }

  void _goToReview() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewScreen(
          groupModel: _groupModel,
        ),
      ),
    );
  }

  void _goToAddBook(BuildContext context) {
    UserModel _currentUser = Provider.of<UserModel>(context, listen: false);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddBookScreen(
          onGroupCreation: false,
          onError: true,
          currentUser: _currentUser,
        ),
      ),
    );
  }

  Widget noNextBook() {
    if (_authModel != null && _groupModel != null) {
      if (_groupModel.currentBookId == "waiting") {
        if (_authModel.uid == _groupModel.leader) {
          return Column(
            children: <Widget>[
              Text(
                "Nobody picked the next book. Leader is yet to pick!",
                style: TextStyle(fontSize: 20, fontFamily: "Lato"),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                elevation: 0,
                minWidth: double.maxFinite,
                height: 50,
                onPressed: () => _goToAddBook(context),
                color: Colors.red,
                child: Text('Pick Next Book',
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
          );
        } else {
          return Center(
            child: Text(
              "Nobody picked the next book. Leader is yet to pick!",
              style: TextStyle(fontSize: 20, fontFamily: "Lato"),
            ),
          );
        }
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentBook == null) {
      return ShadowContainer(child: noNextBook());
    }
    return ShadowContainer(
      child: Column(
        children: <Widget>[
          Text(
            _currentBook.name,
            style: TextStyle(
              fontSize: 30,
              color: Colors.blue,
              fontFamily: "Roboto",
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: Text(
              "- " + _currentBook.author,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              children: <Widget>[
                Text(
                  "Due In: ",
                  style: TextStyle(
                    fontSize: 30,
                    color: secondaryColor,
                    fontFamily: "Lato",
                  ),
                ),
                Expanded(
                  child: Text(
                    _timeUntil ?? CircularProgressIndicator(),
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: secondaryColor,
                      fontFamily: "Lato",
                    ),
                  ),
                ),
              ],
            ),
          ),
          _doneWithBook
              ? Center(
                  child: Text(
                    "Already Finished!",
                    style: TextStyle(fontWeight: FontWeight.bold ,fontFamily: "Lato", fontSize: 16),
                  ),
                )
              : MaterialButton(
                  elevation: 0,
                  height: 50,
                  minWidth: double.maxFinite,
                  onPressed: _doneWithBook ? null : _goToReview,
                  color: Colors.green[400],
                  child: Text(
                    'Finished Book',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "Roboto"),
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
        ],
      ),
    );
  }
}
