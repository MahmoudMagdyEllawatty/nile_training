import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewPage extends StatefulWidget {
  final String pdfUrl;
  final String name;

  PdfViewPage({required this.pdfUrl,required this.name});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PDFState();
  }


}

class PDFState extends State<PdfViewPage>{
  late PdfViewerController _pdfViewerController; // للتحكم في العارض
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(widget.name),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.navigate_before,
              color: Colors.white,
            ),
            onPressed: () {
              _pdfViewerController.previousPage(); // الانتقال للصفحة السابقة
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.navigate_next,
              color: Colors.white,
            ),
            onPressed: () {
              _pdfViewerController.nextPage(); // الانتقال للصفحة التالية
            },
          )
        ],
      ),
      body: SfPdfViewer.network(
        widget.pdfUrl, // تمرير رابط PDF هنا
        key: _pdfViewerKey,
        controller: _pdfViewerController,
        // يمكنك إضافة معالجات الأحداث والميزات الأخرى هنا
        onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
          // يتم استدعاء هذا عندما يفشل تحميل ملف PDF
          print('Failed to load PDF: ${details.description}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('فشل تحميل ملف PDF: ${details.description}')),
          );
        },
        onDocumentLoaded: (PdfDocumentLoadedDetails details) {
         // print('PDF loaded successfully: ${details.document.pages.count} pages');
        },
        // password: 'your_password', // إذا كان ملف PDF محمي بكلمة مرور
      ),
    );
  }


}
