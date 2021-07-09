import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

class OpenPDF extends StatefulWidget {
  @override
  _OpenPDFState createState() => _OpenPDFState();
}

class _OpenPDFState extends State<OpenPDF> {
  late PDFDocument document;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromURL("http://www.africau.edu/images/default/sample.pdf");

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        child: Center(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : PDFViewer(
            document: document,
            zoomSteps: 1,
            // uncomment below line to preload all pages
            lazyLoad: false,
            // uncomment below line to scroll vertically
            scrollDirection: Axis.vertical,

          ),
        )
      ),
    ));
  }
}
