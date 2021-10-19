import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart' as pdf;
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfView extends StatefulWidget {
  final String path;
  const PdfView({
    Key? key,
    required this.path,
  }) : super(key: key);

  @override
  _PdfViewState createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  late Uint8List data;
  late PdfDocument document;
  late pdf.PdfController pdfController;
  int currentPage = 1;
  int pages = 0;

  PdfPageRotateAngle turn(
      {bool left = false, required PdfPageRotateAngle rotation}) {
    PdfPageRotateAngle angle = PdfPageRotateAngle.rotateAngle0;
    if (left) {
      switch (rotation) {
        case PdfPageRotateAngle.rotateAngle0:
          angle = PdfPageRotateAngle.rotateAngle270;
          break;
        case PdfPageRotateAngle.rotateAngle90:
          angle = PdfPageRotateAngle.rotateAngle0;
          break;
        case PdfPageRotateAngle.rotateAngle180:
          angle = PdfPageRotateAngle.rotateAngle90;
          break;
        case PdfPageRotateAngle.rotateAngle270:
          angle = PdfPageRotateAngle.rotateAngle180;
          break;
        default:
          angle = PdfPageRotateAngle.rotateAngle0;
          break;
      }
    } else {
      switch (rotation) {
        case PdfPageRotateAngle.rotateAngle0:
          angle = PdfPageRotateAngle.rotateAngle90;
          break;
        case PdfPageRotateAngle.rotateAngle90:
          angle = PdfPageRotateAngle.rotateAngle180;
          break;
        case PdfPageRotateAngle.rotateAngle180:
          angle = PdfPageRotateAngle.rotateAngle270;
          break;
        case PdfPageRotateAngle.rotateAngle270:
          angle = PdfPageRotateAngle.rotateAngle0;
          break;
        default:
          angle = PdfPageRotateAngle.rotateAngle0;
          break;
      }
    }
    return angle;
  }

  @override
  void initState() {
    data = File(widget.path).readAsBytesSync();
    document = PdfDocument(inputBytes: data);
    pdfController = pdf.PdfController(
      document: pdf.PdfDocument.openData(data),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: pdf.PdfView(
            controller: pdfController,
            documentLoader: const CircularProgressIndicator(),
            pageLoader: const CircularProgressIndicator(),
            onPageChanged: (page) {
              currentPage = page;
              setState(() {});
            },
            onDocumentLoaded: (document) {
              pages = pdfController.pagesCount;
              setState(() {});
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text("$currentPage/$pages"),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                pdfController.previousPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                );
              },
              icon: const Icon(Icons.keyboard_arrow_left),
            ),
            IconButton(
              onPressed: () async {
                PdfPage page = document.pages[pdfController.page - 1];
                PdfPageRotateAngle rotationAngle = page.rotation;
                page.rotation = turn(rotation: rotationAngle, left: true);
                List<int> bytes = document.save();
                data = Uint8List.fromList(bytes);
                pdfController.loadDocument(pdf.PdfDocument.openData(data),
                    initialPage: currentPage);
              },
              icon: const Icon(Icons.rotate_left),
            ),
            IconButton(
              onPressed: () {
                PdfPage page = document.pages[pdfController.page - 1];
                PdfPageRotateAngle rotationAngle = page.rotation;
                page.rotation = turn(rotation: rotationAngle);
                List<int> bytes = document.save();
                data = Uint8List.fromList(bytes);
                pdfController.loadDocument(pdf.PdfDocument.openData(data),
                    initialPage: currentPage);
              },
              icon: const Icon(Icons.rotate_right),
            ),
            IconButton(
              onPressed: () {
                pdfController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                );
              },
              icon: const Icon(Icons.keyboard_arrow_right),
            ),
          ],
        ),
      ],
    );
  }
}