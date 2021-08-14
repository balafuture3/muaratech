import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:muratech/Models/LoginModel.dart';
import 'package:muratech/Screens/ForgotPassword1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart'as http;

import '../String_Values.dart';
import 'DashBoard.dart';



class LoginScreen extends StatefulWidget {

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  static LoginModel li3;

  static var empID;
  static String homeLoc;

  Future<bool> setRegistered(username, empid,homloc) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('Username', username);
    await prefs.setInt('EmpId', empid);
    await prefs.setString("homeLoc", homloc);
    await prefs.setBool('seen', true);
    return true;
  }

  // LoginResponseList li;

  Future<http.Response> postRequest() async {
    setState(() {
      loading = true;
    });
    var envelope = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <IN_MOB_LOGIN xmlns="http://tempuri.org/">
      <UserName>${emailController.text}</UserName>
      <UserPassword>${passwordController.text}</UserPassword>
    </IN_MOB_LOGIN>
  </soap:Body>
</soap:Envelope>''';
    print(envelope);
    var url =
        'http://15.206.119.30:2021/Muratech/Service.asmx?op=IN_MOB_LOGIN';
    // Map data = {
    //   "username": EmailController.text,
    //   "password": PasswordController.text
    // };
//    print("data: ${data}");
//    print(String_values.base_url);

    var response = await http.post(url,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
        },
        body: envelope);
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });

      xml.XmlDocument parsedXml = xml.XmlDocument.parse(response.body);
      print(parsedXml.text);
      if (parsedXml.text != "[]")
      {


        final decoded = json.decode(parsedXml.text);

        li3 = LoginModel.fromJson(decoded[0]);
        print(li3.firstName);
        empID= li3.empID;
        homeLoc=li3.homLoc;
        setRegistered(li3.firstName, li3.empID,li3.homLoc);
        Fluttertoast.showToast(
            msg:"Login Success",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: String_values.primarycolor,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Dashboard(name: li3.firstName,)),
        );

      } else
        Fluttertoast.showToast(
            msg: "Please check your login details,No users found",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: String_values.primarycolor,
            textColor: Colors.white,
            fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Http error!, Response code ${response.statusCode}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: String_values.primarycolor,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        loading = false;
      });
      print("Retry");
    }
    // print("response: ${response.statusCode}");
    // print("response: ${response.body}");
    return response;
  }

  Future<http.Response> UserFindRequest() async {
    setState(() {
      loading = true;
    });
    var envelope = '''<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <IN_MOB_LAST_RECORD xmlns="http://tempuri.org/">
      <FormID>7</FormID>
      <DocNo>0</DocNo>
      <UserID>0</UserID>
      <WhsCode></WhsCode>
      <Other>${emailController.text}</Other>
    </IN_MOB_LAST_RECORD>
  </soap:Body>
</soap:Envelope>''';
    print(envelope);
    var url =
        'http://15.206.119.30:2021/Muratech/Service.asmx?op=IN_MOB_LAST_RECORD';
    // Map data = {
    //   "username": EmailController.text,
    //   "password": PasswordController.text
    // };
//    print("data: ${data}");
//    print(String_values.base_url);

    var response = await http.post(url,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
        },
        body: envelope);
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });

      xml.XmlDocument parsedXml = xml.XmlDocument.parse(response.body);
      print(parsedXml.text);
      if (parsedXml.text != "[]")
      {


        final decoded = json.decode(parsedXml.text);

        li3 = LoginModel.fromJson(decoded[0]);
        print(li3.firstName);
        empID= li3.empID;
        homeLoc=li3.homLoc;
        // setRegistered(li3.firstName, li3.empID,li3.homLoc);
        // Fluttertoast.showToast(
        //     msg:"Login Success",
        //     toastLength: Toast.LENGTH_LONG,
        //     gravity: ToastGravity.SNACKBAR,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: String_values.primarycolor,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ForgotPassword1()),
        );

      } else
        Fluttertoast.showToast(
            msg: "No users found",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: String_values.primarycolor,
            textColor: Colors.white,
            fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Http error!, Response code ${response.statusCode}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: String_values.primarycolor,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        loading = false;
      });
      print("Retry");
    }
    // print("response: ${response.statusCode}");
    // print("response: ${response.body}");
    return response;
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
  var loading=false;

  var _isHidden=true;

  String errortextemail;
  String errortextpass;

  bool validateE = false;

  bool validateP = false;
  static TextEditingController emailController = new TextEditingController();
  static TextEditingController passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context)
  {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        // padding: const EdgeInsets.all(8.0),

        child: Container(

          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Container(
                decoration: BoxDecoration(

                  boxShadow: [BoxShadow(color:String_values.primarycolor ,blurRadius: 10)],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(bottomLeft:Radius.circular(width/3),bottomRight:  Radius.circular(width/3)),
                  // border: Border.all(width: 15,color: Colors.green,style: BorderStyle.solid)
                ),
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height / 40,
                    ),
                    Image.asset('logo.png',height: height/3,width: width,scale: 0.8,),


                  ],
                ),
              ),
              SizedBox(
                height: height / 60,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("Login",style: TextStyle(color: String_values.primarycolor,fontWeight: FontWeight.w800),),
                        ),
                        onTap: () {
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) =>
                          //           ForgotPasswordPage()),
                          // );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: height / 40,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24),
                child: buildTextField("User ID"),
              ),
              SizedBox(
                height: height / 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24),
                child: TextField(
                  obscureText: _isHidden,
                  controller: passwordController,
                  onTap: () {
                    setState(() {
                      errortextpass = null;
                    });
                  },
                  decoration: InputDecoration(

                    suffixIcon: IconButton(
                      onPressed: _toggleVisibility,
                      icon: _isHidden
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                    ),
                    prefixIcon: Icon(Icons.lock),
                    errorText: validateP ? errortextpass : null,
                    labelText: 'Password',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height / 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("Forgot Password?",style: TextStyle(color: String_values.primarycolor),),
                      ),
                      onTap: () {
                        if(emailController.text.isEmpty)
                        showDialog(
                            context: (context),
                            builder:
                                (BuildContext context) {
                              return AlertDialog(
                                title: Text("Warning"),
                                content:
                                SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text("Enter the User ID"),
                                    ],
                                  ),
                                ),
                                actions: [
                                  InkWell(child: TextButton( onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("OK"),))
                                ],
                              );
                            });
                        else
                          UserFindRequest();

                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height / 25,
              ),

              ButtonContainer(),
              // buildButtonContainer(),

              SizedBox(
                height: height /10,
              ),
Text("Version : V1.0.0")
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(

        child:Icon(Icons.login,color: Colors.white,),
        onPressed: (){
          setState(() {
            if (emailController.text.trim().isNotEmpty) {
              validateE = false;
            } else {
              validateE = true;
              errortextemail = "Email cannot be empty";
            }
            if (passwordController.text.isEmpty) {
              if (passwordController.text.isEmpty)
                errortextpass = "Password cannot be empty";
              else
                errortextpass = "Password should be minimum of 6 characters";
              validateP = true;
            } else
              validateP = false;

            if (validateE == false && validateP == false)
              check().then((value) async {
                if (value) {
                  setState(() {
                    loading = true;
                  });
                  postRequest();


                }
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) =>
                //           Page1()),
                // );
                else
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("No Internet Connection"),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
              });
          });

          //  Navigator.push(context, MaterialPageRoute(builder: (context) => SecondRoute extends StatelessWidget());
        },
      ),
    );
  }

  Widget buildTextField(String hintText) {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      onTap: () {
        setState(() {
          errortextemail = null;
        });
      },
      decoration: InputDecoration(
        errorText: validateE ? errortextemail : null,
        prefixIcon: Icon(Icons.phonelink_sharp),
        labelText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        suffixIcon: hintText == "Password"
            ? IconButton(
          onPressed: _toggleVisibility,
          icon: _isHidden
              ? Icon(Icons.visibility_off)
              : Icon(Icons.visibility),
        )
            : null,
      ),
      obscureText: hintText == "Password" ? _isHidden : false,
    );
  }

  Widget ButtonContainer() {
    return Container(
        decoration: BoxDecoration(

          boxShadow: [BoxShadow(color:String_values.primarycolor ,blurRadius: 10)],
          color: Colors.white,
          borderRadius: BorderRadius.all( Radius.circular(MediaQuery.of(context).size.width)),
          // border: Border.all(width: 15,color: String_values.primarycolor,style: BorderStyle.solid)
        ),
        width: MediaQuery.of(context).size.width / 1.8,
        height: 50,
        child: FlatButton(
          child: Text('Login'),
          textColor: String_values.primarycolor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          onPressed: () {
            setState(() {
              if (emailController.text.trim().isNotEmpty) {
                validateE = false;
              } else {
                validateE = true;
                errortextemail = "Email cannot be empty";
              }
              if (passwordController.text.isEmpty) {
                if (passwordController.text.isEmpty)
                  errortextpass = "Password cannot be empty";
                else
                  errortextpass = "Password should be minimum of 6 characters";
                validateP = true;
              } else
                validateP = false;

              if (validateE == false && validateP == false)
                check().then((value) async {
                  if (value) {
                    setState(() {
                      loading = true;
                    });
                    postRequest();


                  }
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) =>
                  //           Page1()),
                  // );
                  else
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("No Internet Connection"),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                });
            });

            //  Navigator.push(context, MaterialPageRoute(builder: (context) => SecondRoute extends StatelessWidget());
          },
        ));
  }

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}





