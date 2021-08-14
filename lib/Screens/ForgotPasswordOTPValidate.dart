
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:muratech/Models/UpdateModel.dart';
import 'package:muratech/Screens/LoginPage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../String_Values.dart';
import 'package:xml/xml.dart' as xml;

class OTPvalidate extends StatefulWidget {
  @override
  OTPvalidateState createState() => OTPvalidateState();
}

class OTPvalidateState extends State<OTPvalidate> {
  bool loading = false;

  static int categoryid;
  static String timeupload;
  static String dateupload;
  TextEditingController emailController = new TextEditingController();
  TextEditingController OTPController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  int _current = 0;
  static TextEditingController datefromcontroller = new TextEditingController();
  static TextEditingController timecontroller = new TextEditingController();
  var dropdownValue = "Mobile";
  var dropdownValue1 = "Mobile";
  var stringlist = ["Mobile", "Email",];
  TimeOfDay time;

  int hour;
  String amrpm;

  UpdateModel liRes;
  Future<Response> Update() async {
    var url;

      url = Uri.parse("http://mipservice.muratec-india.com:6732/MobileAPI/updatepassword.php?empID=${LoginScreenState.empID}&password=${passwordController.text}");

    print(url);
    // print(headers);

    setState(() {
      loading = true;
    });

    var response = await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {

      liRes = UpdateModel.fromJson(jsonDecode(response.body));
      if(liRes.status==200)
      {
        Fluttertoast.showToast(msg: liRes.message);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>LoginScreen()), (Route<dynamic> route) => false);

      }
      else
        Fluttertoast.showToast(msg: liRes.message);

      // print(liZip
      //     .details[0].zIPCODE);
      // .cookie.split(';')[0]}");
    }
    setState(() {
      loading = false;
    });
    return response;
  }
  Future<http.Response> OTPValidate() async {
    setState(() {
      loading = true;
    });
    var envelope = '''<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <IN_MOB_LAST_RECORD xmlns="http://tempuri.org/">
      <FormID>9</FormID>
      <DocNo>${OTPController.text}</DocNo>
      <UserID>${LoginScreenState.empID}</UserID>
      <WhsCode>${LoginScreenState.emailController.text}</WhsCode>
      <Other></Other>
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
        Update();

        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => OTPvalidate()));
        final decoded = json.decode(parsedXml.text);

        // setRegistered(li3.firstName, li3.empID,li3.homLoc);
        // Fluttertoast.showToast(
        //     msg:"Login Success",
        //     toastLength: Toast.LENGTH_LONG,
        //     gravity: ToastGravity.SNACKBAR,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: String_values.primarycolor,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) =>
        //           ForgotPassword1()),
        // );

      } else
        Fluttertoast.showToast(
            msg: "Invalid OTP",
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
    print("response: ${response.statusCode}");
    print("response: ${response.body}");
    return response;
  }
  @override
  void initState() {
    emailController.text=LoginScreenState.emailController.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    final height = MediaQuery
        .of(context)
        .size
        .height;

    final List<String> imgList = [
      "https://www.shreeanandhaas.com/images/special-menu/2-in-1-Idiyappam.jpg",
      "https://www.shreeanandhaas.com/images/special-menu/Garlic-Kesari.jpg",
      "https://www.shreeanandhaas.com/images/special-menu/Wheat-Rava-Idly.jpg",
      "https://www.shreeanandhaas.com/images/special-menu/Podi-Idly.jpg",
      "https://www.shreeanandhaas.com/images/special-menu/Diet-Breakfast.jpg",
    ];


    return Scaffold(
      body: loading?Center(child: CircularProgressIndicator()):SingleChildScrollView(
          child: Column(children: [

            // Padding(
            //   padding: const EdgeInsets.all(16),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       Text("Select Category"),
            //     ],
            //   ),
            // ),
            Container(
              margin: const EdgeInsets.only(left: 24.0, right: 24.0,top: 16),
              padding: const EdgeInsets.only( top: 6, bottom: 6),
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: false,
                decoration: InputDecoration(

                  prefixIcon: Icon(Icons.phonelink_sharp),
                  labelText: "User ID",
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
            Container(
              margin: const EdgeInsets.only(left: 24.0, right: 24.0,top: 16),
              padding: const EdgeInsets.only( top: 6, bottom: 6),
              child: TextField(
                controller: OTPController,
                keyboardType: TextInputType.emailAddress,

                decoration: InputDecoration(

                  prefixIcon: Icon(Icons.lock),
                  labelText: "Enter OTP",
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
            Container(
              margin: const EdgeInsets.only(left: 24.0, right: 24.0,top: 16),
              padding: const EdgeInsets.only( top: 6, bottom: 6),
              child: TextField(
                controller: passwordController,
                keyboardType: TextInputType.emailAddress,
                enabled: true,
                decoration: InputDecoration(

                  prefixIcon: Icon(Icons.lock),
                  labelText: "Enter New Password",
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

            Container(
                margin: EdgeInsets.only(top: 16),
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color:String_values.primarycolor ,blurRadius: 10)],
                  color: Colors.white,
                  borderRadius: BorderRadius.all( Radius.circular(MediaQuery.of(context).size.width)),
                  // border: Border.all(width: 15,color: String_values.primarycolor,style: BorderStyle.solid)
                ),
                width: MediaQuery.of(context).size.width / 1.8,
                height: 50,
                child: FlatButton(
                  child: Text('Update'),
                  textColor: String_values.primarycolor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  onPressed: () {
                    OTPValidate();



                    //  Navigator.push(context, MaterialPageRoute(builder: (context) => SecondRoute extends StatelessWidget());
                  },
                ))
            // Container(
            //   margin: const EdgeInsets.only(left: 24.0, right: 24.0),
            //   padding: const EdgeInsets.only(left: 20.0, right: 10.0),
            //   decoration: new BoxDecoration(
            //       borderRadius: BorderRadius.all(Radius.circular(2.0)),
            //       border: new Border.all(color: Colors.black38)),
            //   child: DropdownButtonHideUnderline(
            //     child: DropdownButton<String>(
            //       isExpanded: true,
            //       value: dropdownValue,
            //       onChanged: (String newValue) {
            //         setState(() {
            //           dropdownValue = newValue;
            //           dropdownValue1="Select";
            //           if(dropdownValue=="Breakfast")
            //           stringlist=["Select","7 AM","8 AM","9 AM"];
            //           else if(dropdownValue=="Lunch")
            //             stringlist=["Select","12 PM","1 PM","2 PM"];
            //           else if(dropdownValue=="Dinner")
            //             stringlist=["Select","7 PM","8 PM","9 PM"];
            //         });
            //       },
            //       items: <String>[
            //         'Select',
            //         "Breakfast",
            //         "Lunch",
            //         "Dinner",
            //       ].map<DropdownMenuItem<String>>((String value) {
            //         return DropdownMenuItem<String>(
            //           value: value,
            //           child: Text(value),
            //         );
            //       }).toList(),
            //     ),
            //   ),
            // ),


          ])),
      appBar: AppBar(
          title: Text(
            "Forgot Password",
            style: TextStyle(fontWeight: FontWeight.w700),
          )),
    );
  }
}