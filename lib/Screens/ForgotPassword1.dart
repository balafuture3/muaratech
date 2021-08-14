
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:muratech/Screens/LoginPage.dart';
import 'package:xml/xml.dart' as xml;
import '../String_Values.dart';
import 'ForgotPasswordOTPValidate.dart';
import 'OtpResposeModel.dart';

class ForgotPassword1 extends StatefulWidget {
  @override
  NewOrderState createState() => NewOrderState();
}

class NewOrderState extends State<ForgotPassword1> {
  bool loading = false;

  static int categoryid;
  static String timeupload;
  static String dateupload;
  TextEditingController useridController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  int _current = 0;
  static TextEditingController datefromcontroller = new TextEditingController();
  static TextEditingController timecontroller = new TextEditingController();
  var dropdownValue = "Mobile";
  var dropdownValue1 = "Mobile";
  var stringlist = ["Mobile", "Email",];
  TimeOfDay time;

  static ResponseModel liRes;

  Future<http.Response> OTPsave() async {
    setState(() {
      loading = true;
    });
    var envelope = '''<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <IN_MOB_LAST_RECORD xmlns="http://tempuri.org/">
      <FormID>8</FormID>
      <DocNo>${liRes.oTP}</DocNo>
      <UserID>${LoginScreenState.empID}</UserID>
      <WhsCode>${useridController.text}</WhsCode>
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

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OTPvalidate()));
        final decoded = json.decode(parsedXml.text);

        // setRegistered(li3.firstName, li3.empID,li3.homLoc);
        Fluttertoast.showToast(
            msg:"Login Success",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: String_values.primarycolor,
            textColor: Colors.white,
            fontSize: 16.0);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) =>
        //           ForgotPassword1()),
        // );

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
    print("response: ${response.statusCode}");
    print("response: ${response.body}");
    return response;
  }

  Future<Response> apicall() async {
    var url;
if(dropdownValue1=="Mobile")
    url = Uri.parse("https://mipservice.muratec-india.com/MobileAPI/SendOTP.php?type=2&type_code=+91&type_name=${mobileController.text}");
else
  url = Uri.parse("https://mipservice.muratec-india.com/MobileAPI/SendOTP.php?type=1&type_code=+91&type_name=${mobileController.text}");

    print(url);
    // print(headers);

    setState(() {
      loading = true;
    });

    var response = await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {

      liRes = ResponseModel.fromJson(jsonDecode(response.body));
      if(liRes.status==200) {
        OTPsave();

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

  int hour;
  String amrpm;

  @override
  void initState() {
    // mobileController.text="9943666032";
useridController.text=LoginScreenState.emailController.text;
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
                margin: const EdgeInsets.only(left: 24.0, right: 24.0,top: 24),
                padding: const EdgeInsets.only(
                    left: 24, right: 24, top: 6, bottom: 6),
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    border: new Border.all(color: Colors.black38)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: dropdownValue1,
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue1 = newValue;


                      });
                    },
                    items: stringlist
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
          margin: const EdgeInsets.only(left: 24.0, right: 24.0,top: 16),
          padding: const EdgeInsets.only( top: 6, bottom: 6),
          child: TextField(
            controller: useridController,
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
                  controller: mobileController,
                  keyboardType: TextInputType.emailAddress,

                  decoration: InputDecoration(

                    prefixIcon: Icon(Icons.phonelink_sharp),
                    labelText: dropdownValue1,
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
              child: Text('Submit'),
              textColor: String_values.primarycolor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              onPressed: () {

if(mobileController.text.isNotEmpty)
  apicall();
else
  Fluttertoast.showToast(
      msg:"$dropdownValue1 Cannot be Empty",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: String_values.primarycolor,
      textColor: Colors.white,
      fontSize: 16.0);

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