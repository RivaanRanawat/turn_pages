import 'package:turn_pages/models/reviewModel.dart';
import 'package:turn_pages/models/userModel.dart';
import 'package:turn_pages/services/dbFuture.dart';
import 'package:turn_pages/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';

class PerReviewHistory extends StatefulWidget {
  final ReviewModel review;

  PerReviewHistory({this.review});

  @override
  _PerReviewHistoryState createState() => _PerReviewHistoryState();
}

class _PerReviewHistoryState extends State<PerReviewHistory> {
  UserModel user;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    user = await DBFuture().getUser(widget.review.userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
          child: ShadowContainer(
        child: Column(
          children: [
            Text(
              (user != null) ? "Review by "+user.fullName : "loading...",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: "Lato",
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Rating: " + widget.review.rating.toString(),
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontFamily: "Lato",
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            (widget.review.review != null)
                ? Text(
                    widget.review.review,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                    ),
                  )
                : Center(
                    child: Column(
                      children: [
                        Image.network(
                          "http://clipart-library.com/img/991801.png",
                        ),
                        Text(
                          "No one has  completed the book yet!",
                          style: TextStyle(
                            fontFamily: "Lato",
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
