import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
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
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'dart:typed_data'; //to access Uint8List class

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
                // onPressed: () => _createPdf(),
                onPressed: () async {
                  final pdfFile = await PdfApi.generateTable();
                  PdfApi.openFile(pdfFile);
                },
              ));
  }

  Future<void> _createPdf() async {
    //Defining a pdf object
    PdfDocument document = PdfDocument();

    //to create pdf page within document and creating an object of it
    final page = document.pages.add();

    //adding text to pdf
    page.graphics.drawString(
        "Orient Technology", PdfStandardFont(PdfFontFamily.timesRoman, 35));

    //adding image to pdf
    page.graphics.drawImage(
        PdfBitmap(await _readImageData('1.png')),
        //detail about area to draw image
        Rect.fromLTWH(0, 100, 440, 550));

    //adding table
    PdfGrid grid = PdfGrid();
    grid.style = PdfGridStyle(
        font: PdfStandardFont(PdfFontFamily.helvetica, 30),
        cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));

    grid.columns.add(count: 3);
    grid.headers.add(1);

    PdfGridRow header = grid.headers[0];
    header.cells[0].value = "Roll no";
    header.cells[1].value = "Name";
    header.cells[2].value = "Class";

    PdfGridRow row = grid.rows.add();
    row.cells[0].value = "1";
    row.cells[1].value = "Arya";
    row.cells[2].value = "6";

    row = grid.rows.add();
    row.cells[0].value = "2";
    row.cells[1].value = "John";
    row.cells[2].value = "9";

    row = grid.rows.add();
    row.cells[0].value = "3";
    row.cells[1].value = "Tony";
    row.cells[2].value = "12";

    grid.draw(
        //to add table in 2nd page of pdf
        page: document.pages.add(),
        bounds: const Rect.fromLTWH(0, 0, 0, 0));

    //to save pdf we need to define it as bytes or list of int
    List<int> bytes = document.save();

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
