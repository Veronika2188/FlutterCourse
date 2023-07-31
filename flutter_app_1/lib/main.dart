import 'package:flutter/material.dart';
import 'package:flutter_app_1/pages/home.dart';
import 'package:flutter_app_1/pages/mainscreen.dart';

import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  theme: ThemeData(
    primaryColor: Colors.blueGrey,
  ),
  initialRoute: '/',
  routes: {
    '/': (context) => MainScreen(),
    '/todo': (context) => Home(),
  },
));