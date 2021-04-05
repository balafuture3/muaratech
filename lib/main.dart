import 'package:flutter/material.dart';
import 'package:muratech/Screens/DashBoard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/LoginPage.dart';

void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static bool _seen = false;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    Future<bool> checkFirstSeen() async {
      WidgetsFlutterBinding.ensureInitialized();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _seen = (prefs.getBool('seen') ?? false);
      if (_seen) {
        LoginScreenState.emailController.text = prefs.getString("Username");
        LoginScreenState.li3.empID = prefs.getInt("EmpId");

        print('Open sequence: Not First Time');
        print(LoginScreenState.emailController.text);
        print(LoginScreenState.li3.empID);
      } else {
        // Set the flag to true at the end of onboarding screen if everything is successfull and so I am commenting it out
        // await prefs.setBool('seen', true);
        print('Open sequence: First Time');
      }
      return _seen;
    }
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
      home:Landing());

  }
}
class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  bool _seen=false;


  Future<bool> checkFirstSeen() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _seen = (prefs.getBool('seen') ?? false);
    if (_seen) {
      print('Open sequence: Not First Time');
      LoginScreenState.emailController.text = prefs.getString("Username");
      LoginScreenState.empID = prefs.getInt("EmpId");


      print(LoginScreenState.emailController.text);
      // print(LoginScreenState.li3.empID);
    } else {
      // Set the flag to true at the end of onboarding screen if everything is successfull and so I am commenting it out
      // await prefs.setBool('seen', true);
      print('Open sequence: First Time');
    }
    return _seen;
  }
  @override
  void initState() {
   Future.delayed(Duration(seconds: 2)).then((value) =>  checkFirstSeen().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>_seen==true?Dashboard(name: LoginScreenState.emailController.text,):LoginScreen()), (route) => false)));
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("logo.png"),
            SizedBox(height: MediaQuery.of(context).size.height/20,),
            CircularProgressIndicator(),
          ],
        )));
  }
}



