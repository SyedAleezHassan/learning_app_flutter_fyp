import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/color/color.dart';
import 'package:flutter_application_1/widgets/description_section.dart';
import 'package:flutter_application_1/widgets/videos_section.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_player/video_player.dart';

class CourseScreen extends StatefulWidget {
  String name;
  String buy;
  String image;
  String video;

  CourseScreen(this.name, this.buy, this.image, this.video);

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _getUserRecordsList();

    // _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      // Fetch the video URL from Firebase Storage
      String videoUrlString = await FirebaseStorage.instance
          // .ref('WIN_20240718_03_12_50_Pro.mp4')
          .ref('What is a Programming Language in 60 seconds!.mp4')
          .getDownloadURL();

      Uri videoUrl = Uri.parse(videoUrlString);

      // Initialize the video player controller
      _controller = VideoPlayerController.network(videoUrl.toString());

      // Initialize the video player future
      _initializeVideoPlayerFuture = _controller!.initialize();

      // Ensure the controller is properly initialized
      await _initializeVideoPlayerFuture;

      setState(() {});

      // Play the video initially
      _controller!.pause();
      _isPlaying = false;

      // Update the UI when the video plays
      _controller!.addListener(() {
        setState(() {});
      });
    } catch (e) {
      print("Error initializing video player: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // void _togglePlayPause() {
  //   setState(() {
  //     if (_controller!.value.isPlaying) {
  //       _controller!.pause();
  //       _isPlaying = false;
  //     } else {
  //       _controller!.play();
  //       _isPlaying = true;
  //     }
  //   });
  // }
  void _togglePlayPause() {
    if (_controller != null && _controller!.value.isInitialized) {
      setState(() {
        if (_controller!.value.isPlaying) {
          _controller!.pause();
          _isPlaying = false;
        } else {
          _controller!.play();
          _isPlaying = true;
        }
      });
    }
  }

////////////////////////

  bool isvideoSection = false;
  bool isbought = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? get currentUser => _auth.currentUser;

  _saveData(String name, String buy, String image, String video) async {
    Future<void> courses = FirebaseFirestore.instance
        .collection('wishlist')
        .doc(currentUser!.uid)
        .collection('records')
        .add({"imgLink": image, "name": name, "video": video, "price": buy})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _getUserRecordsList() async {
    if (currentUser != null) {
      try {
        final snapshot = await _firestore
            .collection('wishlist')
            .doc(currentUser!.uid)
            .collection('records')
            .get();

        final List<Map<String, dynamic>> recordsList = snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        print(recordsList);
        return recordsList;
      } catch (e) {
        print('Error fetching user records: $e');
        throw e; // Rethrow the error for handling elsewhere if needed
      }
    } else {
      print("No user");
      return []; // Return an empty list if no user
    }
  }

  Future<bool> isNameInList(String nameToCheck) async {
    final List<Map<String, dynamic>> recordsList = await _getUserRecordsList();

    for (final record in recordsList) {
      final String name = record['name'];
      if (name == nameToCheck) {
        print("true");
        print(name);
        return true; // Name found in the list
      }
    }
    print("falee");
    return false; // Name not found in the list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.notifications,
                size: 28, color: appColor.primaryColor),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: ListView(
          children: [
            Container(
              // padding: EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFFF5F3FF),
                image: DecorationImage(
                  image: AssetImage("assets/images/${widget.name}.png"),
                  fit: BoxFit.contain,
                ),
              ),
              child: Center(
                child: _controller != null
                    ? FutureBuilder(
                        future: _initializeVideoPlayerFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return GestureDetector(
                              onTap: () {
                                _togglePlayPause();
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  AspectRatio(
                                    aspectRatio: _controller!.value.aspectRatio,
                                    child: VideoPlayer(_controller!),
                                  ),
                                  Positioned.fill(
                                    child: GestureDetector(
                                      onTap: () {
                                        _togglePlayPause(); // Toggle play/pause on tap
                                      },
                                      child: Center(
                                        child: _isPlaying
                                            ? SizedBox
                                                .shrink() // Hide play button when video is playing
                                            : Icon(
                                                Icons.play_arrow_rounded,
                                                color: appColor.primaryColor,
                                                size: 65,
                                              ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    right: 10,
                                    child: Column(
                                      children: [
                                        // Video progress slider
                                        VideoProgressIndicator(
                                          _controller!,
                                          allowScrubbing: true,
                                          colors: VideoProgressColors(
                                            playedColor: Colors.blueAccent,
                                            backgroundColor: Colors.white54,
                                            bufferedColor: Colors.grey,
                                          ),
                                        ),
                                        // Video time and total duration
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _formatDuration(
                                                  _controller!.value.position),
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              _formatDuration(
                                                  _controller!.value.duration),
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      )
                    : Center(
                        child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.blueAccent,
                          size: 45,
                        ),
                      )),
              ),
            ),
            SizedBox(height: 15),
            Text(
              "${widget.name} Complete Course",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Created by Admin",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "55 Videos",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    bool nameExists = await isNameInList(widget.name);
                    if (nameExists) {
                      // print("already added");
                      Fluttertoast.showToast(
                        msg: "Course already added",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    } else {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          title: Text(
                            widget.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: appColor.primaryColor,
                            ),
                          ),
                          content: Container(
                            height: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Do you want to buy this course?",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Price: ${widget.buy}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: appColor.primaryColor,
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                bool nameExists =
                                    await isNameInList(widget.name);
                                if (nameExists) {
                                  print("already added");
                                } else {
                                  await _saveData(
                                    widget.name,
                                    widget.buy,
                                    widget.image,
                                    widget.video,
                                  );
                                }

                                Navigator.pop(context);
                                setState(() {
                                  isbought = true;
                                });
                              },
                              child: const Text(
                                'OK',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: appColor.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      );
                      //=============================================
                    }
                  },
                  child: Text(
                    "Buy ${widget.buy}",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[600],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: BoxDecoration(
                color: Color(0xFFF5F3FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Material(
                    color: isvideoSection
                        ? appColor.primaryColor
                        // Color(0xFF674AEF)
                        : appColor.primaryColor.withOpacity(0.6),
                    // Color(0xFF674AEF).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () async {
                        await isNameInList(widget.name);
                        print(isNameInList(widget.name));
                        bool nameExist = await isNameInList(widget.name);

                        if (nameExist) {
                          _initializeVideoPlayer();

                          print('agya');
                          setState(() {
                            isbought = true;
                            isvideoSection = isbought;
                          });
                        } else {
                          isvideoSection = isbought;
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                        child: Text(
                          "videos",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: isvideoSection
                        ? appColor.primaryColor.withOpacity(0.6)
                        // Color(0xFF674AEF)
                        : appColor.primaryColor,
                    // ? Color(0xFF674AEF).withOpacity(0.6)
                    // : Color(0xFF674AEF),
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isvideoSection = false;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                        child: Text(
                          "Description",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            isvideoSection
                ? VideoSection(courseName: widget.name)
                : DescriptionSection(),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
