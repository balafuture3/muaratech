import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:muratech/Models/ViewAttendenceModel.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:xml/xml.dart' as xml;

import '../String_Values.dart';
import 'LoginPage.dart';

class ViewAttendence extends StatefulWidget {
  @override
  ViewAttendenceState createState() => ViewAttendenceState();
}

class ViewAttendenceState extends State<ViewAttendence> {
  bool loading = false;
  // BarcodeModel li;
  // static StockListModel li3;
  TextEditingController _typeAheadController = new TextEditingController();
  TextEditingController _typeAheadController1 = new TextEditingController();
  TextEditingController _typeAheadController2 = new TextEditingController();
  TextEditingController EndDateController = new TextEditingController();
  TextEditingController StartDateController = new TextEditingController();
  TextEditingController EndDateController1 = new TextEditingController();
  TextEditingController StartDateController1 = new TextEditingController();
  TextEditingController serialcontroller = new TextEditingController();
  TextEditingController capacitycontroller = new TextEditingController();
  TextEditingController cylpressurecontroller = new TextEditingController();
  TextEditingController workpressurecontroller = new TextEditingController();
  TextEditingController BarCodecontroller = new TextEditingController();
  TextEditingController BarCodeorSerialcontroller = new TextEditingController();
  TextEditingController BarCodeorSerialcontroller1 =
      new TextEditingController();
  static List<Filldetails> s = new List();
  List<ViewAttendenceList> employees = <ViewAttendenceList>[];
  EmployeeDataSource employeeDataSource;
  var stringlist = ["KGS", "LTR", "PSI", "BAR"];
  var dropdownValue1 = "KGS";
  var dropdownValue2 = "KGS";
  var dropdownValue3 = "KGS";
  var BarcodeorSerialValue = "P";
  var barcodeenable = true;
  var BarcodeorSerialValue1 = "P";
  var barcodeenable1 = true;
  List<ItemClass> itemlist = new List<ItemClass>();

  String itemcode;
  String itemcode1;
  // SaveResponse li2;
  //
  // var enableselection=true;
  //
  // static AssetListModel li4;
  //
  // var value=true;
  //
  // static FillListModel li5;

  var check = false;

  static ViewAttendenceList li4;
  Future<http.Response> GetAttendence() async {
    setState(() {
      loading = true;
    });
    var envelope = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <IN_MOB_TRAVEL_REPORT1 xmlns="http://tempuri.org/">
      <USERID>${LoginScreenState.empID}</USERID>
      <FromDate>${StartDateController.text}</FromDate>
      <ToDate>${EndDateController.text}</ToDate>
    </IN_MOB_TRAVEL_REPORT1>
  </soap:Body>
</soap:Envelope>
''';
    print(envelope);
    var url =
        'http://15.206.119.30:2021/Muratech/Service.asmx?op=IN_MOB_TRAVEL_REPORT1';
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
      if (parsedXml.text != "[]") {
        final decoded = json.decode(parsedXml.text);
        print(decoded);
        li4 = ViewAttendenceList.fromJson(decoded);
        employeeDataSource = EmployeeDataSource(li4: li4);
        print(li4.details[0].wENDTIME);
      } else
        Fluttertoast.showToast(
            msg: "No details found",
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

    return response;
  }

  // Future<http.Response> StockList() async {
  //   setState(() {
  //     loading = true;
  //   });
  //   var url;
  //
  //   url = String_values.url + "GetPGOnHandStock";
  //
  //   print(url);
  //   // print(headers);
  //   var response = await http.get(
  //     url,
  //   );
  //
  //   print(response.body);
  //
  //   if (response.statusCode == 200) {
  //     li3 = StockListModel.fromJson(json.decode(response.body));
  //     setState(() {
  //       loading = false;
  //     });
  //   } else {
  //     setState(() {
  //       loading = false;
  //     });
  //     print("Retry");
  //   }
  //   print("response: ${response.statusCode}");
  //   print("response: ${response.body}");
  //   return response;
  // }
  // Future<http.Response> AssetList() async {
  //   setState(() {
  //     loading = true;
  //   });
  //   var url;
  //
  //   url = String_values.url + "GetAssetReport?FromDate=${StartDateController.text}&ToDate=${EndDateController.text}";
  //
  //   print(url);
  //   // print(headers);
  //   var response = await http.get(
  //     url,
  //   );
  //
  //   print(response.body);
  //
  //   if (response.statusCode == 200) {
  //     li4 = AssetListModel.fromJson(json.decode(response.body));
  //     setState(() {
  //       loading = false;
  //     });
  //   } else {
  //     setState(() {
  //       loading = false;
  //     });
  //     print("Retry");
  //   }
  //   print("response: ${response.statusCode}");
  //   print("response: ${response.body}");
  //   return response;
  // }
  // Future<http.Response> FillList() async {
  //   setState(() {
  //     loading = true;
  //   });
  //   var url;
  //
  //   url = String_values.url + "GetPGFillDetails?FromDate=${StartDateController1.text}&ToDate=${EndDateController1.text}";
  //
  //
  //   print(url);
  //   // print(headers);
  //   var response = await http.get(
  //     url,
  //   );
  //
  //   print(response.body);
  //
  //   if (response.statusCode == 200) {
  //     li5 = FillListModel.fromJson(json.decode(response.body));
  //     setState(() {
  //       loading = false;
  //     });
  //   } else {
  //     setState(() {
  //       loading = false;
  //     });
  //     print("Retry");
  //   }
  //   print("response: ${response.statusCode}");
  //   print("response: ${response.body}");
  //   return response;
  // }
  // Future<void> scanBarcodeNormal() async {
  //   String barcodeScanRes;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //         "#ff6666", "Cancel", true, ScanMode.BARCODE);
  //     print(barcodeScanRes);
  //     if (barcodeScanRes != "-1") BarCodecontroller.text = barcodeScanRes;
  //     // showDialog<void>(
  //     //   context: context,
  //     //   barrierDismissible: false, // user must tap button!
  //     //   builder: (BuildContext context) {
  //     //     return AlertDialog(
  //     //       title: Text("BarCode Data : $barcodeScanRes"),
  //     //       actions: <Widget>[
  //     //         TextButton(
  //     //           child: Text('OK'),
  //     //           onPressed: () {
  //     //             Navigator.of(context).pop();
  //     //           },
  //     //         ),
  //     //       ],
  //     //     );
  //     //   },
  //     // );
  //   } on PlatformException {
  //     barcodeScanRes = 'Failed to get platform version.';
  //   }
  //
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;
  //
  //   // setState(() {
  //   //   _scanBarcode = barcodeScanRes;
  //   // });
  // }

  Future<void> scanBarcodeNormal1() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
      if (barcodeScanRes != "-1")
        BarCodeorSerialcontroller.text = barcodeScanRes;
      // showDialog<void>(
      //   context: context,
      //   barrierDismissible: false, // user must tap button!
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: Text("BarCode Data : $barcodeScanRes"),
      //       actions: <Widget>[
      //         TextButton(
      //           child: Text('OK'),
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //         ),
      //       ],
      //     );
      //   },
      // );
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // setState(() {
    //   _scanBarcode = barcodeScanRes;
    // });
  }
  //
  // Future<http.Response> barcodeapi(barcode) async {
  //   setState(() {
  //     loading = true;
  //   });
  //   var url = String_values.url +
  //       'GetPreFillDetails?PreFillNo=${itemcode}&SerialNo=${barcode}';
  //   print(url);
  //   var response = await http.get(
  //     url,
  //     headers: {
  //       "Content-Type": "application/json",
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       loading = false;
  //     });
  //
  //     li = BarcodeModel.fromJson(json.decode(response.body));
  //
  //     if (li.status == "True") {
  //       setState(() {
  //         if (itemcode == li.data[0].itemCode) {
  //           var cnt = 0;
  //           for (int i = 0; i < itemlist.length; i++)
  //             if (itemlist[i].Barcode == li.data[0].barcode) cnt++;
  //           if (cnt == 0)
  //             itemlist.add(ItemClass(
  //               li.data[0].barcode,
  //               li.data[0].serialNo,
  //               li.data[0].itemCode,
  //               li.data[0].capacity,
  //               li.data[0].currentStatus,
  //               li.data[0].itemName,));
  //           else
  //             Fluttertoast.showToast(msg: "Item Already Exists");
  //         } else
  //           Fluttertoast.showToast(msg: "Selected item product code not matched");
  //       });
  //     } else
  //       Fluttertoast.showToast(msg: li.message);
  //   }  else {
  //     setState(() {
  //       loading = false;
  //     });
  //     print("Retry");
  //   }
  //   print("response: ${response.statusCode}");
  //   print("response: ${response.body}");
  //   return response;
  // }
  //
  // Future<http.Response> serialapi(serialno) async {
  //   setState(() {
  //     loading = true;
  //   });
  //   var url = String_values.url +
  //       'PureGas/GetPreFillDetails?PreFillNo=${itemcode}&SerialNo=${serialno}';
  //   print(url);
  //   var response = await http.get(
  //     url,
  //     headers: {
  //       "Content-Type": "application/json",
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       loading = false;
  //     });
  //
  //     li = BarcodeModel.fromJson(json.decode(response.body));
  //
  //     if (li.status == "True") {
  //       setState(() {
  //         if (itemcode == li.data[0].itemCode) {
  //           var cnt = 0;
  //           for (int i = 0; i < itemlist.length; i++)
  //             if (itemlist[i].Barcode == li.data[0].barcode) cnt++;
  //           if (cnt == 0)
  //             itemlist.add(ItemClass(
  //               li.data[0].barcode,
  //               li.data[0].serialNo,
  //               li.data[0].itemCode,
  //               li.data[0].capacity,
  //               li.data[0].currentStatus,
  //               li.data[0].itemName,));
  //           else
  //             Fluttertoast.showToast(msg: "Item Already Exists");
  //         } else
  //           Fluttertoast.showToast(msg: "Selected item product code not matched");
  //       });
  //     } else
  //       Fluttertoast.showToast(msg: li.message);
  //   } else {
  //     setState(() {
  //       loading = false;
  //     });
  //     print("Retry");
  //   }
  //   print("response: ${response.statusCode}");
  //   print("response: ${response.body}");
  //   return response;
  // }
  //
  //
  //
  //
  //
  // Future<http.Response> saveapi() async {
  //   setState(() {
  //     loading = true;
  //   });
  //   String header = "";
  //   String data = "";
  //   String comma;
  //   for (int i = 0; i < itemlist.length; i++) {
  //     if (i == itemlist.length - 1)
  //       comma = "";
  //     else
  //       comma = ',';
  //     data =data+'{"ItemName":"${itemlist[i].ItemName}","ProductCode":"${itemlist[i].ItemCode}","SerialNo":"${itemlist[i].Serialno}"}$comma';
  //     header = header +
  //         '{"ScannedQty":"${itemlist.length}","SelectedItem":"${itemlist[i].ItemName}","SelectedItemCode":"${itemlist[i].ItemCode}","UserSign":"${LoginScreenState.emailController.text}"}$comma';
  //   }
  //   var url = String_values.url +
  //       'GetPreFill?StrJSON={"HEADER":['
  //           '${header}'
  //           '],'+'"DETAIL":['+'$data'+']}';
  //   print(url);
  //   var response = await http.get(
  //     url,
  //     headers: {
  //       "Content-Type": "application/json",
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       loading = false;
  //     });
  //     li2 = SaveResponse.fromJson(jsonDecode(response.body));
  //     if (li2.status == "True") {
  //       Fluttertoast.showToast(msg: li2.message);
  //
  //     } else
  //       Fluttertoast.showToast(msg: li2.message);
  //   } else {
  //     setState(() {
  //       loading = false;
  //     });
  //     print("Retry");
  //   }
  //   print("response: ${response.statusCode}");
  //   print("response: ${response.body}");
  //   return response;
  // }

  String date;
  List<Employee> getEmployeeData() {
    return [
      Employee(10001, 'James', 'Project Lead', 20000),
      Employee(10002, 'Kathryn', 'Manager', 30000),
      Employee(10003, 'Lara', 'Developer', 15000),
      Employee(10004, 'Michael', 'Designer', 15000),
      Employee(10005, 'Martin', 'Developer', 15000),
      Employee(10006, 'Newberry', 'Developer', 15000),
      Employee(10007, 'Balnc', 'Developer', 15000),
      Employee(10008, 'Perry', 'Developer', 15000),
      Employee(10009, 'Gable', 'Developer', 15000),
      Employee(10010, 'Grimes', 'Developer', 15000)
    ];
  }

  @override
  void initState() {
    // employees = GetAttendence();
    // employeeDataSource = EmployeeDataSource();
    barcodeenable = true;
    StartDateController.text = DateFormat("dd/MM/yyyy")
        .format(DateTime.now().subtract(Duration(days: 30)));
    EndDateController.text = DateFormat("dd/MM/yyyy").format(DateTime.now());
    // StartDateController1.text = DateFormat("yyyy-MM-dd")
    //     .format(DateTime.now().subtract(Duration(days: 30)));
    // EndDateController1.text = DateFormat("yyyy-MM-dd").format(DateTime.now());
    date = DateFormat.jm().format(DateTime.now()) +
        "," +
        DateFormat.yMMMd().format(DateTime.now());
    GetAttendence();
    // StockList().then((value) =>AssetList().then((value) => FillList()) );
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("View Attendence"),
        ),
        body: loading
            ? Center(child: CircularProgressIndicator())
            : Column(children: [
                SizedBox(
                  height: height / 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        height: 55,
                        width: width / 2.2,
                        child: TextField(
                          onTap: () async {
                            DateTime date = DateTime(1900);
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());

                            date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now()
                                    .subtract(new Duration(days: 365 * 120)),
                                lastDate: DateTime.now()
                                    .add(new Duration(days: 365)));

                            StartDateController.text =
                                date.day.toString().padLeft(2, "0") +
                                    '/' +
                                    date.month.toString().padLeft(2, "0") +
                                    '/' +
                                    date.year.toString();
                            // AssetList();
                          },
                          enabled: true,
                          controller: StartDateController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today_outlined),
                            labelText: 'Start Date',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        )),
                    Container(
                        height: 55,
                        width: width / 2.2,
                        child: TextField(
                          onTap: () async {
                            DateTime date = DateTime(1900);
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());

                            date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now()
                                    .subtract(new Duration(days: 365 * 120)),
                                lastDate: DateTime.now()
                                    .add(new Duration(days: 365)));

                            EndDateController.text =
                                date.day.toString().padLeft(2, "0") +
                                    '/' +
                                    date.month.toString().padLeft(2, "0") +
                                    '/' +
                                    date.year.toString();
                            // AssetList();
                          },
                          enabled: true,
                          controller: EndDateController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today_outlined),
                            labelText: 'End Date',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        )),
                  ],
                ),
                SizedBox(
                  height: height / 30,
                ),
                Container(
                    width: width / 2,
                    height: 50,
                    child: RaisedButton(
                      onPressed: () {
                        GetAttendence();
                      },
                      child: Text(
                        "Search",
                        style: TextStyle(color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      color: String_values.primarycolor,
                    )),
                SizedBox(
                  height: height / 30,
                ),
                // li4 != null
                //     ? SingleChildScrollView(
                //         scrollDirection: Axis.horizontal,
                //         child: DataTable(
                //           headingRowColor: MaterialStateColor.resolveWith(
                //               (states) => String_values.primarycolor),
                //           columnSpacing: 5,
                //
                //           columns: [
                //             // DataColumn(
                //             //   label: Center(
                //             //       child: Wrap(
                //             //     direction: Axis.vertical, //default
                //             //     alignment: WrapAlignment.center,
                //             //     children: [
                //             //       Text(
                //             //         "S.No",
                //             //         softWrap: true,
                //             //
                //             //         style: TextStyle(fontSize: 12,color: Colors.white),
                //             //         textAlign: TextAlign.center,
                //             //       ),
                //             //     ],
                //             //   )),
                //             //   numeric: false,
                //             //
                //             //   // onSort: (columnIndex, ascending) {
                //             //   //   onSortColum(columnIndex, ascending);
                //             //   //   setState(() {
                //             //   //     sort = !sort;
                //             //   //   });
                //             //   // }
                //             // ),
                //             DataColumn(
                //               label: Center(
                //                   child: Wrap(
                //                 direction: Axis.vertical, //default
                //                 alignment: WrapAlignment.center,
                //                 children: [
                //                   Text("Date",
                //                       softWrap: true,
                //                       style: TextStyle(
                //                           fontSize: 12, color: Colors.white),
                //                       textAlign: TextAlign.center),
                //                 ],
                //               )),
                //               numeric: false,
                //
                //               // onSort: (columnIndex, ascending) {
                //               //   onSortColum(columnIndex, ascending);
                //               //   setState(() {
                //               //     sort = !sort;
                //               //   });
                //               // }
                //             ),
                //             DataColumn(
                //               label: Center(
                //                   child: Wrap(
                //                 direction: Axis.vertical, //default
                //                 alignment: WrapAlignment.center,
                //                 children: [
                //                   Text("Customer Name",
                //                       softWrap: true,
                //                       style: TextStyle(
                //                           fontSize: 12, color: Colors.white),
                //                       textAlign: TextAlign.center),
                //                 ],
                //               )),
                //               numeric: false,
                //
                //               // onSort: (columnIndex, ascending) {
                //               //   onSortColum(columnIndex, ascending);
                //               //   setState(() {
                //               //     sort = !sort;
                //               //   });
                //               // }
                //             ),
                //
                //             DataColumn(
                //               label: Wrap(
                //                 direction: Axis.vertical, //default
                //                 alignment: WrapAlignment.end,
                //                 children: [
                //                   Column(
                //                     crossAxisAlignment: CrossAxisAlignment.end,
                //                     mainAxisAlignment: MainAxisAlignment.center,
                //                     children: [
                //                       Text("Start",
                //                           softWrap: true,
                //                           style: TextStyle(
                //                               fontSize: 16,
                //                               color: Colors.white),
                //                           textAlign: TextAlign.end),
                //                       Divider(
                //                         color: Colors.white,
                //                         thickness: 5,
                //                         height: 5,
                //                       ),
                //                       Text("Travel Start           ",
                //                           softWrap: true,
                //                           style: TextStyle(
                //                               fontSize: 12,
                //                               color: Colors.white),
                //                           textAlign: TextAlign.end),
                //                     ],
                //                   ),
                //                 ],
                //               ),
                //               numeric: false,
                //
                //               // onSort: (columnIndex, ascending) {
                //               //   onSortColum(columnIndex, ascending);
                //               //   setState(() {
                //               //     sort = !sort;
                //               //   });
                //               // }
                //             ),
                //             DataColumn(
                //               label: Center(
                //                   child: Wrap(
                //                 direction: Axis.vertical, //default
                //                 alignment: WrapAlignment.center,
                //                 children: [
                //                   Text("Time",
                //                       softWrap: true,
                //                       style: TextStyle(
                //                           fontSize: 16, color: Colors.white),
                //                       textAlign: TextAlign.center),
                //                   Divider(
                //                     color: Colors.white,
                //                     thickness: 5,
                //                     height: 5,
                //                   ),
                //                   Text("Work Start",
                //                       softWrap: true,
                //                       style: TextStyle(
                //                           fontSize: 12, color: Colors.white),
                //                       textAlign: TextAlign.center),
                //                 ],
                //               )),
                //               numeric: false,
                //
                //               // onSort: (columnIndex, ascending) {
                //               //   onSortColum(columnIndex, ascending);
                //               //   setState(() {
                //               //     sort = !sort;
                //               //   });
                //               // }
                //             ),
                //             DataColumn(
                //               label: Wrap(
                //                 direction: Axis.vertical, //default
                //                 alignment: WrapAlignment.end,
                //                 children: [
                //                   Column(
                //                     crossAxisAlignment: CrossAxisAlignment.end,
                //                     mainAxisAlignment: MainAxisAlignment.center,
                //                     children: [
                //                       Text("End",
                //                           softWrap: true,
                //                           style: TextStyle(
                //                               fontSize: 16,
                //                               color: Colors.white),
                //                           textAlign: TextAlign.end),
                //                       Divider(
                //                         color: Colors.white,
                //                         thickness: 5,
                //                         height: 5,
                //                       ),
                //                       Text("Travel End              ",
                //                           softWrap: true,
                //                           style: TextStyle(
                //                               fontSize: 12,
                //                               color: Colors.white),
                //                           textAlign: TextAlign.end),
                //                     ],
                //                   ),
                //                 ],
                //               ),
                //               numeric: false,
                //
                //               // onSort: (columnIndex, ascending) {
                //               //   onSortColum(columnIndex, ascending);
                //               //   setState(() {
                //               //     sort = !sort;
                //               //   });
                //               // }
                //             ),
                //             DataColumn(
                //               label: Center(
                //                   child: Wrap(
                //                 direction: Axis.vertical, //default
                //                 alignment: WrapAlignment.center,
                //                 children: [
                //                   Text("Time",
                //                       softWrap: true,
                //                       style: TextStyle(
                //                           fontSize: 16, color: Colors.white),
                //                       textAlign: TextAlign.center),
                //                   Divider(
                //                     color: Colors.white,
                //                     thickness: 5,
                //                     height: 5,
                //                   ),
                //                   Text("Work End   ",
                //                       softWrap: true,
                //                       style: TextStyle(
                //                           fontSize: 12, color: Colors.white),
                //                       textAlign: TextAlign.center),
                //                 ],
                //               )),
                //               numeric: false,
                //
                //               // onSort: (columnIndex, ascending) {
                //               //   onSortColum(columnIndex, ascending);
                //               //   setState(() {
                //               //     sort = !sort;
                //               //   });
                //               // }
                //             ),
                //           ],
                //           rows: [
                //             for (int list = 0;
                //                 list < li4.details.length;
                //                 list++)
                //               DataRow(cells: [
                //                 // DataCell(Center(
                //                 //     child: Center(
                //                 //   child: Wrap(
                //                 //       direction: Axis.vertical, //default
                //                 //       alignment: WrapAlignment.center,
                //                 //       children: [
                //                 //         Text(
                //                 //           (list+1).toString(),
                //                 //           textAlign: TextAlign.center,
                //                 //         )
                //                 //       ]),
                //                 // ))),
                //                 DataCell(Center(
                //                     child: Center(
                //                   child: Wrap(
                //                       direction: Axis.vertical, //default
                //                       alignment: WrapAlignment.center,
                //                       children: [
                //                         Text(
                //                             li4.details[list].dOCDATE
                //                                 .toString(),
                //                             textAlign: TextAlign.center)
                //                       ]),
                //                 ))),
                //                 DataCell(Center(
                //                     child: Center(
                //                   child: Wrap(
                //                       direction: Axis.vertical, //default
                //                       alignment: WrapAlignment.center,
                //                       children: [
                //                         Text(
                //                             li4.details[list].cUSTOMERNAME
                //                                 .toString(),
                //                             textAlign: TextAlign.center)
                //                       ]),
                //                 ))),
                //                 DataCell(Center(
                //                     child: Center(
                //                   child: Wrap(
                //                       direction: Axis.vertical, //default
                //                       alignment: WrapAlignment.center,
                //                       children: [
                //                         Text(
                //                             li4.details[list].tSTARTTIME
                //                                 .toString(),
                //                             textAlign: TextAlign.center)
                //                       ]),
                //                 ))),
                //                 DataCell(Center(
                //                     child: Center(
                //                   child: Wrap(
                //                       direction: Axis.vertical, //default
                //                       alignment: WrapAlignment.center,
                //                       children: [
                //                         Text(
                //                             li4.details[list].wSTARTTIME
                //                                 .toString(),
                //                             textAlign: TextAlign.center)
                //                       ]),
                //                 ))),
                //                 DataCell(Center(
                //                     child: Center(
                //                   child: Wrap(
                //                       direction: Axis.vertical, //default
                //                       alignment: WrapAlignment.center,
                //                       children: [
                //                         Text(
                //                             li4.details[list].tENDTIME
                //                                 .toString(),
                //                             textAlign: TextAlign.center)
                //                       ]),
                //                 ))),
                //                 DataCell(Center(
                //                     child: Center(
                //                   child: Wrap(
                //                       direction: Axis.vertical, //default
                //                       alignment: WrapAlignment.center,
                //                       children: [
                //                         Text(
                //                             li4.details[list].wENDTIME
                //                                 .toString(),
                //                             textAlign: TextAlign.center)
                //                       ]),
                //                 ))),
                //               ])
                //           ],
                //           // rows: li4.details.map((list) => DataRow(cells: [
                //           //       DataCell(Center(
                //           //           child: Center(
                //           //         child: Wrap(
                //           //             direction: Axis.vertical, //default
                //           //             alignment: WrapAlignment.center,
                //           //             children: [
                //           //               Text(
                //           //                 "1",
                //           //                 textAlign: TextAlign.center,
                //           //               )
                //           //             ]),
                //           //       ))),
                //           //       DataCell(Center(
                //           //           child: Center(
                //           //         child: Wrap(
                //           //             direction: Axis.vertical, //default
                //           //             alignment: WrapAlignment.center,
                //           //             children: [
                //           //               Text(list.dOCDATE.toString(),
                //           //                   textAlign: TextAlign.center)
                //           //             ]),
                //           //       ))),
                //           //   DataCell(Center(
                //           //       child: Center(
                //           //         child: Wrap(
                //           //             direction: Axis.vertical, //default
                //           //             alignment: WrapAlignment.center,
                //           //             children: [
                //           //               Text(list.cUSTOMERNAME.toString(),
                //           //                   textAlign: TextAlign.center)
                //           //             ]),
                //           //       ))),
                //           //   DataCell(Center(
                //           //       child: Center(
                //           //         child: Wrap(
                //           //             direction: Axis.vertical, //default
                //           //             alignment: WrapAlignment.center,
                //           //             children: [
                //           //               Text(list.tSTARTTIME.toString(),
                //           //                   textAlign: TextAlign.center)
                //           //             ]),
                //           //       ))),
                //           //   DataCell(Center(
                //           //       child: Center(
                //           //         child: Wrap(
                //           //             direction: Axis.vertical, //default
                //           //             alignment: WrapAlignment.center,
                //           //             children: [
                //           //               Text(list.tENDTIME.toString(),
                //           //                   textAlign: TextAlign.center)
                //           //             ]),
                //           //       ))),
                //           //   DataCell(Center(
                //           //       child: Center(
                //           //         child: Wrap(
                //           //             direction: Axis.vertical, //default
                //           //             alignment: WrapAlignment.center,
                //           //             children: [
                //           //               Text(list.wSTARTTIME.toString(),
                //           //                   textAlign: TextAlign.center)
                //           //             ]),
                //           //       ))),
                //           //   DataCell(Center(
                //           //       child: Center(
                //           //         child: Wrap(
                //           //             direction: Axis.vertical, //default
                //           //             alignment: WrapAlignment.center,
                //           //             children: [
                //           //               Text(list.wENDTIME.toString(),
                //           //                   textAlign: TextAlign.center)
                //           //             ]),
                //           //       ))),
                //           //     ]))
                //         ))
                //     : Padding(
                //         padding: const EdgeInsets.all(16.0),
                //         child: Text("No Details"),
                //       ),
                Expanded(
                  child: SfDataGrid(
                    headerRowHeight: 30,
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.both,
                    source: employeeDataSource,

                    // defaultColumnWidth: 100,
                    columns: <GridColumn>[
                      GridTextColumn(
                          width: 100,
                          columnName: 'date',
                          label: Container(
                              color: Colors.indigo,
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: Text(
                                'Date',
                                style: TextStyle(color: Colors.white,fontSize: 13),

                                overflow: TextOverflow.ellipsis,
                              ))),
                      GridTextColumn(
                          width: 250,
                          columnName: 'cusname',
                          label: Container(
                              color: Colors.indigo,
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: Text(
                                'Customer Name',
                                style: TextStyle(color: Colors.white,fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ))),
                      GridTextColumn(
                          width: 140,
                          columnName: 'travelstart',
                          label: Container(
                              color: Colors.indigo,
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: Text(
                                'Travel Start',
                                style: TextStyle(color: Colors.white,fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ))),
                      GridTextColumn(
                          width: 120,
                          columnName: 'workstart',
                          label: Container(
                              color: Colors.indigo,
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: Text(
                                'Work Start',
                                style: TextStyle(color: Colors.white,fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ))),

                      GridTextColumn(
                          width: 120,
                          columnName: 'workend',
                          label: Container(
                              color: Colors.indigo,
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: Text(
                                'Work End',
                                style: TextStyle(color: Colors.white,fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ))),
                      GridTextColumn(
                          width: 120,
                          columnName: 'travelend',
                          label: Container(
                              color: Colors.indigo,
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              alignment: Alignment.center,
                              child: Text(
                                'Travel End',
                                style: TextStyle(color: Colors.white,fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ))),
                    ],
                    stackedHeaderRows: <StackedHeaderRow>[
                      StackedHeaderRow(cells: [
                        StackedHeaderCell(
                            columnNames: ['travelstart', 'workstart'],
                            child: Container(
                                color: Colors.indigo,
                                child: Center(
                                    child: Text(
                                  'Start Time',
                                  style: TextStyle(color: Colors.white,fontSize: 13),
                                )))),
                        StackedHeaderCell(
                            columnNames: ['travelend', 'workend'],
                            child: Container(
                                color: Colors.indigo,
                                child: Center(
                                    child: Text('End Time',
                                        style:
                                            TextStyle(color: Colors.white,fontSize: 13)))))
                      ])
                    ],
                  ),
                ),
              ]));
  }
}

class ItemClass {
  String Barcode;
  String Serialno;
  String ItemCode;
  String Capacity;
  String CurrentStatus;
  String ItemName;

  ItemClass(this.Barcode, this.Serialno, this.ItemCode, this.Capacity,
      this.CurrentStatus, this.ItemName);
}

class Filldetails {
  String Fillid;
  String ItemName;
  String DocDate;
  String ScannedQty;

  Filldetails(this.Fillid, this.ItemName, this.DocDate, this.ScannedQty);
}

/// Custom business object class which contains properties to hold the detailed
/// information about the employee which will be rendered in datagrid.
class Employee {
  /// Creates the employee class with required details.
  Employee(this.id, this.name, this.designation, this.salary);

  /// Id of an employee.
  final int id;

  /// Name of an employee.
  final String name;

  /// Designation of an employee.
  final String designation;

  /// Salary of an employee.
  final int salary;
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class EmployeeDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  EmployeeDataSource({ViewAttendenceList li4}) {
    _employeeData = li4.details
        .map<DataGridRow>((e) => DataGridRow(

        cells: [
              DataGridCell<String>(columnName: 'date', value: e.dOCDATE),
              DataGridCell<String>(
                  columnName: 'cusname', value: e.cUSTOMERNAME),
              DataGridCell<String>(
                  columnName: 'travelstart', value: e.tSTARTTIME),
              DataGridCell<String>(
                  columnName: 'workstart', value: e.wSTARTTIME),

              DataGridCell<String>(columnName: 'workend', value: e.wENDTIME),
              DataGridCell<String>(columnName: 'travelend', value: e.tENDTIME),
            ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: e.columnName=="cusname"?Alignment.centerLeft:Alignment.center,
        padding: EdgeInsets.all(4.0),
        child: Text(e.value.toString(),style: TextStyle(fontSize: 12),
        maxLines: 2,overflow: TextOverflow.ellipsis,),
      );
    }).toList());
  }
}
