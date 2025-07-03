import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfView extends StatefulWidget {
  final Uint8List data;
  const PdfView({
    super.key,
    required this.data,
  });

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  late PdfDocument document;
  final PdfViewerController controller = PdfViewerController();
  Uint8List? data;
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
      }
    }
    return angle;
  }

  @override
  void initState() {
    data = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // controller.jumpToPage(currentPage);
    return Column(
      children: [
        Flexible(
          child: SfPdfViewer.memory(
            data!,
            controller: controller,
            onPageChanged: (page) {
              currentPage = page.newPageNumber;
              setState(() {});
            },
            pageLayoutMode: PdfPageLayoutMode.single,
            onDocumentLoaded: (doc) {
              document = doc.document;
              pages = document.pages.count;
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
                controller.previousPage();
              },
              icon: const Icon(Icons.keyboard_arrow_left),
            ),
            IconButton(
              onPressed: () async {
                PdfPage page = document.pages[controller.pageNumber - 1];
                PdfPageRotateAngle rotationAngle = page.rotation;
                page.rotation = turn(rotation: rotationAngle, left: true);
                List<int> bytes = await document.save();
                data = Uint8List.fromList(bytes);
                setState(() {});
              },
              icon: const Icon(Icons.rotate_left),
            ),
            IconButton(
              onPressed: () {
                controller.zoomLevel -= 0.5;
              },
              icon: const Icon(Icons.zoom_out),
            ),
            IconButton(
              onPressed: () {
                controller.zoomLevel += 0.5;
              },
              icon: const Icon(Icons.zoom_in),
            ),
            IconButton(
              onPressed: () async {
                PdfPage page = document.pages[controller.pageNumber - 1];
                PdfPageRotateAngle rotationAngle = page.rotation;
                page.rotation = turn(rotation: rotationAngle);
                List<int> bytes = await document.save();
                data = Uint8List.fromList(bytes);
                setState(() {});
              },
              icon: const Icon(Icons.rotate_right),
            ),
            IconButton(
              onPressed: () {
                controller.nextPage();
              },
              icon: const Icon(Icons.keyboard_arrow_right),
            ),
          ],
        ),
      ],
    );
  }
}
