import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:qr_scanner/openpdf.dart';

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_scanner/qrmain.dart';


void main(){
  runApp(GetMaterialApp(home: PdfMain()));
}


class PdfMain extends StatefulWidget {
  @override
  _PdfMainState createState() => _PdfMainState();
}

class _PdfMainState extends State<PdfMain> {

  final Dio dio = Dio();
  bool pdfLoading = false;
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(title:Text("Pdf and Qrcode example"),),
      body: Container(
        margin: EdgeInsets.only(top: 40),
        height: double.infinity,
        child: Center(
          child: Column(
            children: [


              openPDFButton(),

              SizedBox(height: 100,),

              downloadPDFButton(),

              SizedBox(height: 10,),

              pdfLoading ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: LinearProgressIndicator(
                  minHeight: 10,
                  value: progress,
                ),
              ):Container(),



              SizedBox(height: 100,),
           openQRCode(),





            ],
          ),
        ),
      ),
    ));
  }

  openPDFButton(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      child: Material(  //Wrap with Material
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),
        elevation: 18.0,
        color: Color(0xFF801E48),
        clipBehavior: Clip.antiAlias, // Add This
        child: MaterialButton(
          minWidth: 200.0,
          height: 35,
          color: Color(0xFF801E48),
          child: new Text('Open PDF',
              style: new TextStyle(fontSize: 16.0, color: Colors.white)),
          onPressed: () {

            Get.to(OpenPDF());
//         
          },
        ),
      ),
    );
  }
  
  
  downloadPDFButton(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      child: Material(  //Wrap with Material
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),
        elevation: 18.0,
        color: Color(0xFF801E48),
        clipBehavior: Clip.antiAlias, // Add This
        child: MaterialButton(
          minWidth: 200.0,
          height: 35,
          color: Color(0xFF801E48),
          child: new Text('Download PDF',
              style: new TextStyle(fontSize: 16.0, color: Colors.white)),
          onPressed: () {
//
          downloadFile();
          },
        ),
      ),
    );
  }

  openQRCode(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      child: Material(  //Wrap with Material
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),
        elevation: 18.0,
        color: Color(0xFF801E48),
        clipBehavior: Clip.antiAlias, // Add This
        child: MaterialButton(
          minWidth: 200.0,
          height: 35,
          color: Color(0xFF801E48),
          child: new Text('Open QrCode',
              style: new TextStyle(fontSize: 16.0, color: Colors.white)),
          onPressed: () {
//
       Get.to(QRViewExample());
          },
        ),
      ),
    );
  }


  downloadFile() async {
    setState(() {
      pdfLoading = true;
      progress = 0;
    });
    bool downloaded = await saveVideo(
        "http://www.africau.edu/images/default/sample.pdf",
        "sample "+DateTime.now().toString()+".pdf");
    if (downloaded) {
      print("File Downloaded");
      Fluttertoast.showToast(
        msg: "Pdf Downloaded in Evon Project Folder ",
        toastLength: Toast.LENGTH_SHORT,
      );

    } else {
      print("Problem Downloading File");
      Fluttertoast.showToast(
        msg: "Problem Downloading File",
        toastLength: Toast.LENGTH_SHORT,
      );
    }
    setState(() {
      pdfLoading = false;
    });
  }

  Future<bool> saveVideo(String url, String fileName) async {
    Directory directory;




    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = (await getExternalStorageDirectory())!;
          String newPath = "";
          print(directory);
          List<String> paths = directory.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/Evon Project";
          directory = Directory(newPath);
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }
      File saveFile = File(directory.path + "/$fileName");
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        await dio.download(url, saveFile.path,
            onReceiveProgress: (value1, value2) {
              setState(() {
                progress = value1 / value2;
              });
            });
        if (Platform.isIOS) {
          await ImageGallerySaver.saveFile(saveFile.path,
              isReturnPathOfIOS: true);
        }
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

}
