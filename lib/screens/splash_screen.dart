import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color(0xff18203d);
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Text("loading.."),
      ),
    );
  }
}
