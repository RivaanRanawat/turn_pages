import 'package:turn_pages/root/root_file.dart';
import 'package:turn_pages/services/auth.dart';
import 'package:turn_pages/utils/our_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/authModel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AuthModel>.value(
      value: Auth().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: OurTheme().buildTheme(),
        home: OurRoot(),
      ),
    );
  }
}
