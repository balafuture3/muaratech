import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geocoding_platform_interface/src/models/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:muratech/Models/CustomerOfficeModel.dart';
import 'package:muratech/Screens/LoginPage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoding/geocoding.dart';
import 'package:xml/xml.dart' as xml;
import '../String_Values.dart';

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

  var enableStartTravel=true;

  Future<http.Response> StartTravel() async {
    setState(() {
      loading = true;
    });
    var envelope = '''
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <IN_MOB_INSERT_STARTTRAVEL xmlns="http://tempuri.org/">
      <TRAVELTYPE>${dropdownValue1}</TRAVELTYPE>
      <CUSTOMERCODE>"${LoginScreenState.li3.empID}"</CUSTOMERCODE>
      <CUSTOMERNAME>"${LoginScreenState.li3.firstName}"</CUSTOMERNAME>
      <TRAVELSTART>string</TRAVELSTART>
      <T_STARTDATE>"${DateFormat("yyyy-MM-dd").format(DateTime.now())}"</T_STARTDATE>
      <T_STARTTIME>${DateFormat("hh:mm a").format(DateTime.now())}</T_STARTTIME>
      <T_STARTLATLANG>string</T_STARTLATLANG>
      <T_STARTADDRESS>string</T_STARTADDRESS>
      <USERID>"${LoginScreenState.li3.empID}"</USERID>
    </IN_MOB_INSERT_STARTTRAVEL>
  </soap:Body>
</soap:Envelope>

''';
    print(envelope);
//     var url =
//         'http://15.206.119.30:2021/Muratech/Service.asmx?op=IN_MOB_INSERT_STARTTRAVEL';
//     // Map data = {
//     //   "username": EmailController.text,
//     //   "password": PasswordController.text
//     // };
// //    print("data: ${data}");
// //    print(String_values.base_url);
//
//     var response = await http.post(url,
//         headers: {
//           "Content-Type": "text/xml; charset=utf-8",
//         },
//         body: envelope);
//     if (response.statusCode == 200) {
//       setState(() {
//         loading = false;
//       });
//
//       xml.XmlDocument parsedXml = xml.XmlDocument.parse(response.body);
//       print(parsedXml.text);
//       if (parsedXml.text != "[]")
//       {
//
//
//         final decoded = json.decode(parsedXml.text);
//         li3 = LoginModel.fromJson(decoded[0]);
//         print(li3.firstName);
//
//         Fluttertoast.showToast(
//             msg:"Login Success",
//             toastLength: Toast.LENGTH_LONG,
//             gravity: ToastGravity.SNACKBAR,
//             timeInSecForIosWeb: 1,
//             backgroundColor: String_values.primarycolor,
//             textColor: Colors.white,
//             fontSize: 16.0);
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//               builder: (context) =>
//                   Dashboard()),
//         );
//
//       } else
//         Fluttertoast.showToast(
//             msg: "Please check your login details,No users found",
//             toastLength: Toast.LENGTH_LONG,
//             gravity: ToastGravity.SNACKBAR,
//             timeInSecForIosWeb: 1,
//             backgroundColor: String_values.primarycolor,
//             textColor: Colors.white,
//             fontSize: 16.0);
//     } else {
//       Fluttertoast.showToast(
//           msg: "Http error!, Response code ${response.statusCode}",
//           toastLength: Toast.LENGTH_LONG,
//           gravity: ToastGravity.SNACKBAR,
//           timeInSecForIosWeb: 1,
//           backgroundColor: String_values.primarycolor,
//           textColor: Colors.white,
//           fontSize: 16.0);
//       setState(() {
//         loading = false;
//       });
//       print("Retry");
//     }
//     // print("response: ${response.statusCode}");
//     // print("response: ${response.body}");
//     return response;
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

  Completer<GoogleMapController> _controller = Completer();
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


  List<Location> locations;

  void initState() {
    getlocation().then((value) {

    });
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

                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    markers: markers,
                  ),
                  Container(

                    color: Colors.white,
                    child: ExpansionTile(title: Text("Attendence"),
                    initiallyExpanded: true,
                    children: [
                      Container(
                        color: Colors.white,

                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left:16,right:16,bottom: 16),
                              child: Row(
                                children: [
                                  Expanded(flex:2,child: Icon(Icons.map_sharp,color: String_values.primarycolor,size: height/10,)),
                                  Expanded(flex:4,child: TextField(
                                    controller: AddressController,
                                    enabled: false,
                                    minLines: 3,
                                    maxLines: 25,
                                    decoration: InputDecoration(
                                      labelText: "Your Address",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25.0),
                                      ),

                                    ),

                                  ))

                                ],
                              ),
                            ),
                            Container(
                              height: 55,
                              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                              padding: const EdgeInsets.only(left:24,right: 24,top: 6,bottom: 6),
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
                                      _typeAheadController.text="";
                                      if(dropdownValue1=="Office")
                                        customerListorOfficeList(1);
                                      else if(dropdownValue1=="Customer")
                                        customerListorOfficeList(2);
                                      else
                                        Fluttertoast.showToast(msg: "Please Choose Office or Customer");


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
                              height: 55,
                              margin: const EdgeInsets.only(
                                  left: 16.0, right: 16.0, top: 16),
                              child: TypeAheadFormField(
                                textFieldConfiguration: TextFieldConfiguration(
                                  enabled: true,
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
                                    labelText: dropdownValue1=="Office"?'Choose Office':dropdownValue1=="Customer"?'Choose Customer':"",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16.0,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                  ),
                                ),
                                suggestionsCallback: (pattern) {
                                  return BackendService.getSuggestions(pattern);
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
                                  setState(() {
                                    // dropdownValue1 = " Select OBD Number ";
                                  });

                                  // postRequest(suggestion);
                                  // for (int i = 0; i < li3.data.length; i++) {
                                  //   print(li3.data[i].itemName);
                                  //   if ("${li3.data[i].itemName}" == suggestion) {
                                  //     itemcode = li3.data[i].itemCode;
                                  //
                                  //     // CustomerCodeController.text=li3.details[i].customer;
                                  //     //
                                  //     // dropdowncall(li3.details[i].customer);
                                  //     // OutboundController.text=li3.details[i].delivery;
                                  //
                                  //   }
                                  // }
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                RaisedButton(onPressed: enableStartTravel?(){
                                  StartTravel();
                                }:null,child: Text("Start Travel",style: TextStyle(color: Colors.white)),
                                  elevation: 5,
                                  color: String_values.primarycolor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(25.0),
                                  ),
                                ),
                                RaisedButton(onPressed: (){},child: Text("End Travel",style: TextStyle(color: Colors.white)),
                                  elevation: 5,
                                  color: String_values.primarycolor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(25.0),
                                  ),),

                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                RaisedButton(
                                  color: String_values.primarycolor,
                                  onPressed: (){},child: Text("Work Start",style: TextStyle(color: Colors.white),),  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(25.0),
                                  ),),
                                RaisedButton(onPressed: (){},child: Text("Work End",style: TextStyle(color: Colors.white)),
                                  elevation: 5,
                                  color: String_values.primarycolor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(25.0),
                                  ),),
                              ],
                            ),
                            SizedBox(height: 10)
                          ],
                        ),
                      )
                    ],),
                  )

                ],
              )),
            ),
        // appBar: AppBar(
        //   title: Text("Attendence"),
        // ),
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

    setState(() {
      markers.add(marker);
      _kGooglePlex = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 10);

      loading = false; //    print("Markers "+markers.length.toString());
    });
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
      controller.moveCamera(CameraUpdate.newLatLngBounds(getBounds(listmarker), 150));
    });
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
            .toLowerCase()
            .contains(query.toLowerCase()) ||
            MapScreenState.li3.details[i].cardName
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
