import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class QRCodePlayground extends StatefulWidget {
  @override
  _QRCodePlaygroundState createState() => _QRCodePlaygroundState();
}

class _QRCodePlaygroundState extends State<QRCodePlayground> {
  final TextEditingController tfController = TextEditingController();
  static final scrKey = GlobalKey();

  _shareQrCode() async {
    final RenderRepaintBoundary boundary =
        scrKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;

    final directory = (await getApplicationDocumentsDirectory()).path;
    boundary.toImage(pixelRatio: 5).then((var image) async {
      try {
        String fileName = DateTime.now().microsecondsSinceEpoch.toString();
        final imagePath = await File('$directory/$fileName.png').create();

        ByteData? byteData =
            await image.toByteData(format: ImageByteFormat.png);
        await imagePath.writeAsBytes(byteData!.buffer.asUint8List());
        Share.shareFiles([imagePath.path], text: 'lkmlklkmlkm');
      } catch (_) {}
    }).catchError((onError) {
      debugPrint('Error --->> $onError');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            tfController.text.isEmpty
                ? SizedBox.shrink()
                : RepaintBoundary(
                    key: scrKey, child: QrImage(data: tfController.text)),
            SizedBox(height: 20),
            TextField(
              controller: tfController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue))),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Generate QR Code'),
              onPressed: () => setState(() {}),
            ),
            ElevatedButton(
              onPressed: () => _shareQrCode(),
              child: Text('Share QR code'),
            ),
          ],
        ),
      ),
    );
  }
}
