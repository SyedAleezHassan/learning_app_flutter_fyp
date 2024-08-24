import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

class flutterIntro extends StatefulWidget {
  const flutterIntro({super.key});

  @override
  State<flutterIntro> createState() => _flutterIntroState();
}

class _flutterIntroState extends State<flutterIntro> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
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

      // Ensure the controller is properly initialized before calling play
      await _initializeVideoPlayerFuture;

      setState(() {});

      // Start playing the video
      _controller!.play();
    } catch (e) {
      print("Error initializing video player: $e");
    }
  }

//   Future<void> _initializeVideoPlayer() async {
//     // Fetch the video URL from Firebase Storage
//    String videoUrlString = await FirebaseStorage.instance
//         .ref('WIN_20240718_03_12_50_Pro.mp4')
//         .getDownloadURL();
//  Uri videoUrl = Uri.parse(videoUrlString);
//     // Initialize the video player controller
//     _controller = VideoPlayerController.networkUrl(videoUrl);

//     // Initialize the video player future
//     _initializeVideoPlayerFuture = _controller!.initialize();

//     setState(() {});

//     // Start playing the video
//     _controller!.play();
//   }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Video Player from Firebase Storage'),
        ),
        body: Center(
          child: _controller != null
              ? FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                )
              : CircularProgressIndicator(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              if (_controller!.value.isPlaying) {
                _controller!.pause();
              } else {
                _controller!.play();
              }
            });
          },
          child: Icon(
            _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
