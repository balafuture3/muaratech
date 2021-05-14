import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:muratech/Screens/MapScreen.dart';
import 'package:muratech/Screens/ViewAttendence.dart';
import 'package:muratech/String_Values.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginPage.dart';
import 'LoginPage.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key, this.name});
  String name;
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    print(LoginScreenState.homeLoc);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      endDrawerEnableOpenDragGesture: false, // THIS WAY IT WILL NOT OPEN
      drawer: Drawer(),
      body: SingleChildScrollView(
        child: Container(
          color: String_values.primarycolor,
          child: SafeArea(
            child: Container(
              color: Colors.white,
              height: height,
              width: width,
              child: Stack(
                children: [
                  Container(
                      height: height / 2.5,
                      decoration: BoxDecoration(
                          color: String_values.primarycolor,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20)))),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [


                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "Dashboard",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16),
                                ),
                              ),
                              IconButton(icon: Icon(Icons.logout,color: Colors.white,), onPressed:() async {
                                LoginScreenState.emailController.text="";
                                LoginScreenState.passwordController.text="";
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                await prefs.setString('Username', "");
                                await prefs.setInt('EmpId', 0);
                                await prefs.setBool('seen', false);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                      (Route<dynamic> route) => false,
                                );

                              } ),

                            ],
                          ),
                          color: String_values.primarycolor,
                        ),
                        SizedBox(
                          height: height / 60,
                        ),
                        Container(
                          width: width,
                          height: height/15,

                          decoration: BoxDecoration(
color: Colors.white,
                            image: DecorationImage(image: AssetImage("logo.png")),


                          ),
                        ),
              Container(
                padding: EdgeInsets.all(10),
                width: width,
                        color: Colors.white,
                        child:
                        Text("Welcome ${widget.name}",style: TextStyle(color: String_values.primarycolor,fontWeight: FontWeight.w700),),),

                        SizedBox(
                          height: height / 15,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left:16.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       Text(
                        //         "Indus ",
                        //         style: TextStyle(
                        //           fontSize: 16.0,
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.white,
                        //         ),),
                        //       Text(
                        //         "Nova ",
                        //         style: TextStyle(
                        //           fontSize: 16.0,
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.black,
                        //         ),),
                        //       Text(
                        //         "Packaging",
                        //         style: TextStyle(
                        //           fontSize: 16.0,
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.white,
                        //         ),),
                        //     ],),
                        // ),
                        SizedBox(
                          height: height / 60,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            height: height-height/3,
                            width: width,
                            child: GridView.count(
                              crossAxisSpacing: width / 40,
                              mainAxisSpacing: height / 60,
                              crossAxisCount: 2,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MapScreen()),
                                    );
                                  },
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10.0)),
                                      elevation: 8,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Image.asset("attendence.png",
                                              height: height / 8,
                                              width: double.infinity),
                                          SizedBox(
                                            height: height / 40,
                                          ),
                                          Container(
                                              padding: EdgeInsets.all(3),
                                              width: double.infinity,

                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Attendance",
                                                    style: TextStyle(
                                                        color: String_values.primarycolor,fontWeight: FontWeight.w700),
                                                  ),
                                                ],
                                              ))
                                        ],
                                      )),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewAttendence()),
                                    );
                                  },
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10.0)),
                                      elevation: 8,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Image.asset("viewattendence.png",
                                              height: height / 8,
                                              width: double.infinity),
                                          SizedBox(
                                            height: height / 40,
                                          ),
                                          Container(
                                              padding: EdgeInsets.all(3),
                                              width: double.infinity,

                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "View Attendance",
                                                    style: TextStyle(
                                                        color: String_values.primarycolor,fontWeight: FontWeight.w700),
                                                  ),
                                                ],
                                              ))
                                        ],
                                      )),
                                ),
                                // GestureDetector(
                                //   onTap: () {
                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) => Picking()),
                                //     );
                                //   },
                                //   child: Card(
                                //       elevation: 8,
                                //       shape: RoundedRectangleBorder(
                                //           borderRadius:
                                //           BorderRadius.circular(10.0)),
                                //       child: Column(
                                //         mainAxisAlignment:
                                //         MainAxisAlignment.center,
                                //         children: [
                                //           Image.asset("picking.jpg",
                                //               height: height / 8,
                                //               width: double.infinity),
                                //           SizedBox(
                                //             height: height / 40,
                                //           ),
                                //           Container(
                                //               padding: EdgeInsets.all(3),
                                //               width: double.infinity,
                                //               color: Colors.teal,
                                //               child: Text(
                                //                 "Box Pick List",
                                //                 style: TextStyle(
                                //                     color: Colors.white),
                                //               ))
                                //         ],
                                //       )),
                                // ),
                                // GestureDetector(
                                //   onTap: () {
                                //     Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //             builder: (context) =>
                                //                 GatePassMismatch()));
                                //   },
                                //   child: Card(
                                //       elevation: 8,
                                //       shape: RoundedRectangleBorder(
                                //           borderRadius:
                                //           BorderRadius.circular(10.0)),
                                //       child: Column(
                                //         mainAxisAlignment:
                                //         MainAxisAlignment.center,
                                //         children: [
                                //           Image.asset("mismatch.jpeg",
                                //               height: height / 8,
                                //               width: double.infinity),
                                //           SizedBox(
                                //             height: height / 40,
                                //           ),
                                //           Container(
                                //               padding: EdgeInsets.all(3),
                                //               width: double.infinity,
                                //               color: String_values.primarycolor,
                                //               child: Text(
                                //                 "Dispatch Scanning",
                                //                 style: TextStyle(
                                //                     color: Colors.white),
                                //               ))
                                //         ],
                                //       )),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
