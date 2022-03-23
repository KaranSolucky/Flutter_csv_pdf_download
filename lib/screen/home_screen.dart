import 'dart:convert';
// import 'dart:html';
import 'dart:io';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:dio/dio.dart';
// import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:orient_technology/screen/responsive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:universal_html/html.dart' as html;
import 'package:pdf/widgets.dart' as pw;

// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';

// import 'dart:typed_data'; //to access Uint8List class

import 'package:flutter/services.dart' show rootBundle;

//importing web file based on condition
import 'web.dart' if (dart.library.html) 'web.dart';

import '../api/pdf_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _openResult = 'Unknown';
  @override
  void initState() {
    super.initState();

    List<dynamic> associateList = [
      {"number": 1, "lat": "14.97534313396318", "lon": "101.22998536005622"},
      {"number": 2, "lat": "14.97534313396318", "lon": "101.22998536005622"},
      {"number": 3, "lat": "14.97534313396318", "lon": "101.22998536005622"},
      {"number": 4, "lat": "14.97534313396318", "lon": "101.22998536005622"}
    ];
  }

  bool downloading = false;
  var progress = "";
  var path = "No Data";
  var platformVersion = "Unknown";
  Permission permission1 = Permission.storage;
  var _onPressed;

  Future<String> loadAsset(String path) async {
    return await rootBundle.loadString(path);
  }

  void loadCSV() {}
  Future<File?> download(String url, String name) async {
    final appstorage = await getApplicationDocumentsDirectory();
    final file = File('${appstorage.path}/filename.csv');

    final response = await Dio().get(file.toString(),
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0));
    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(response.data);
    await raf.close();
    return file;
  }

  Directory? externalDir;
  Future<void> downloadFile() async {
    Dio dio = Dio();

    String dirloc = "";
    if (Platform.isAndroid) {
      dirloc = "/sdcard/download/";
    } else {
      dirloc = (await getApplicationDocumentsDirectory()).path;
    }
    String dir = (await getExternalStorageDirectory())!.path;
    String file = "$dir";

    File f = await (File(file + "/filename.csv").create());
    print(f.toString());

    try {
      await dio.download(f.toString(), dirloc + ".jpg",
          onReceiveProgress: (receivedBytes, totalBytes) {
        setState(() {
          downloading = true;
          progress =
              ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Reports",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          centerTitle: false,
          // actions: [
          //   RaisedButton(
          //     onPressed: () {
          //       generateCsv();
          //     },
          //     color: Colors.blue,
          //     child: Text("Download Reports"),
          //   )
          // ],
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Responsive(
                        mobile: Column(children: [
                          Card(
                            elevation: 8.0,
                            child: Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                height: 150,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Number of Sales People Added",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Divider(
                                        thickness: 1,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            // ignore: prefer_const_literals_to_create_immutables
                                            children: [
                                              Text("20",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("Month to Date",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("45",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("Last Month",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("100",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("All Time",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          ),
                          Card(
                            elevation: 8.0,
                            child: Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                height: 150,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Total Cumulative Sales People",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Divider(
                                        thickness: 1,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            // ignore: prefer_const_literals_to_create_immutables
                                            children: [
                                              Text("20",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("As On Today",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("45",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("At Same Day Last Month",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          ),
                          Card(
                            elevation: 8.0,
                            child: Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                height: 150,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Number of Block Leads",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Divider(
                                        thickness: 1,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("20",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("As on Today",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("45",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("At Same Day Last Month",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          ),
                          Card(
                            elevation: 8.0,
                            child: Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                height: 150,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Number of District Leads",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Divider(
                                        thickness: 1,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("20",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("As on Today",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("45",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("At Same Day Last Month",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          ),
                          Card(
                            elevation: 8.0,
                            child: Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                height: 150,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Number of Cluster Heads",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Divider(
                                        thickness: 1,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("20",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("As on Today",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("45",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("At Same Day Last Month",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          ),
                          Card(
                            elevation: 8.0,
                            child: Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                height: 150,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Number of State Heads",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Divider(
                                        thickness: 1,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("20",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("As on Today",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("45",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("At Same Day Last Month",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          ),
                          Card(
                            elevation: 8.0,
                            child: Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                height: 150,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("User Edits Done",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Divider(
                                        thickness: 1,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("20",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("As on Today",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("45",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("Last Month",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("100",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("All Time",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          ),
                          Card(
                            elevation: 8.0,
                            child: Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                height: 150,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Number of State Heads",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Divider(
                                        thickness: 1,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("20",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("As on Today",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("45",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(" Last Month",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("100",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("All Time",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          )
                        ]),
                        tablet: Column(children: [
                          Card(
                            elevation: 8.0,
                            child: Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                height: 150,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Number of Sales People Added",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Divider(
                                        thickness: 1,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            // ignore: prefer_const_literals_to_create_immutables
                                            children: [
                                              Text("20",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("Month to Date",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("45",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("Last Month",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("100",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("All Time",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          ),
                          Card(
                            elevation: 8.0,
                            child: Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                height: 150,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Total Cumulative Sales People",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Divider(
                                        thickness: 1,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            // ignore: prefer_const_literals_to_create_immutables
                                            children: [
                                              Text("20",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("As On Today",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("45",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("At Same Day Last Month",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          ),
                          Card(
                            elevation: 8.0,
                            child: Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                height: 150,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Number of Block Leads",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Divider(
                                        thickness: 1,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("20",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("As on Today",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("45",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("At Same Day Last Month",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          ),
                          Card(
                            elevation: 8.0,
                            child: Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                height: 150,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Number of District Leads",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Divider(
                                        thickness: 1,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("20",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("As on Today",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("45",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("At Same Day Last Month",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          ),
                          Card(
                            elevation: 8.0,
                            child: Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                height: 150,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Number of Cluster Heads",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Divider(
                                        thickness: 1,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("20",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("As on Today",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("45",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("At Same Day Last Month",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          ),
                          Card(
                            elevation: 8.0,
                            child: Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                height: 150,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Number of State Heads",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Divider(
                                        thickness: 1,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("20",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("As on Today",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("45",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("At Same Day Last Month",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          ),
                          Card(
                            elevation: 8.0,
                            child: Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                height: 150,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("User Edits Done",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Divider(
                                        thickness: 1,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("20",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("As on Today",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("45",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("Last Month",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("100",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("All Time",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          ),
                          Card(
                            elevation: 8.0,
                            child: Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                height: 150,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Number of State Heads",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      Divider(
                                        thickness: 1,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("20",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("As on Today",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("45",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(" Last Month",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("100",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("All Time",
                                                  style: TextStyle(
                                                      color: Colors.grey))
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          )
                        ]),
                        desktop: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Card(
                                  elevation: 8.0,
                                  child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      height: 150,
                                      width: 300,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Number of Sales People Added",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Divider(
                                              thickness: 1,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  // ignore: prefer_const_literals_to_create_immutables
                                                  children: [
                                                    Text("20",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text("Month to Date",
                                                        style: TextStyle(
                                                            color: Colors.grey))
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("45",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text("Last Month",
                                                        style: TextStyle(
                                                            color: Colors.grey))
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("100",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text("All Time",
                                                        style: TextStyle(
                                                            color: Colors.grey))
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                                Card(
                                  elevation: 8.0,
                                  child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      height: 150,
                                      width: 300,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "Total Cumulative Sales People",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Divider(
                                              thickness: 1,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  // ignore: prefer_const_literals_to_create_immutables
                                                  children: [
                                                    Text("20",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text("As On Today",
                                                        style: TextStyle(
                                                            color: Colors.grey))
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("45",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                        "At Same Day Last Month",
                                                        style: TextStyle(
                                                            color: Colors.grey))
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                                Card(
                                  elevation: 8.0,
                                  child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      height: 150,
                                      width: 300,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "Total Cumulative Sales People",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Divider(
                                              thickness: 1,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  // ignore: prefer_const_literals_to_create_immutables
                                                  children: [
                                                    Text("20",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text("As On Today",
                                                        style: TextStyle(
                                                            color: Colors.grey))
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("45",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                        "At Same Day Last Month",
                                                        style: TextStyle(
                                                            color: Colors.grey))
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                                Card(
                                  elevation: 8.0,
                                  child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      height: 150,
                                      width: 300,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "Total Cumulative Sales People",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Divider(
                                              thickness: 1,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  // ignore: prefer_const_literals_to_create_immutables
                                                  children: [
                                                    Text("20",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text("As On Today",
                                                        style: TextStyle(
                                                            color: Colors.grey))
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("45",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                        "At Same Day Last Month",
                                                        style: TextStyle(
                                                            color: Colors.grey))
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Card(
                                  elevation: 8.0,
                                  child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      height: 150,
                                      width: 300,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Number of Sales People Added",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Divider(
                                              thickness: 1,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  // ignore: prefer_const_literals_to_create_immutables
                                                  children: [
                                                    Text("20",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text("Month to Date",
                                                        style: TextStyle(
                                                            color: Colors.grey))
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("45",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text("Last Month",
                                                        style: TextStyle(
                                                            color: Colors.grey))
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("100",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text("All Time",
                                                        style: TextStyle(
                                                            color: Colors.grey))
                                                  ],
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                                Card(
                                  elevation: 8.0,
                                  child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      height: 150,
                                      width: 300,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Number of State Heads",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Divider(
                                              thickness: 1,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("20",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text("As on Today",
                                                        style: TextStyle(
                                                            color: Colors.grey))
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("45",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                        "At Same Day Last Month",
                                                        style: TextStyle(
                                                            color: Colors.grey))
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                                Card(
                                  elevation: 8.0,
                                  child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      height: 150,
                                      width: 300,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("User Edits Done",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Divider(
                                              thickness: 1,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("20",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text("As on Today",
                                                        style: TextStyle(
                                                            color: Colors.grey))
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("45",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text("Last Month",
                                                        style: TextStyle(
                                                            color: Colors.grey))
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("100",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text("All Time",
                                                        style: TextStyle(
                                                            color: Colors.grey))
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                                Card(
                                  elevation: 8.0,
                                  child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      height: 150,
                                      width: 300,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Number of State Heads",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Divider(
                                              thickness: 1,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("20",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text("As on Today",
                                                        style: TextStyle(
                                                            color: Colors.grey))
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("45",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(" Last Month",
                                                        style: TextStyle(
                                                            color: Colors.grey))
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("100",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text("All Time",
                                                        style: TextStyle(
                                                            color: Colors.grey))
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                )
                              ],
                            )
                          ],
                        ))
                  ],
                ))),
        floatingActionButton: kIsWeb
            ? FloatingActionButton(
                child: FaIcon(FontAwesomeIcons.fileCsv),
                onPressed: () => generateCsv(),
              )
            : FloatingActionButton(
                child: Icon(Icons.picture_as_pdf),
                onPressed: () {
                  // _newpdf();
                  _createPdf();
                  // _testPdf();
                  // _gridviewPdf();
                }
                // onPressed: () async {
                //   final pdfFile = await PdfApi.test();
                //   // final pdfFile = await PdfApi.();
                //   PdfApi.openFile1(pdfFile);
                // },
                ));
  }

  // Future<void> _testPdf() async {
  // final pdf = pw.Document();

  // pdf.addPage(
  //   pw.Page(
  //     build: (pw.Context context) => pw.Center(
  //       child: pw.Text('Hello World!'),
  //     ),
  //   ),
  // );
  //   final file = File('example.pdf');
  //   await file.writeAsBytes(await pdf.save());
  //   print(file.path);
  //   OpenFile.open(file.path);

  //   // saveAndLaunchFile(bytes, "Output.pdf");
  // }

//   Future<void> _newpdf() async {
// //Create a new pdf document
//     PdfDocument document = PdfDocument();

// //Add the pages to the document
//     // for (int i = 1; i <= 1; i++) {
//     //   document.pages.add().graphics.drawString(
//     //       'page$i', PdfStandardFont(PdfFontFamily.timesRoman, 11),
//     //       bounds: Rect.fromLTWH(250, 0, 615, 100));
//     // }

// //Create the header with specific bounds
//     PdfPageTemplateElement header = PdfPageTemplateElement(
//         Rect.fromLTWH(0, 0, document.pages[0].getClientSize().width, 300));

// //Create the date and time field
//     PdfDateTimeField dateAndTimeField = PdfDateTimeField(
//         font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
//         brush: PdfSolidBrush(PdfColor(0, 0, 0)));
//     dateAndTimeField.date = DateTime(2020, 2, 10, 13, 13, 13, 13, 13);
//     dateAndTimeField.dateFormatString = 'E, MM.dd.yyyy';

// //Create the composite field with date field
//     PdfCompositeField compositefields = PdfCompositeField(
//         font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
//         brush: PdfSolidBrush(PdfColor(0, 0, 0)),
//         text: '{0}      Header',
//         fields: <PdfAutomaticField>[dateAndTimeField]);

// //Add composite field in header
//     compositefields.draw(header.graphics,
//         Offset(0, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 11).height));

// //Add the header at top of the document
//     document.template.top = header;

// //Create the footer with specific bounds
//     PdfPageTemplateElement footer = PdfPageTemplateElement(
//         Rect.fromLTWH(0, 0, document.pages[0].getClientSize().width, 50));

// //Create the page number field
//     PdfPageNumberField pageNumber = PdfPageNumberField(
//         font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
//         brush: PdfSolidBrush(PdfColor(0, 0, 0)));

// //Sets the number style for page number
//     pageNumber.numberStyle = PdfNumberStyle.upperRoman;

// //Create the page count field
//     PdfPageCountField count = PdfPageCountField(
//         font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
//         brush: PdfSolidBrush(PdfColor(0, 0, 0)));

// //set the number style for page count
//     count.numberStyle = PdfNumberStyle.upperRoman;

// //Create the date and time field
//     PdfDateTimeField dateTimeField = PdfDateTimeField(
//         font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
//         brush: PdfSolidBrush(PdfColor(0, 0, 0)));

// //Sets the date and time
//     dateTimeField.date = DateTime(2020, 2, 10, 13, 13, 13, 13, 13);

// //Sets the date and time format
//     dateTimeField.dateFormatString = 'hh\':\'mm\':\'ss';

// //Create the composite field with page number page count
//     PdfCompositeField compositeField = PdfCompositeField(
//         font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
//         brush: PdfSolidBrush(PdfColor(0, 0, 0)),
//         text: 'Page {0} of {1}, Time:{2}',
//         fields: <PdfAutomaticField>[pageNumber, count, dateTimeField]);
//     compositeField.bounds = footer.bounds;

// //Add the composite field in footer
//     compositeField.draw(footer.graphics,
//         Offset(290, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 19).height));

// //Add the footer at the bottom of the document
//     document.template.bottom = footer;

// //Save the PDF document
//     File('headers.pdf').writeAsBytes(document.save());

// //Dispose document
//     document.dispose();
//   }
  Future<void> _gridviewPdf() async {
    // Create a new PDF document.
    final PdfDocument document = PdfDocument();
// Add a new page to the document.
    final PdfPage page = document.pages.add();
// Create a PDF grid class to add tables.
    final PdfGrid grid = PdfGrid();
    //Create a PDF page template and add header content.
    final PdfPageTemplateElement headerTemplate =
        PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 50));
//Draw text in the header.
    headerTemplate.graphics.drawString('Orient Technology',
        PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold),
        bounds: const Rect.fromLTWH(0, 15, 200, 20));
//Add the header element to the document.
    document.template.top = headerTemplate;
//Create a PDF page template and add footer content.
    final PdfPageTemplateElement footerTemplate =
        PdfPageTemplateElement(const Rect.fromLTWH(0, 0, 515, 50));
//Draw text in the footer.
    footerTemplate.graphics.drawString(
        'This is page footer', PdfStandardFont(PdfFontFamily.helvetica, 12),
        bounds: const Rect.fromLTWH(0, 15, 200, 20));
//Set footer in the document.
    document.template.bottom = footerTemplate;
// Specify the grid column count.
    grid.columns.add(count: 3);
// Add a grid header row.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'Customer ID';
    headerRow.cells[1].value = 'Contact Name';
    headerRow.cells[2].value = 'Country';
// Set header font.
    headerRow.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
// Add rows to the grid.
    PdfGridRow row = grid.rows.add();
    row.cells[0].value = 'ALFKI';
    row.cells[1].value = 'Maria Anders';
    row.cells[2].value = 'Germany';
// Add next row.
    row = grid.rows.add();
    row.cells[0].value = 'ANATR';
    row.cells[1].value = 'Ana Trujillo';
    row.cells[2].value = 'Mexico';
// Add next row.
    row = grid.rows.add();
    row.cells[0].value = 'ANTON';
    row.cells[1].value = 'Antonio Mereno';
    row.cells[2].value = 'Mexico';
// Set grid format.
    grid.style.cellPadding = PdfPaddings(left: 5, top: 5);
// Draw table in the PDF page.
    grid.draw(
        page: page,
        bounds: Rect.fromLTWH(
            0, 0, page.getClientSize().width, page.getClientSize().height));
    final List<int> bytes = document.save();

    //document disposed to release all resources used by it
    document.dispose();

    saveAndLaunchFile(bytes, "Output.pdf");
  }

  Future<void> _createPdf() async {
    //Defining a pdf object
    PdfDocument document = PdfDocument();

    //to create pdf page within document and creating an object of it
    PdfPage page = document.pages.add();

// //Restore the graphics.
//     // graphics.restore();
//     PdfGraphics graphics = document.pages.add().graphics;
// //Set clip to the graphics to make a circular shape.
//     graphics.save(); // Save the graphics before adding the clip.
// //Create path and set clip.
//     graphics.setClip(
//         path: PdfPath()..addEllipse(Rect.fromLTWH(107, 50, 300, 300)));
// //Draw an image.
//     graphics.drawImage(PdfBitmap(await _readImageData('1.png')),
//         Rect.fromLTWH(107, 50, 300, 300));
    //adding text to pdf
    page.graphics.drawString("Orient Technology",
        PdfStandardFont(PdfFontFamily.timesRoman, 35, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(120, 0, 0, 50),
        brush: PdfBrushes.black,
        // pen: PdfPens.blue,
        format: PdfStringFormat(alignment: PdfTextAlignment.left));
    // page.graphics.drawRectangle(
    //     pen: PdfPen(PdfColor(255, 0, 0)),
    //     bounds: Rect.fromLTWH(
    //         0, 0, page.getClientSize().width, page.getClientSize().height));
    // for (int i = 1; i <= 5; i++) {
    //   PdfGrid grid = PdfGrid();
    //   grid.style = PdfGridStyle(
    //       font: PdfStandardFont(PdfFontFamily.helvetica, 20),
    //       cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));

    //   grid.columns.add(count: i);
    //   grid.headers.add(i);
    //   grid.draw(
    //       //to add table in 2nd page of pdf
    //       page: page,
    //       bounds: const Rect.fromLTWH(0, 200, 0, 0));
    //   // document.pages.add().graphics.drawString(
    //   //     'page$i', PdfStandardFont(PdfFontFamily.symbol, 11),
    //   //     bounds: Rect.fromLTWH(250, 0, 615, 100));
    // }
    PdfBorders border = PdfBorders(
        left: PdfPen(PdfColor(240, 0, 0), width: 2),
        top: PdfPen(PdfColor(0, 240, 0), width: 3),
        bottom: PdfPen(PdfColor(0, 0, 240), width: 4),
        right: PdfPen(PdfColor(240, 100, 240), width: 5));

    //adding image to pdf
    page.graphics.drawImage(
        PdfBitmap(await _readImageData('2.png')),
        //detail about area to draw image
        Rect.fromLTWH(400, 0, 100, 50));

    //adding table
    PdfGrid grid = PdfGrid();
    grid.style = PdfGridStyle(
        font: PdfStandardFont(PdfFontFamily.helvetica, 3),
        // cellSpacing: 1.0,
        cellPadding: PdfPaddings(left: 10, right: 10, top: 10, bottom: 10));

    grid.columns.add(count: 20);
    grid.headers.add(1);

    PdfGridRow header = grid.headers[0];
    header.cells[0].value = "TARGET ID";
    header.cells[1].value = "SALES\nPERSON";
    header.cells[2].value = "EMAIL";
    header.cells[3].value = "Class";
    header.cells[4].value = "Class";
    header.cells[5].value = "Class";
    header.cells[6].value = "Class";
    header.cells[7].value = "Class";
    header.cells[8].value = "Class";
    header.cells[9].value = "Class";
    header.cells[10].value = "Roll no";
    header.cells[11].value = "Name";
    header.cells[12].value = "Class";
    header.cells[13].value = "Class";
    header.cells[14].value = "Class";
    header.cells[15].value = "Class";
    header.cells[16].value = "Class";
    header.cells[17].value = "Class";
    header.cells[18].value = "Class";
    header.cells[19].value = "Class";

    PdfGridRow row = grid.rows.add();

    row.cells[0].value = "1";
    row.cells[1].value = "Arya";

    row.cells[2].value = "6";
    row.cells[3].value = "6";
    row.cells[4].value = "6";
    row.cells[5].value = "6";
    row.cells[6].value = "6";
    row.cells[7].value = "6";
    row.cells[8].value = "6";
    row.cells[9].value = "6";
    row.cells[10].value = "1";
    row.cells[11].value = "Arya";
    row.cells[12].value = "6";
    row.cells[13].value = "6";
    row.cells[14].value = "6";
    row.cells[15].value = "6";
    row.cells[16].value = "6";
    row.cells[17].value = "6";
    row.cells[18].value = "6";
    row.cells[19].value = "6";

    row.style = PdfGridRowStyle(
        backgroundBrush: PdfBrushes.dimGray,
        // textPen: PdfPens.lightGoldenrodYellow,
        textBrush: PdfBrushes.white,
        font: PdfStandardFont(PdfFontFamily.helvetica, 3));

//Set the row height

    row = grid.rows.add();
    row.cells[0].value = "2";
    row.cells[1].value = "John";
    row.cells[2].value = "9";
    row.cells[3].value = "9";
    row.cells[4].value = "9";
    row.cells[5].value = "9";
    row.cells[6].value = "9";
    row.cells[7].value = "9";
    row.cells[8].value = "9";
    row.cells[9].value = "9";
    row.cells[10].value = "2";
    row.cells[11].value = "John";
    row.cells[12].value = "9";
    row.cells[13].value = "9";
    row.cells[14].value = "9";
    row.cells[15].value = "9";
    row.cells[16].value = "9";
    row.cells[17].value = "9";
    row.cells[18].value = "9";
    row.cells[19].value = "9";
    row.style = PdfGridRowStyle(
        backgroundBrush: PdfBrushes.dimGray,
        // textPen: PdfPens.lightGoldenrodYellow,
        textBrush: PdfBrushes.white,
        font: PdfStandardFont(PdfFontFamily.helvetica, 3));

    row = grid.rows.add();
    row.cells[0].value = "3";
    row.cells[1].value = "Tony";
    row.cells[2].value = "12";
    row.cells[3].value = "12";
    row.cells[4].value = "12";
    row.cells[5].value = "12";
    row.cells[6].value = "12";
    row.cells[7].value = "12";
    row.cells[8].value = "12";
    row.cells[9].value = "12";
    row.cells[10].value = "3";
    row.cells[11].value = "Tony";
    row.cells[12].value = "12";
    row.cells[13].value = "12";
    row.cells[14].value = "12";
    row.cells[15].value = "12";
    row.cells[16].value = "12";
    row.cells[17].value = "12";
    row.cells[18].value = "12";
    row.cells[19].value = "12";
    row.style = PdfGridRowStyle(
        backgroundBrush: PdfBrushes.dimGray,
        // textPen: PdfPens.lightGoldenrodYellow,
        textBrush: PdfBrushes.white,
        font: PdfStandardFont(PdfFontFamily.helvetica, 3));

    grid.columns[0].width = 38;
    grid.columns[1].width = 30;
    PdfStringFormat format = PdfStringFormat(
        alignment: PdfTextAlignment.left,
        lineAlignment: PdfVerticalAlignment.bottom,
        wordSpacing: 100);
    grid.columns[0].format = format;
    grid.columns[1].format = format;
    grid.columns[2].format = format;
    grid.columns[3].format = format;
    grid.columns[4].format = format;
    grid.columns[5].format = format;
    grid.columns[6].format = format;
    grid.columns[7].format = format;
    grid.columns[8].format = format;
    grid.columns[9].format = format;
    grid.columns[2].width = 30;
    grid.columns[3].width = 30;
    grid.columns[4].width = 30;
    grid.columns[5].width = 30;
    grid.columns[6].width = 30;
    grid.columns[7].width = 30;
    grid.columns[8].width = 30;
    grid.columns[9].width = 30;
    grid.columns[10].width = 30;
    grid.columns[11].width = 30;
    grid.columns[12].width = 30;
    grid.columns[13].width = 30;
    grid.columns[14].width = 30;
    grid.columns[15].width = 30;
    grid.columns[16].width = 30;
    grid.columns[17].width = 30;
    grid.columns[18].width = 30;
    grid.columns[19].width = 30;
    PdfLayoutFormat formatt = PdfLayoutFormat(
        breakType: PdfLayoutBreakType.fitElement,
        layoutType: PdfLayoutType.paginate);
    //Document security
    PdfSecurity security = document.security;

//Specifies encryption algorithm and key size
    security.algorithm = PdfEncryptionAlgorithm.rc4x128Bit;

//Set user password
    security.userPassword = '1234';

    grid.draw(
        //to add table in 2nd page of pdf
        page: page,
        // format: PdfLayoutFormat.fromFormat(baseFormat),
        format: formatt,
        bounds: const Rect.fromLTWH(0, 60, 0, 0));

    final headers = ["Report", "As On Today", "Last Month", "All Time"];
    final users = [
      User(
          report: "Number of Sales People Added",
          today: 26,
          lastmonth: 45,
          allTime: 100),
      User(
          report: "Total Cumulative Sales People",
          today: 26,
          lastmonth: 45,
          allTime: 100),
      User(
          report: "Number of Block Leads",
          today: 26,
          lastmonth: 45,
          allTime: 100),
      User(
          report: "Number of District Leads",
          today: 26,
          lastmonth: 45,
          allTime: 100),
      User(report: "User Edits Done", today: 26, lastmonth: 45, allTime: 100),
      User(
          report: "Number of State Heads",
          today: 26,
          lastmonth: 45,
          allTime: 100),
    ];
    List dataList = [];
    dataList.add(users);
    final data = users
        .map((user) => [user.report, user.today, user.lastmonth, user.allTime])
        .toList();
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
        build: (context) => pw.Table.fromTextArray(
              headers: headers,
              data: data,
            )));

    //to save pdf we need to define it as bytes or list of int
    final List<int> bytes = document.save();

    //document disposed to release all resources used by it
    document.dispose();

    saveAndLaunchFile(bytes, "Output.pdf");
  }
}

Future<void> saveAndLaunchFileweb(List<int> bytes, String fileName) async {
  html.AnchorElement(
      href:
          "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
    ..setAttribute("download", fileName)
    ..click();
}

Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  final path = (await getExternalStorageDirectory())!.path;
  final file = File('$path/$fileName');
  await file.writeAsBytes(bytes, flush: true);
  OpenFile.open(file.path);
}

Future<void> saveAndLaunchFile1(List<int> bytes, String fileName) async {
  final path = (await getExternalStorageDirectory())!.path;
  final file = File('$path/$fileName');
  await file.writeAsBytes(bytes, flush: true);
  OpenFile.open(file.path);
}

generateCsv() async {
  print("CSV DOWNLOAD PRESSED");
  List<dynamic> associateList = [
    {
      "Report": "Number of Sales People Added",
      "As On Today": "20",
      "Last Month": "45",
      "All Time": "100"
    },
    {
      "Report": "Total Cumulative Sales People",
      "As On Today": "20",
      "Last Month": "45",
      "All Time": "100"
    },
    {
      "Report": "Number of Block Leads",
      "As On Today": "20",
      "Last Month": "45",
      "All Time": "100"
    },
    {
      "Report": "Number of District Leads",
      "As On Today": "20",
      "Last Month": "45",
      "All Time": "100"
    },
    {
      "Report": "User Edits Done",
      "As On Today": "20",
      "Last Month": "45",
      "All Time": "100"
    },
    {
      "Report": "Number of State Heads",
      "As On Today": "20",
      "Last Month": "45",
      "All Time": "100"
    }
  ];

  List<List<dynamic>> rows = [];

  List<dynamic> row = [];
  row.add("Report");
  row.add("As On Today");
  row.add("Last Month");
  row.add("All Time");
  rows.add(row);
  for (int i = 0; i < associateList.length; i++) {
    List<dynamic> row = [];
    row.add(associateList[i]["Report"]);
    row.add(associateList[i]["As On Today"]);
    row.add(associateList[i]["Last Month"]);
    row.add(associateList[i]["All Time"]);
    rows.add(row);
  }
  String csvData = ListToCsvConverter().convert(rows);

  if (kIsWeb) {
    print("WEB REGISTER");
    final byte = utf8.encode(csvData);
    final blob = html.Blob([byte]);

    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement("a") as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'item_export.csv';
    html.document.body!.children.add(anchor);
    anchor.click();
    html.Url.revokeObjectUrl(url);
  } else if (Platform.isAndroid) {
    print("ANDROID DOWNLOAD PRESSED");
    // showDialog(
    //   context: context,
    //   builder: (context) => DownloadingDialog(),
    // );
    // final appstorage = await getApplicationDocumentsDirectory();
    // final file = File('${appstorage.path}/filename.csv');

    // final response = await Dio().get(appstorage.path,
    //     options: Options(
    //         responseType: ResponseType.bytes,
    //         followRedirects: false,
    //         receiveTimeout: 0));
    // final raf = file.openSync(mode: FileMode.write);
    // raf.writeFromSync(response.data);
    // await raf.close();

    // download(file.toString(), "filename.csv");

    String dir = (await getExternalStorageDirectory())!.path;
    String file = "$dir";

    File f = await (File(file + "/filename.csv").create());
    print(f.toString());
    rootBundle.loadString(f.toString());
    await f.writeAsString(csvData);

    // await f.open(mode: FileMode.read);

    // Directory appDocDir = await getTemporaryDirectory();
    // String appDocPath = appDocDir.path;
    // final File file = await (File('$appDocPath/item_export.csv').create());
    // await file.writeAsString(csvData);
    // print(appDocDir);
    // print(csvData);

    // Directory generalDownloadDir = Directory('storage/emulated.0/Download');
    // final File file =
    //     await (File('${generalDownloadDir.path}/item_export.csv').create());
    // file.writeAsString(csvData);
  }
}

Future<Uint8List> _readImageData(String name) async {
  //to load image rootBundle is used

  final data = await rootBundle.load('assets/$name');

  //return image file as Uint8List type
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}
