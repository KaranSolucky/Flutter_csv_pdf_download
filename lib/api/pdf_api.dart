import 'dart:io';
import 'dart:ui';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

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
  static Future<File> test() async {
    final document = PdfDocument();

//Add the pages to the document
    for (int i = 1; i <= 1; i++) {
      document.pages.add().graphics.drawString(
          'page$i', PdfStandardFont(PdfFontFamily.symbol, 11),
          bounds: Rect.fromLTWH(250, 0, 615, 100));
    }

//Create the header with specific bounds
    PdfPageTemplateElement header = PdfPageTemplateElement(
        Rect.fromLTWH(0, 0, document.pages[0].getClientSize().width, 300));

//Create the date and time field
    PdfDateTimeField dateAndTimeField = PdfDateTimeField(
        font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)));
    dateAndTimeField.date = DateTime(2020, 2, 10, 13, 13, 13, 13, 13);
    dateAndTimeField.dateFormatString = 'E, MM.dd.yyyy';

//Create the composite field with date field
    PdfCompositeField compositefields = PdfCompositeField(
        font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        text: 'Orient Technology',
        fields: <PdfAutomaticField>[dateAndTimeField]);
//Add composite field in header
    compositefields.draw(header.graphics,
        Offset(0, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 11).height));

//Add the header at top of the document
    document.template.top = header;

//Create the footer with specific bounds
    PdfPageTemplateElement footer = PdfPageTemplateElement(
        Rect.fromLTWH(0, 0, document.pages[0].getClientSize().width, 50));

//Create the page number field
    PdfPageNumberField pageNumber = PdfPageNumberField(
        font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)));

//Sets the number style for page number
    // pageNumber.numberStyle = PdfNumberStyle.upperRoman;

//Create the page count field
    PdfPageCountField count = PdfPageCountField(
        font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)));

//set the number style for page count
    count.numberStyle = PdfNumberStyle.upperRoman;

//Create the date and time field
    PdfDateTimeField dateTimeField = PdfDateTimeField(
        font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)));

//Sets the date and time
    dateTimeField.date = DateTime(2020, 2, 10, 13, 13, 13, 13, 13);

//Sets the date and time format
    dateTimeField.dateFormatString = 'hh\':\'mm\':\'ss';

//Create the composite field with page number page count
    PdfCompositeField compositeField = PdfCompositeField(
        font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        text: 'Page {0} of {1}, Time:{2}',
        fields: <PdfAutomaticField>[pageNumber, count, dateTimeField]);
    compositeField.bounds = footer.bounds;

//Add the composite field in footer
    compositeField.draw(footer.graphics,
        Offset(290, 50 - PdfStandardFont(PdfFontFamily.timesRoman, 19).height));
    // compositeField.draw( Pdf);

    // page.graphics.drawImage(
    //     PdfBitmap(await _readImageData('1.png')),
    //     //detail about area to draw image
    //     Rect.fromLTWH(0, 20, 30, 50));
//Add the footer at the bottom of the document
    document.template.bottom = footer;

//Save the PDF document

    File('headers.pdf').writeAsBytes(document.save());
    return saveDocument1(name: 'headers.pdf', document: document);
  }
  // static Future<File> generateTable() async {
  //   final pdf = Document();
  // final headers = ["Report", "As On Today", "Last Month", "All Time"];
  // final users = [
  //   User(
  //       report: "Number of Sales People Added",
  //       today: 26,
  //       lastmonth: 45,
  //       allTime: 100),
  //   User(
  //       report: "Total Cumulative Sales People",
  //       today: 26,
  //       lastmonth: 45,
  //       allTime: 100),
  //   User(
  //       report: "Number of Block Leads",
  //       today: 26,
  //       lastmonth: 45,
  //       allTime: 100),
  //   User(
  //       report: "Number of District Leads",
  //       today: 26,
  //       lastmonth: 45,
  //       allTime: 100),
  //   User(report: "User Edits Done", today: 26, lastmonth: 45, allTime: 100),
  //   User(
  //       report: "Number of State Heads",
  //       today: 26,
  //       lastmonth: 45,
  //       allTime: 100),
  // ];
  // List dataList = [];
  // dataList.add(users);
  // final data = users
  //     .map((user) => [user.report, user.today, user.lastmonth, user.allTime])
  //     .toList();

  // pdf.addPage(Page(
  //     build: (context) => Table.fromTextArray(
  //           headers: headers,
  //           data: data,
  //         )));

  //   return saveDocument(name: "test.pdf", pdf: pdf);
  // }

  static Future<File> saveDocument(
      {required String name, required Document pdf}) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future<File> saveDocument1(
      {required String name, required PdfDocument document}) async {
    final bytes = document.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }

  static Future openFile1(File file) async {
    final urll = file.path;
    await OpenFile.open(urll);
  }
}
