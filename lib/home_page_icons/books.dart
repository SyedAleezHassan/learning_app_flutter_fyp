import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_1/color/color.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'showPdf.dart';

class PdfListScreen extends StatefulWidget {
  @override
  State<PdfListScreen> createState() => _PdfListScreenState();
}

class _PdfListScreenState extends State<PdfListScreen> {
  @override
  bool isload = true;
  void initState() {
    // TODO: implement initState
    super.initState();
    // _recordsFuture =
    // getPdfUrls();
    _getPdfs();
    _getUserRecordsList();
    Timer(Duration(milliseconds: 1000), () {
      checkList();
      setState(() {
        isload = false;
      });
    });

    // print(_recordsFuture);
    // userRecords();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  // late Future<List<Map<String, dynamic>>> _recordsFuture;
  List<Map<String, dynamic>> records = [];

  Future<List<Map<String, dynamic>>> _getUserRecordsList() async {
    if (currentUser != null) {
      QuerySnapshot snapshot = await _firestore
          .collection('wishlist')
          .doc(currentUser!.uid)
          .collection('records')
          .get();

      // List<Map<String, dynamic>>
      records = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      // print(records);
      return records;
    } else {
      print("No user");
      return [];
    }
  }

  List<Map<String, dynamic>> pdfs = [];
  Future<List<Map<String, dynamic>>> _getPdfs() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('pdfs').get();

      // Convert the snapshot to a list of maps
      pdfs = snapshot.docs
          .map((doc) => {
                "name": doc["name"],
                "Url": doc["Url"],
              })
          .toList();
      // print(pdfs);
      return pdfs;
    } catch (e) {
      print("Error getting PDFs: $e");
      return [];
    }
  }

  List<Map<String, dynamic>> matchingEntries = [];
  checkList() async {
    List<Map<String, dynamic>> list1 = await records;
    print("list 111 $list1");
    List<Map<String, dynamic>> list2 = await pdfs;
    print("list222 $list2");

    for (var item1 in list1) {
      for (var item2 in list2) {
        if (item1["name"] == item2["name"]) {
          // Check if the item is already in matchingEntries
          bool alreadyExists =
              matchingEntries.any((entry) => entry["name"] == item1["name"]);

          if (!alreadyExists) {
            // If the "name" is the same and not already in the list, add to the matchingEntries list
            matchingEntries.add({
              "name": item2["name"],
              // "quantity": item1["quantity"],
              "Url": item2["Url"],
            });
          }
        }
      }
    }

    print('Matching Entries: $matchingEntries');

    // print('Matching Records: $matchingRecords');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Books Store",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Set the back arrow color to white
        ),
        backgroundColor: appColor.primaryColor,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getPdfs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No PDFs found.'));
          } else {
            final pdfUrls = snapshot.data!;

            return matchingEntries.isNotEmpty
                ? ListView.builder(
                    itemCount: matchingEntries.length,
                    itemBuilder: (context, index) {
                      // final segments = pdfUrls[index].split('2F');
                      // final fileName = segments.last.split('?').first;
                      checkList();

                      return ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        leading: Icon(Icons.picture_as_pdf,
                            color: Colors.redAccent, size: 30),
                        title: Text(
                          matchingEntries[index]["name"] ?? '',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        trailing:
                            Icon(Icons.arrow_forward_ios, color: Colors.grey),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFViewerPage(
                                filepath: matchingEntries[index]["Url"] ?? '',
                              ),
                            ),
                          );
                        },
                      );
                      // ListTile(
                      //   title: Text(matchingEntries[index]["name"]),
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => PDFViewerPage(
                      //             filepath: matchingEntries[index]["Url"]),
                      //         //  PdfViewer(filepath : pdfUrls[index]),
                      //       ),
                      //     );
                      //   },
                      // );
                    },
                  )
                : Center(
                    child:
                        isload ? CircularProgressIndicator() : Text("No data"),
                  );
          }
        },
      ),
    );
  }
}

// class PdfViewer extends StatelessWidget {
//   final String url;

//   PdfViewer({required this.url});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('PDF Viewer'),
//       ),
//       body: PDFView(
//         filePath: url,
//       ),
//     );
//   }
// }
