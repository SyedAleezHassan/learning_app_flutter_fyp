import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/color/color.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({super.key});

  @override
  State<MyCourses> createState() => _MyCoursesState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

User? get currentUser => _auth.currentUser;

class _MyCoursesState extends State<MyCourses> {
  List<Map<String, dynamic>> userRecords = [];

  Stream<QuerySnapshot> _getUserRecordsStream() {
    if (currentUser != null) {
      return _firestore
          .collection('wishlist')
          .doc(currentUser!.uid)
          .collection('records')
          .snapshots();
    } else {
      print("No user");
      return Stream<QuerySnapshot>.empty();
    }
   
  }

//   @override
//   void initState()  {
//     // TODO: implement initState
//     super.initState();
//     getData();
// setState(() {

// });
  //   print(userRecords);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor.primaryColor,
        title: Text(
          "My Courses",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body:  Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getUserRecordsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No records found'));
                  } else {
                    final userRecords = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: userRecords.length,
                      itemBuilder: (context, index) {
                        var record = userRecords[index].data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text(record['name']),
                          subtitle: Text(record['video']),
                        );
                      },
                    );
                  }
                },
              ),
            ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     await getData();
      //     setState(() {});
      //   },
      //   child: Text("Add"),
      // ),
    );
  }
}
//  [
//   {imgLink: https://iconape.com/wp-content/png_logo_vector/flutter-logo.png, price: 50$, name: Flutter, video: 55 videos}
//   , {imgLink: https://cdn.freebiesupply.com/logos/large/2x/c-logo-png-transparent.png, price: $49.9, name: C++, video: 35 videos}
//   , {imgLink: https://brandslogos.com/wp-content/uploads/images/large/python-logo.png, price: 50$, name: Python, video: 55 videos},
//    {imgLink: https://brandslogos.com/wp-content/uploads/images/large/rust-logo.png, price: $60, name: Rust, video: 47 videos},
//     {imgLink: https://iconape.com/wp-content/png_logo_vector/flutter-logo.png, price: 50$, name: Flutter, video: 55 videos}, 
//     {imgLink: https://cdn.freebiesupply.com/logos/large/2x/c-logo-png-transparent.png, price: $49.9, name: C++, video: 35 videos}, 
//     {imgLink: https://brandslogos.com/wp-content/uploads/images/large/python-logo.png, price: 50$, name: Python, video: 55 videos}, 
//     {imgLink: https://brandslogos.com/wp-content/uploads/images/large/rust-logo.png, price: $60, name: Rust, video: 47 videos}]