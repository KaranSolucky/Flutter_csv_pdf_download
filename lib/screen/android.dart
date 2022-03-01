import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';

Future<void> saveAndLaunchFile(List<int> bytes, String filename) async {
  //variable to store path from directory
  final path = (await getExternalStorageDirectory())!.path;

  //using file class set path and file name
  final file = File('$path/$filename');

  //write bytes to file
  await file.writeAsBytes(bytes, flush: true);

  //call open file method
  OpenFile.open('$path/$filename');
}
