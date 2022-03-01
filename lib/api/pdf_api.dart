import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class User {
  final String report;

  final int today;
  final int lastmonth;
  final int allTime;
  const User(
      {required this.report,
      required this.today,
      required this.allTime,
      required this.lastmonth});
}

class PdfApi {
  static Future<File> generateTable() async {
    final pdf = Document();
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
    final data = users
        .map((user) => [user.report, user.today, user.lastmonth, user.allTime])
        .toList();
    pdf.addPage(Page(
        build: (context) => Table.fromTextArray(headers: headers, data: data)));

    return saveDocument(name: "test.pdf", pdf: pdf);
  }

  static Future<File> saveDocument(
      {required String name, required Document pdf}) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}
