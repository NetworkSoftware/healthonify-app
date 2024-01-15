import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path/path.dart';

class PdfScreen extends StatefulWidget {
  final String? url;

  const PdfScreen({super.key, this.url});

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body:
            SfPdfViewer.network(
              widget.url!,
              key: _pdfViewerKey,
            )
        ));
  }
}


