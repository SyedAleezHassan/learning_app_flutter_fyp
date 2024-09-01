import 'package:flutter/material.dart';
import 'package:flutter_application_1/color/color.dart';
import 'package:flutter_application_1/widgets/videoPlayer/flutter_intro_vid.dart';

class liveCourse extends StatelessWidget {
  final List<Map> demoVid = [
    {
      "imgLink": "assets/images/Flutter.png",
      "name": "Flutter",
      "subtitle": "Flutter demo video"
    },
    {
      "imgLink": "assets/images/java.png",
      "name": "Java",
      "subtitle": "Java demo video"
    },
    {
      "imgLink": "assets/images/Python.png",
      "name": "Python",
      "subtitle": "Python demo video"
    },
    {
      "imgLink": "assets/images/React Native.png",
      "name": "React Native",
      "subtitle": "React Native demo video"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Demo Clases",
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
          iconTheme: IconThemeData(
            color: Colors.white, // Set the back arrow color to white
          ),
          backgroundColor: appColor.primaryColor,
        ),
        body: ListView.builder(
          itemCount: demoVid.length,
          itemBuilder: (context, index) {
            // var record = userRecords[index].data() as Map<String, dynamic>;
            return ListTile(
              contentPadding: EdgeInsets.all(16.0),
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: Color.fromARGB(179, 234, 233, 233),
                backgroundImage: AssetImage(
                  demoVid[index]["imgLink"],
                ),
              ),
              title: Text(
                demoVid[index]['name'],
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Theme.of(context).textTheme.bodyText1!.color,
                    ),
              ),
              subtitle: Text(
                demoVid[index]["subtitle"],
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 14.0,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.6),
                    ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[600],
                size: 18.0,
              ),
              onTap: () {
                // DocumentSnapshot abc = snapshot.data!.docs[index];

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => flutterIntro(),
                  ),
                );
              },
            );
          },
        ));
  }
}
