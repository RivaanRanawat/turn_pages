import 'package:turn_pages/models/reviewModel.dart';
import 'package:turn_pages/services/dbFuture.dart';
import 'package:flutter/material.dart';
import 'package:turn_pages/widgets/per_review_history.dart';

class ReviewHistoryScreen extends StatefulWidget {
  final String groupId;
  final String bookId;

  ReviewHistoryScreen({this.groupId, this.bookId});

  @override
  _ReviewHistoryScreenState createState() => _ReviewHistoryScreenState();
}

class _ReviewHistoryScreenState extends State<ReviewHistoryScreen> {
  final Color primaryColor = Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen = Color(0xff25bcbb);
  Future<List<ReviewModel>> reviews;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    reviews = DBFuture().getReviewHistory(widget.groupId, widget.bookId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: FutureBuilder(
        future: reviews,
        builder:
            (BuildContext context, AsyncSnapshot<List<ReviewModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        BackButton(),
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: PerReviewHistory(
                      review: snapshot.data[index - 1],
                    ),
                  );
                }
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
