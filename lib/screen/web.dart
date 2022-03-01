import 'package:universal_html/html.dart';

//for web bytes need to be converted to base64

import 'dart:convert';

Future<void> saveAndLaunchFile(List<int> bytes, String filename) async {
  AnchorElement(
      href:
          "data:application/octet-stream;charset=utf-161e;base64,${base64.encode(bytes)}")
    ..setAttribute("download", filename)
    ..click();
}
