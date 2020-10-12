import 'package:turn_pages/models/book.dart';
import 'package:turn_pages/services/dbFuture.dart';
import 'package:flutter/material.dart';
import 'package:turn_pages/widgets/per_book_history.dart';


class BookHistoryScreen extends StatefulWidget {
  final String groupId;

  BookHistoryScreen({
    this.groupId,
  });
  @override
  _BookHistoryScreenState createState() => _BookHistoryScreenState();
}

class _BookHistoryScreenState extends State<BookHistoryScreen> {
  final Color primaryColor = Color(0xff18203d);
  final Color secondaryColor = Color(0xff232c51);
  final Color logoGreen = Color(0xff25bcbb);
  Future<List<BookModel>> books;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    books = DBFuture().getBookHistory(widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: FutureBuilder(
        future: books,
        builder: (BuildContext context, AsyncSnapshot<List<BookModel>> snapshot) {
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
                    child: PerBookHistory(
                      book: snapshot.data[index - 1],
                      groupId: widget.groupId,
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
