import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_saver/file_saver.dart';
import 'package:permission_handler/permission_handler.dart';

downloadFile(context, statefulMapController, String name) async {
  try {
    var geojson = statefulMapController.toGeoJson();
    List<int> data = utf8.encode(geojson);
    Uint8List bytes = Uint8List.fromList(data);
    MimeType type = MimeType.OTHER;
    if (Platform.isIOS || Platform.isAndroid) {
      bool status = await Permission.storage.isGranted;
      if (!status) await Permission.storage.request();
    }
    await FileSaver.instance.saveFile(name, bytes, "geojson", mimeType: type);
    final snackBar = SnackBar(content: Text('Geojson File Downloaded'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  } catch (e) {
    print(e);
    final esnackBar = SnackBar(content: Text("Error occured"));
    ScaffoldMessenger.of(context).showSnackBar(esnackBar);
  }
}
