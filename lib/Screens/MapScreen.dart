import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geocoding_platform_interface/src/models/location.dart';
import 'package:geocoding_platform_interface/src/models/placemark.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as locate;
import 'package:muratech/Models/CheckValidationModel.dart';
import 'package:muratech/Models/CustomerOfficeModel.dart';
import 'package:muratech/Models/SuccessModel.dart';
import 'package:muratech/Screens/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xml/xml.dart' as xml;

import '../String_Values.dart';
import 'LoginPage.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key key, this.username});
  String username;
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  List<Marker> listmarker = new List();
  var stringlist = ["Select Type", "Office", "Customer"];
  var dropdownValue1 = "Select Type";

  static CustomerOfficeList li3;

  var enableStartTravel = true;

  String cardcode;

  SuccessResponse li4;

  var enableEndTravel = true;

  var enableWorkStart = true;

  var enableWorkEnd = true;

  Timer timer;

  double currlat;

  double currlon;

  CheckValidationModel li5;

  bool enableTypeahead = true;

  bool enableDropdown = true;

  var visibletravel = true;

  Future<http.Response> CheckValidation() async {
    setState(() {
      loading = true;
    });
    var envelope = '''<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
  <soap12:Body>
    <IN_MOB_VALIDATIONNEW xmlns="http://tempuri.org/">
      <UserID>${LoginScreenState.empID}</UserID>
    </IN_MOB_VALIDATIONNEW>
  </soap12:Body>
</soap12:Envelope>''';
    print(envelope);
    var url =
        'http://15.206.119.30:2021/Muratech/Service.asmx?op=IN_MOB_VALIDATIONNEW';
    // Map data = {
    //   "username": EmailController.text,
    //   "password": PasswordController.text
    // };
//    print("data: ${data}");
//    print(String_values.base_url);
    print(url);
    var response = await http.post(url,
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
        },
        body: envelope);
    if (response.statusCode == 200) {
      setStatus(true, false, false, false);
      setState(() {
        loading = false;
      });

      xml.XmlDocument parsedXml = xml.XmlDocument.parse(response.body);
      print(parsedXml.text);
      if (parsedXml.text != "[]") {
        final decoded = json.decode(parsedXml.text);
        li5 = CheckValidationModel.fromJson(decoded[0]);
        print(li5.cUSNAME1);
        setState(() {
          if (li5.wORKSTART == "Y" &&
              li5.wORKEND == "Y" &&
              li5.sTOPTRAVEL == "Y" &&
              li5.sTARTTRAVEL == "Y") {
          } else {
            if (li5.tYPENAME != "")
              dropdownValue1 = li5.tYPENAME;
            else
              dropdownValue1 = li5.tYPENAME1;
            if (li5.cUSNAME != "")
              _typeAheadController.text = li5.cUSNAME;
            else
              _typeAheadController.text = li5.cUSNAME1;
            if (li5.cUSCODE != "")
              cardcode = li5.cUSCODE;
            else
              cardcode = li5.cUSCODE1;
            if (li5.sTARTTRAVEL == "Y" && li5.wORKEND == "N") {
              enableTypeahead = false;
              enableDropdown = false;
            } else {
              enableTypeahead = true;
              enableDropdown = true;
            }
            li5.wORKSTART == "Y" ? enableWorkStart = false : true;
            if (li5.wORKEND == "Y") {
              enableWorkEnd = false;
              enableWorkStart = true;
            } else
              enableWorkEnd = true;
            li5.sTARTTRAVEL == "Y" ? enableStartTravel = false : true;
            li5.sTOPTRAVEL == "Y" ? enableEndTravel = false : true;

            if (li5.tYPENAME == "Office") {
              if (li5.cUSNAME != "") {
                if (li5.cUSNAME.toLowerCase() ==
                    LoginScreenState.homeLoc.toLowerCase()) {
                  setState(() {
                    visibletravel = false;
                  });
                }
              } else if (li5.cUSNAME1 != "") {
                if (li5.cUSNAME1.toLowerCase() ==
                    LoginScreenState.homeLoc.toLowerCase()) {
                  setState(() {
                    visibletravel = false;
                  });
                }
              }
            }

            if (li5.tYPENAME1 == "Office") {
              if (li5.cUSNAME != "") {
                if (li5.cUSNAME.toLowerCase() ==
                    LoginScreenState.homeLoc.toLowerCase()) {
                  setState(() {
                    visibletravel = false;
                  });
                }
              } else if (li5.cUSNAME1 != "") {
                if (li5.cUSNAME1.toLowerCase() ==
                    LoginScreenState.homeLoc.toLowerCase()) {
                  setState(() {
                    visibletravel = false;
                  });
                }
              }
            }
          }
        });

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) =>
        //           Dashboard()),
        // );

      }
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

  Future<http.Response> StartTravel() async {
    setState(() {
      loading = true;
    });
    String location;
    if (_serviceEnabled) {
      location = "";
      AddressController.text = "";
    } else
      location = currlat.toString() + ',' + currlon.toString();

    var envelope = '''<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
  <soap12:Body>
    <IN_MOB_STARTATTENDANCE xmlns="http://tempuri.org/">
      <TypeCode>${dropdownValue1}</TypeCode>
      <TypeName>${dropdownValue1}</TypeName>
      <CusCode>${cardcode}</CusCode>
      <CusName>${_typeAheadController.text}</CusName>
      <StartTravel>Y</StartTravel>
      <StartLatLang>${location}</StartLatLang>
      <StartAddress>${AddressController.text}</StartAddress>
      <Remarks>test</Remarks>
      <UserID>${LoginScreenState.empID}</UserID>
    </IN_MOB_STARTATTENDANCE>
  </soap12:Body>
</soap12:Envelope>''';
    print(envelope);
    var url =
        'http://15.206.119.30:2021/Muratech/Service.asmx?op=IN_MOB_STARTATTENDANCE';
    http: //15.206.119.30:2021/Muratech/Service.asmx?op=IN_MOB_STARTATTENDANCE
    print(url);
    // Map data = {
    //   "username": EmailController.text,
    //   "password": PasswordController.text
    // };
//    print("data: ${data}");
//    print(String_values.base_url);
//
//
// <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
//   <soap:Body>
//     <IN_MOB_STARTATTENDANCE xmlns="http://tempuri.org/">
//       <TRAVELTYPE>${dropdownValue1}</TRAVELTYPE>
//       <CUSTOMERCODE>${cardcode}</CUSTOMERCODE>
//       <CUSTOMERNAME>${_typeAheadController.text}</CUSTOMERNAME>
//       <TRAVELSTART>Y</TRAVELSTART>
//       <T_STARTDATE>${DateFormat("yyyy-MM-dd").format(DateTime.now())}</T_STARTDATE>
//       <T_STARTTIME>${DateFormat("hh:mm a").format(DateTime.now())}</T_STARTTIME>
//       <T_STARTLATLANG>${currlat.toString()+','+currlon.toString()}</T_STARTLATLANG>
//       <T_STARTADDRESS>${AddressController.text}</T_STARTADDRESS>
//       <USERID>${LoginScreenState.empID}</USERID>
//     </IN_MOB_STARTATTENDANCE>
//   </soap:Body>
// </soap:Envelope>

    var response = await http.post(url,
        headers: {
          "Content-Type": "application/soap+xml; charset=utf-8",
        },
        body: envelope);
    if (response.statusCode == 200) {
      setStatus(true, false, false, false);
      setState(() {
        loading = false;
      });

      xml.XmlDocument parsedXml = xml.XmlDocument.parse(response.body);
      print(parsedXml.text);
      if (parsedXml.text != "[]") {
        final decoded = json.decode(parsedXml.text);
        li4 = SuccessResponse.fromJson(decoded[0]);
        print(li4.sTATUSMSG);
        if (li4.sTATUS == "1") {
          setState(() {
            enableStartTravel = false;
          });

          Fluttertoast.showToast(
              msg: li4.sTATUSMSG,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: String_values.primarycolor,
              textColor: Colors.white,
              fontSize: 16.0);
        } else
          Fluttertoast.showToast(
              msg: li4.sTATUSMSG,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: String_values.primarycolor,
              textColor: Colors.white,
              fontSize: 16.0);
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) =>
        //           Dashboard()),
        // );

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
    print("response: ${response.statusCode}");
    print("response: ${response.body}");
    return response;
  }

  Future<http.Response> EndTravel() async {
    setState(() {
      loading = true;
    });
    String location;
    if (_serviceEnabled) {
      location = "";
      AddressController.text = "";
    } else
      location = currlat.toString() + ',' + currlon.toString();
    var envelope = '''<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
  <soap12:Body>
    <IN_MOB_STOPATTENDANCE xmlns="http://tempuri.org/">
      <TypeCode>${dropdownValue1}</TypeCode>
      <TypeName>${dropdownValue1}</TypeName>
      <CusCode>${cardcode}</CusCode>
      <CusName>${_typeAheadController.text}</CusName>
      <StartTravel>Y</StartTravel>
      <StartLatLang>${location}</StartLatLang>
      <StartAddress>${AddressController.text}</StartAddress>
      <Remarks>test</Remarks>
      <UserID>${LoginScreenState.empID}</UserID>
    </IN_MOB_STOPATTENDANCE>
  </soap12:Body>
</soap12:Envelope>''';
    print(envelope);
    var url =
        'http://15.206.119.30:2021/Muratech/Service.asmx?op=IN_MOB_STOPATTENDANCE';
    // Map data = {
    //   "username": EmailController.text,
    //   "password": PasswordController.text
    // };
//    print("data: ${data}");

    print(url);
    var response = await http.post(url,
        headers: {
          "Content-Type": "application/soap+xml; charset=utf-8",
        },
        body: envelope);
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });

      xml.XmlDocument parsedXml = xml.XmlDocument.parse(response.body);
      print(parsedXml.text);
      if (parsedXml.text != "[]") {
        final decoded = json.decode(parsedXml.text);
        li4 = SuccessResponse.fromJson(decoded[0]);
        print(li4.sTATUSMSG);
        if (li4.sTATUS == "1") {
          setState(() {
            dropdownValue1 = "Select Type";
            _typeAheadController.text = "";
            setStatus(false, false, false, false);
            enableStartTravel = true;
            enableWorkStart = true;
            enableWorkEnd = true;
          });

          Fluttertoast.showToast(
              msg: li4.sTATUSMSG,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: String_values.primarycolor,
              textColor: Colors.white,
              fontSize: 16.0);
        } else
          Fluttertoast.showToast(
              msg: li4.sTATUSMSG,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: String_values.primarycolor,
              textColor: Colors.white,
              fontSize: 16.0);
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) =>
        //           Dashboard()),
        // );

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
    print("response: ${response.statusCode}");
    print("response: ${response.body}");
    return response;
  }

  Future<http.Response> WorkStart() async {
    setState(() {
      loading = true;
    });
    String location;
    if (_serviceEnabled) {
      location = "";
      AddressController.text = "";
    } else
      location = currlat.toString() + ',' + currlon.toString();
    var envelope = '''<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
  <soap12:Body>
    <IN_MOB_WORKSTRATATTENDANCE xmlns="http://tempuri.org/">
      <TypeCode>${dropdownValue1}</TypeCode>
      <TypeName>${dropdownValue1}</TypeName>
      <CusCode>${cardcode}</CusCode>
      <CusName>${_typeAheadController.text}</CusName>
      <StartTravel>Y</StartTravel>
      <StartLatLang>${location}</StartLatLang>
      <StartAddress>${AddressController.text}</StartAddress>
      <Remarks>test</Remarks>
      <UserID>${LoginScreenState.empID}</UserID>
    </IN_MOB_WORKSTRATATTENDANCE>
  </soap12:Body>
</soap12:Envelope>''';
    print(envelope);
    print(envelope);
    var url =
        'http://15.206.119.30:2021/Muratech/Service.asmx?op=IN_MOB_WORKSTRATATTENDANCE';
    // Map data = {
    //   "username": EmailController.text,
    //   "password": PasswordController.text
    // };
//    print("data: ${data}");
//    print(String_values.base_url);
    print(url);
    var response = await http.post(url,
        headers: {
          "Content-Type": "application/soap+xml; charset=utf-8",
        },
        body: envelope);
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });

      xml.XmlDocument parsedXml = xml.XmlDocument.parse(response.body);
      print(parsedXml.text);
      if (parsedXml.text != "[]") {
        final decoded = json.decode(parsedXml.text);
        li4 = SuccessResponse.fromJson(decoded[0]);
        print(li4.sTATUSMSG);
        if (li4.sTATUS == "1") {
          setStatus(true, false, true, false);
          setState(() {
            enableTypeahead = false;
            enableDropdown = false;
            enableWorkStart = false;
            enableWorkEnd = true;
          });

          Fluttertoast.showToast(
              msg: li4.sTATUSMSG,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: String_values.primarycolor,
              textColor: Colors.white,
              fontSize: 16.0);
        } else
          Fluttertoast.showToast(
              msg: li4.sTATUSMSG,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: String_values.primarycolor,
              textColor: Colors.white,
              fontSize: 16.0);
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) =>
        //           Dashboard()),
        // );

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
    print("response: ${response.statusCode}");
    print("response: ${response.body}");
    return response;
  }

  Future<http.Response> WorkEnd() async {
    setState(() {
      loading = true;
    });
    String location;
    if (_serviceEnabled) {
      location = "";
      AddressController.text = "";
    } else
      location = currlat.toString() + ',' + currlon.toString();
    var envelope = '''<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
  <soap12:Body>
    <IN_MOB_WORKENDATTENDANCE xmlns="http://tempuri.org/">
      <TypeCode>${dropdownValue1}</TypeCode>
      <TypeName>${dropdownValue1}</TypeName>
      <CusCode>${cardcode}</CusCode>
      <CusName>${_typeAheadController.text}</CusName>
      <StartTravel>Y</StartTravel>
      <StartLatLang>${location}</StartLatLang>
      <StartAddress>${AddressController.text}</StartAddress>
      <Remarks>test</Remarks>
      <UserID>${LoginScreenState.empID}</UserID>
    </IN_MOB_WORKENDATTENDANCE>
  </soap12:Body>
</soap12:Envelope>
''';
    print(envelope);
    var url =
        'http://15.206.119.30:2021/Muratech/Service.asmx?op=IN_MOB_WORKENDATTENDANCE';
    print(url);
    // Map data = {
    //   "username": EmailController.text,
    //   "password": PasswordController.text
    // };
//    print("data: ${data}");
//    print(String_values.base_url);

    var response = await http.post(url,
        headers: {
          "Content-Type": "application/soap+xml; charset=utf-8",
        },
        body: envelope);
    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });

      xml.XmlDocument parsedXml = xml.XmlDocument.parse(response.body);
      print(parsedXml.text);
      if (parsedXml.text != "[]") {
        final decoded = json.decode(parsedXml.text);
        li4 = SuccessResponse.fromJson(decoded[0]);
        print(li4.sTATUSMSG);
        if (li4.sTATUS == "1" || li4.sTATUS == "2") {
          print("true");
          // setStatus(true, false, true, true);
          setState(() {
            enableTypeahead = true;
            enableDropdown = true;
            enableWorkEnd = false;
            enableWorkStart = true;
          });

          Fluttertoast.showToast(
              msg: li4.sTATUSMSG,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: String_values.primarycolor,
              textColor: Colors.white,
              fontSize: 16.0);
        } else
          Fluttertoast.showToast(
              msg: li4.sTATUSMSG,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: String_values.primarycolor,
              textColor: Colors.white,
              fontSize: 16.0);
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) =>
        //           Dashboard()),
        // );

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
    print("response: ${response.statusCode}");
    print("response: ${response.body}");
    return response;
  }

  Future<http.Response> customerListorOfficeList(formid) async {
    setState(() {
      loading = true;
    });
    var envelope = '''
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <IN_MOB_GETCUSTOMER xmlns="http://tempuri.org/">
      <FORMID>$formid</FORMID>
    </IN_MOB_GETCUSTOMER>
  </soap:Body>
</soap:Envelope>
''';
    print(envelope);
    var url =
        'http://15.206.119.30:2021/Muratech/Service.asmx?op=IN_MOB_GETCUSTOMER';
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
      final decoded = json.decode(parsedXml.text);
      li3 = CustomerOfficeList.fromJson(decoded);
      print(li3.details[0].cardName);

      // setState(() {
      //   stringlist.clear();
      //   stringlist.add("Select Category");
      //   for (int i = 0; i < li4.details.length; i++)
      //     stringlist.add(li4.details[i].categoryName);
      // });

      // if ("li2.name" != null) {
      //   Fluttertoast.showToast(
      //       msg:"",
      //       toastLength: Toast.LENGTH_LONG,
      //       gravity: ToastGravity.SNACKBAR,
      //       timeInSecForIosWeb: 1,
      //       backgroundColor: String_Values.primarycolor,
      //       textColor: Colors.white,
      //       fontSize: 16.0);
      // } else
      //   Fluttertoast.showToast(
      //       msg: "Please check your login details,No users found",
      //       toastLength: Toast.LENGTH_LONG,
      //       gravity: ToastGravity.SNACKBAR,
      //       timeInSecForIosWeb: 1,
      //       backgroundColor: String_Values.primarycolor,
      //       textColor: Colors.white,
      //       fontSize: 16.0);
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

  LatLngBounds getBounds(List<Marker> markers) {
    var lngs = markers.map<double>((m) => m.position.longitude).toList();
    var lats = markers.map<double>((m) => m.position.latitude).toList();

    double topMost = lngs.reduce(max);
    double leftMost = lats.reduce(min);
    double rightMost = lats.reduce(max);
    double bottomMost = lngs.reduce(min);

    LatLngBounds bounds = LatLngBounds(
      northeast: LatLng(rightMost, topMost),
      southwest: LatLng(leftMost, bottomMost),
    );

    return bounds;
  }

  static Future<bool> setStatus(tstart, tend, wstart, wend) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tstart', tstart);
    await prefs.setBool('tend', tend);
    await prefs.setBool('wstart', wstart);
    await prefs.setBool('wend', wstart);
    return true;
  }

  Completer<GoogleMapController> _controller = Completer();
  bool _serviceEnabled = false;
  var _kGooglePlex;
  Marker marker;
  String destinationaddress;
  String imei;
  int cnt = 0;
  Set<Marker> markers = Set();
  Position position;
  TextEditingController AddressController = new TextEditingController();
  TextEditingController _typeAheadController = new TextEditingController();
  var loading = false;
  bool textcheck = false;

  BitmapDescriptor pinLocationIcon;
  BitmapDescriptor pinLocationIcon1;
  List<Placemark> placemarks;
  locate.Location location = new locate.Location();
  List<Location> locations;

  void initState() {
// prevstatus();

    _kGooglePlex = CameraPosition(target: LatLng(0, 0), zoom: 16);

    enableTypeahead = true;
    enableDropdown = true;

    getLocationEnabled().then((value) {
      print("Service enabled${_serviceEnabled}");
      if (_serviceEnabled) {
        getlocation().then((value) {
          print("getlocation");
          if (position.latitude != null) {
            currlat = position.latitude;

            currlon = position.longitude;
            placefromLATLNG();
          }
          CheckValidation();
        });
      } else
        CheckValidation();
    });

//     location.onLocationChanged.listen((locate.LocationData currentLocation) {
// setState(() {
//   currlat=currentLocation.latitude;
//   currlon=currentLocation.longitude;
//
//   print("changed");
//
//   placefromLATLNG().then((value)
//   async {
//     GoogleMapController controller = await _controller.future;
//     setState(() {
//       controller.animateCamera(CameraUpdate.newLatLng(LatLng(currlat, currlon)));
//     });
//   });
// });
//
//
//       // Use current location
//     });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    Future<void> _launchInBrowser(String url) async {
      if (await canLaunch(url)) {
        await launch(
          url,
          forceSafariVC: false,
          forceWebView: false,
          headers: <String, String>{'my_header_key': 'my_header_value'},
        );
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Container(
                  child: Stack(
                // alignment: Alignment.bottomCenter,
                children: [
                  GoogleMap(
                    padding: EdgeInsets.only(top: height / 2),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    markers: markers,
                  ),
                  Container(
                    color: Colors.white,
                    child: ExpansionTile(
                      title: Text("Attendence"),
                      initiallyExpanded: true,
                      children: [
                        Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, bottom: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Icon(
                                          Icons.map_sharp,
                                          color: String_values.primarycolor,
                                          size: height / 10,
                                        )),
                                    Expanded(
                                        flex: 4,
                                        child: TextField(
                                          controller: AddressController,
                                          enabled: false,
                                          minLines: 2,
                                          maxLines: 25,
                                          style: TextStyle(fontSize: 12),
                                          decoration: InputDecoration(
                                            labelText: "Your Address",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                              Container(
                                height: 50,
                                margin: const EdgeInsets.only(
                                    left: 16.0, right: 16.0),
                                padding: const EdgeInsets.only(
                                    left: 24, right: 10, top: 10, bottom: 10),
                                decoration: new BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25.0)),
                                    border:
                                        new Border.all(color: Colors.black38)),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: dropdownValue1,
                                    onChanged:
                                        // enableDropdown?
                                        (String newValue) {
                                      setState(() {
                                        dropdownValue1 = newValue;
                                        _typeAheadController.text = "";
                                        if (dropdownValue1 == "Office") {
                                          customerListorOfficeList(1)
                                              .then((value) {
                                            for (int i = 0;
                                                i < li3.details.length;
                                                i++)
                                              if (li3.details[i].cardName
                                                      .toLowerCase() ==
                                                  LoginScreenState.homeLoc
                                                      .toLowerCase()) {
                                                _typeAheadController.text =
                                                    li3.details[i].cardName;

                                                cardcode =
                                                    li3.details[i].cardCode;
                                                enableStartTravel = true;
                                                enableEndTravel = true;
                                                enableWorkStart = true;
                                                enableWorkEnd = true;
                                                visibletravel = false;
                                              }
                                          });
                                        } else if (dropdownValue1 ==
                                            "Customer") {
                                          customerListorOfficeList(2);
                                          visibletravel = true;
                                        } else
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Please Choose Office or Customer");
                                      });
                                    }
                                    // : null
                                    ,
                                    items: stringlist
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              Container(
                                height: 50,
                                margin: const EdgeInsets.only(
                                    left: 16.0, right: 16.0, top: 16),
                                child: TypeAheadFormField(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    // enabled: enableTypeahead,
                                    controller: this._typeAheadController,
                                    // onTap: ()
                                    // {
                                    //   Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //           builder: (context) =>
                                    //               Category(userid:HomeState.userid,mapselection: true)));
                                    // },
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.search),
                                      labelText: dropdownValue1 == "Office"
                                          ? 'Choose Office'
                                          : dropdownValue1 == "Customer"
                                              ? 'Choose Customer'
                                              : "",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.0,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) {
                                    return BackendService.getSuggestions(
                                        pattern);
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      title: Text(suggestion),
                                    );
                                  },
                                  transitionBuilder:
                                      (context, suggestionsBox, controller) {
                                    return suggestionsBox;
                                  },
                                  onSuggestionSelected: (suggestion) {
                                    int cnt = 0;
                                    // dropdownValue1 = " Select OBD Number ";

                                    // postRequest(suggestion);
                                    for (int i = 0;
                                        i < li3.details.length;
                                        i++) {
                                      print(li3.details[i].cardName);
                                      if ("${li3.details[i].cardName}" ==
                                          suggestion) {
                                        cardcode = li3.details[i].cardCode;

                                        if (dropdownValue1 == "Office") {
                                          cnt = 0;
                                          if (_serviceEnabled) {
                                            if (li3.details[i].cardName
                                                    .toLowerCase() ==
                                                LoginScreenState.homeLoc
                                                    .toLowerCase()) {
                                              _typeAheadController.text =
                                                  li3.details[i].cardName;
                                              cnt++;
                                              setState(() {
                                                enableWorkStart = true;
                                                enableWorkEnd = true;
                                                visibletravel = false;
                                              });
                                              cardcode =
                                                  li3.details[i].cardCode;
                                            }
                                          }
                                        }

                                        // CustomerCodeController.text=li3.details[i].customer;
                                        //
                                        // dropdowncall(li3.details[i].customer);
                                        // OutboundController.text=li3.details[i].delivery;

                                      }
                                    }
                                    if (dropdownValue1 == "Office") if (cnt ==
                                        0) {
                                      setState(() {
                                        enableStartTravel = true;
                                        enableEndTravel = true;
                                        enableWorkStart = true;
                                        enableWorkEnd = true;
                                        visibletravel = true;
                                      });

                                      print("show");
                                    }
                                    print(cnt);
                                    // CheckValidation();
                                    this._typeAheadController.text = suggestion;
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please select a city';
                                    } else
                                      return 'nothing';
                                  },
                                  // onSaved: (value) => this._selectedCity = value,
                                ),
                              ),
                              Divider(),
                              Visibility(
                                visible: visibletravel,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    RaisedButton(
                                      onPressed: enableStartTravel
                                          ? () {
                                              if (dropdownValue1 != "Select Type" &&
                                                  _typeAheadController.text !=
                                                      "" &&
                                                  _typeAheadController.text !=
                                                      "Select Customer" &&
                                                  _typeAheadController.text !=
                                                      "Select Office") {
                                                if (_serviceEnabled)
                                                  getlocation().then((value) {
                                                    placefromLATLNG();
                                                  }).then(
                                                      (value) => StartTravel());
                                                else
                                                  StartTravel();
                                              } else
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Please Select Type and Customer or Office");
                                            }
                                          : null,
                                      child: Text("Start Travel",
                                          style:
                                              TextStyle(color: Colors.white)),
                                      elevation: 5,
                                      color: String_values.primarycolor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                    ),
                                    RaisedButton(
                                      onPressed: enableEndTravel
                                          ? () {
                                              if (dropdownValue1 != "Select Type" &&
                                                  _typeAheadController.text !=
                                                      "" &&
                                                  _typeAheadController.text !=
                                                      "Select Customer" &&
                                                  _typeAheadController.text !=
                                                      "Select Office") {
                                                if (_serviceEnabled)
                                                  getlocation().then((value) {
                                                    placefromLATLNG();
                                                  }).then(
                                                      (value) => EndTravel());
                                                else
                                                  EndTravel();
                                              } else
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Please Select Type and Customer or Office");
                                            }
                                          : null,
                                      child: Text("End Travel",
                                          style:
                                              TextStyle(color: Colors.white)),
                                      elevation: 5,
                                      color: String_values.primarycolor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  RaisedButton(
                                    color: String_values.primarycolor,
                                    onPressed: enableWorkStart
                                        ? () {
                                            if (dropdownValue1 != "Select Type" &&
                                                _typeAheadController.text !=
                                                    "" &&
                                                _typeAheadController.text !=
                                                    "Select Customer" &&
                                                _typeAheadController.text !=
                                                    "Select Office") {
                                              if (_serviceEnabled)
                                                getlocation().then((value) {
                                                  placefromLATLNG();
                                                }).then((value) => WorkStart());
                                              else
                                                WorkStart();
                                            } else
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Please Select Type and Customer or Office");
                                          }
                                        : null,
                                    child: Text(
                                      "Work Start",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                  ),
                                  RaisedButton(
                                    onPressed: enableWorkEnd
                                        ? () {
                                            if (dropdownValue1 != "Select Type" &&
                                                _typeAheadController.text !=
                                                    "" &&
                                                _typeAheadController.text !=
                                                    "Select Customer" &&
                                                _typeAheadController.text !=
                                                    "Select Office") {
                                              if (_serviceEnabled)
                                                getlocation().then((value) {
                                                  placefromLATLNG();
                                                }).then((value) => WorkEnd());
                                              else
                                                WorkEnd();
                                            } else
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Please Select Type and Customer or Office");
                                          }
                                        : null,
                                    child: Text("Work End",
                                        style: TextStyle(color: Colors.white)),
                                    elevation: 5,
                                    color: String_values.primarycolor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10)
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )),
            ),
      appBar: AppBar(
        title: Text("Attendence"),
      ),
      // floatingActionButton: FloatingActionButton(
      //     child: Icon(Icons.directions),
      //     onPressed: () {
      //       print("${locations[0].latitude},${locations[0].longitude}");
      //       getlocationfromAddress(destinationaddress).then((value) {
      //         _launchInBrowser(
      //             "https://www.google.com/maps/dir/?api=1&origin=${position.latitude},${position.longitude}&destination=${locations[0].latitude},${locations[0].longitude}&travelmode=driving");
      //       });
      //     })
    );
  }

  // Future<void> getimei() async {
  // //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  // //   setState(() {
  // //     loading=true;
  // //   });
  // //   AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
  // // print(androidDeviceInfo);
  // }
  Future<void> getLocationEnabled() async {
    _serviceEnabled = await location.serviceEnabled();
  }

  Future<void> getlocation() async {
    setState(() {
      loading = true;
    });

    // List<String> multiImei = await ImeiPlugin.getImeiMulti(); //for double-triple SIM phones
    // String uuid = await ImeiPlugin.getId();
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    marker = Marker(
      markerId: MarkerId("Driver"),
      position: LatLng(position.latitude, position.longitude),
    );
  }

  Future<void> getlocationfromAddress(address) async {
    locations = await locationFromAddress(address);
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'start.png');
  }

  void setCustomMapPin1() async {
    pinLocationIcon1 = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'factory.png');
  }

  Future<void> boundarytake() async {
    GoogleMapController controller = await _controller.future;
    setState(() {
      controller
          .moveCamera(CameraUpdate.newLatLngBounds(getBounds(listmarker), 150));
    });
  }

  Future<void> placefromLATLNG() async {
    placemarks = await placemarkFromCoordinates(currlat, currlon);
    AddressController.text = placemarks[0].name +
        ',' +
        placemarks[0].street +
        ',' +
        placemarks[0].subLocality +
        ',' +
        placemarks[0].locality +
        ',' +
        placemarks[0].administrativeArea +
        ',' +
        placemarks[0].country +
        ',' +
        placemarks[0].postalCode;
    print(AddressController.text);
    setState(() {
      marker = Marker(
        markerId: MarkerId("Driver"),
        position: LatLng(currlat, currlon),
      );
      markers.clear();
      markers.add(marker);
      _kGooglePlex = CameraPosition(target: LatLng(currlat, currlon), zoom: 16);

      loading = false;
      //    print("Markers "+markers.length.toString());
    });
  }

  Future<void> prevstatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    enableStartTravel = !prefs.getBool('tstart');
    enableEndTravel = !prefs.getBool('tend');
    enableWorkStart = !prefs.getBool('wstart');
    enableWorkEnd = !prefs.getBool('wend');
  }
}

class BackendService {
  static Future<List> getSuggestions(String query) async {
    List<String> s = new List();
    if (MapScreenState.li3.details.length == 0) {
      // return ["No details"];
    } else {
      for (int i = 0; i < MapScreenState.li3.details.length; i++)
        if (MapScreenState.li3.details[i].cardName
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            MapScreenState.li3.details[i].cardName
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
          s.add("${MapScreenState.li3.details[i].cardName}");
      // s.add("${MapScreenState.li3.data[i].itemName}-${MapScreenState.li3.data[i].itemCode}");
      return s;
    }
  }
}
// class Delivery_Pickup extends StatefulWidget {
//   @override
//   _Delivery_PickupState createState() => _Delivery_PickupState();
// }
//
// class _Delivery_PickupState extends State<Delivery_Pickup> {
//   String _url = 'https://flutter.dev';
//   Future<void> _launchInBrowser(String url) async {
//     if (await canLaunch(url)) {
//       await launch(
//         url,
//         forceSafariVC: false,
//         forceWebView: false,
//         headers: <String, String>{'my_header_key': 'my_header_value'},
//       );
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//   Future<void> _launchUniversalLinkIos(String url) async {
//     if (await canLaunch(url)) {
//       final bool nativeAppLaunchSucceeded = await launch(
//         url,
//         forceSafariVC: false,
//         universalLinksOnly: true,
//       );
//       if (!nativeAppLaunchSucceeded) {
//         await launch(
//           url,
//           forceSafariVC: true,
//         );
//       }
//     }
//   }
//
//   void _launchURL() async => await canLaunch(_url)
//       ? await launch(_url)
//       : throw 'Could not launch $_url';
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("My Schedule"),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             RaisedButton(onPressed: () {
//               _launchInBrowser(
//                   "https://www.google.com/maps/dir/43.7967876,-79.5331616/43.5184049,-79.8473993/@43.6218599,-79.6908486,9z/data=!4m2!4m1!3e0");
//             })
//           ],
//         ),
//       ),
//     );
//   }
// }
