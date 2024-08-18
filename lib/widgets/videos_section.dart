import 'package:flutter/material.dart';
import 'package:flutter_application_1/color/color.dart';
import 'package:flutter_application_1/widgets/videoPlayer/flutter_intro_vid.dart';

class VideoSection extends StatelessWidget {
  List videoList = [
    'Introduction',
    'Installing on Windows, Mac & Linux',
    'Setup Emulator on Windows',
    'Creating Our First App',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: videoList.length,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: index == 0
                  ? appColor.primaryColor
                  : appColor.primaryColor.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          title: Text(videoList[index]),
          subtitle: Text("20 min 50 sec"),
          onTap: () {
            // yahan kro video dalny wala kam syed aleez hassan sahab jee
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => flutterIntro()));
            //yahan khatam horha hai syed aleez hassan saahab
          },
        );
      },
    );
  }
}
