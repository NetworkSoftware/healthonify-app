import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path/path.dart';


class CertificateViewPdfScreen extends StatefulWidget {
  //final String? url;
  final List<dynamic>? url;

  const CertificateViewPdfScreen({super.key, this.url});

  @override
  State<CertificateViewPdfScreen> createState() => _CertificateViewPdfScreenState();
}

class _CertificateViewPdfScreenState extends State<CertificateViewPdfScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  String? fileExtension;

  @override
  void initState() {
    super.initState();

    final File file = File(widget.url![0]);
    fileExtension = extension(file.path);

    print("File Extension : $fileExtension");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: fileExtension == ".pdf" ?
            SfPdfViewer.network(
              widget.url![0],
              key: _pdfViewerKey,
            ) :
            ListView.separated(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.url!.length,
              itemBuilder: (context, index) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          widget.url![index]),
                      fit: BoxFit.fill,
                    ),
                    // shape: BoxShape.circle,
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
            )
        )

    );
  }
}
