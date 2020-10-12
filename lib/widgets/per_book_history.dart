import 'package:turn_pages/models/book.dart';
import 'package:turn_pages/screens/review_history_screen.dart';
import 'package:turn_pages/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';

class PerBookHistory extends StatelessWidget {
  final BookModel book;
  final String groupId;
  final Color primaryColor = Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen = Color(0xff25bcbb);

  void _goToReviewHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewHistoryScreen(
          groupId: groupId,
          bookId: book.id,
        ),
      ),
    );
  }

  PerBookHistory({this.book, this.groupId});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
          child: ShadowContainer(
        child: Column(
          children: [
            Text(
              book.name,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: "Lato",
                color: secondaryColor
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: Text(
                "- "+book.author,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  fontFamily: "Lato",
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
                elevation: 0,
                minWidth: double.maxFinite,
                height: 50,
                onPressed: () => _goToReviewHistory(context),
                color: Colors.blue,
                child: Text('Reviews',
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
    );
  }
}
