import 'package:flutter/material.dart';

import 'Screens/LoginPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Map<int, Color> color =
    {
      50:Color.fromRGBO(52,86,166, .1),
      100:Color.fromRGBO(52,86,166, .2),
      200:Color.fromRGBO(52,86,166, .3),
      300:Color.fromRGBO(52,86,166, .4),
      400:Color.fromRGBO(52,86,166, .5),
      500:Color.fromRGBO(52,86,166, .6),
      600:Color.fromRGBO(52,86,166, .7),
      700:Color.fromRGBO(52,86,166, .8),
      800:Color.fromRGBO(52,86,166, .9),
      900:Color.fromRGBO(52,86,166, 1),
    };
    MaterialColor colorCustom = MaterialColor(0xFF3456A6, color);
    return MaterialApp(
      title: 'MuraTech',
      theme: ThemeData(
        primarySwatch: colorCustom,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
    );
  }
}


