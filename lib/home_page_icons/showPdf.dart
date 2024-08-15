import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

class PDFViewerPage extends StatefulWidget {
  final filepath;

  const PDFViewerPage({
    super.key,
    this.filepath,
  });
  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  late Future<File> _pdfFile;

  @override
  void initState() {
    super.initState();
    _pdfFile = downloadPDFFile();
  }

  Future<File> downloadPDFFile() async {
    // final url =
    //     'https://firebasestorage.googleapis.com/v0/b/learning-app-5375c.appspot.com/o/pdfs%2Fflutter.pdf?alt=media&token=2bb0b019-5dff-44b3-ae20-8ad6f0464ba8';
    final url = widget.filepath;
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/flutter.pdf';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } else {
      throw Exception('Failed to download PDF');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PDF Viewer')),
      body: FutureBuilder<File>(
        future: _pdfFile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return PdfView(
                controller: PdfController(
                  document: PdfDocument.openFile(snapshot.data!.path),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:pdfx/pdfx.dart';

// class PdfViewer extends StatefulWidget {
//   final filepath;
//   const PdfViewer({super.key, required this.filepath});

//   @override
//   State<PdfViewer> createState() => _PdfViewerState();
// }

// class _PdfViewerState extends State<PdfViewer> {
//   late PdfControllerPinch pdffControllerPinch;
//   int totalPageCount = 0;
//   @override
//   void initState() {
//     super.initState();
//     pdffControllerPinch =
//         PdfControllerPinch(document: PdfDocument.openFile(widget.filepath));
//     print(widget.filepath);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Colors.red,
//         title: Text(
//           "PDF Viewer",
//           style: TextStyle(
//               color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: buildUi(),
//     );
//   }

//   Widget buildUi() {
//     return Column(
//       children: [
//         Container(
//           color: Colors.red,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "Total Pages $totalPageCount",
//                 style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           color: Colors.red,
//           height: 15,
//         ),
//         pdfView(),
//       ],
//     );
//   }

//   Widget pdfView() {
//     return Expanded(
//         child: PdfViewPinch(
//       controller: pdffControllerPinch,
//       backgroundDecoration: BoxDecoration(boxShadow: [
//         BoxShadow(color: Color(0x73000000), blurRadius: 4, offset: Offset(2, 2))
//       ], color: Colors.white24),
//       onDocumentLoaded: (doc) {
//         setState(() {
//           totalPageCount = doc.pagesCount;
//         });
//       },
//     ));
//   }
// }


















// // import 'package:flutter/material.dart';
// // import 'package:flutter_pdfview/flutter_pdfview.dart';

// // class PdfViewer extends StatelessWidget {
// //   final String url;

// //   PdfViewer({required this.url});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('PDF Viewer'),
// //       ),
// //       body: PDFView(
// //         filePath: url,
// //       ),
// //     );
// //   }
// // }