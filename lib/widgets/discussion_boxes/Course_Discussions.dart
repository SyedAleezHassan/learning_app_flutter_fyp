import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DiscussionPage extends StatefulWidget {
  final String courseId;

  DiscussionPage({required this.courseId});

  @override
  _DiscussionPageState createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  final _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Extract username from email
  String getUsername(String email) {
    return email.split('@')[0];
  }

  // Send message to Firestore with user info
  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    User? user = _auth.currentUser;
    if (user == null) return;

    String userEmail = user.email ?? "unknown";
    String userName = getUsername(userEmail); // Get part before '@'
    String users;
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.courseId)
        .collection('messages')
        .add({
      'message': _messageController.text,
      'userId': user.uid,
      'userName': userName, // Store username
      'userEmail': userEmail, // Store full email if needed
      'timestamp': Timestamp.now(),
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.courseId} Discussion'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.courseId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final chatDocs = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: chatDocs.length,
                  itemBuilder: (context, index) {
                    return ChatMessage(
                      chatDocs[index]['message'],
                      chatDocs[index]['userName'],
                      chatDocs[index]['userId'] == _auth.currentUser!.uid,
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(labelText: 'Send a message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String message;
  final String userName;
  final bool isMe;

  ChatMessage(this.message, this.userName, this.isMe);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMe)
          CircleAvatar(
            child: Text(userName[0].toUpperCase()), // First letter of username
          ),
        Container(
          decoration: BoxDecoration(
            color: isMe ? Colors.blueAccent : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          width: 200,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                userName, // Display username
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isMe ? Colors.white : Colors.black,
                ),
              ),
              Text(
                message,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}






// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class DiscussionPage extends StatefulWidget {
//   final String courseId;

//   DiscussionPage({required this.courseId});

//   @override
//   _DiscussionPageState createState() => _DiscussionPageState();
// }

// class _DiscussionPageState extends State<DiscussionPage> {
//   final _messageController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   void _sendMessage() async {
//     if (_messageController.text.trim().isEmpty) return;

//     User? user = _auth.currentUser;

//     if (user == null) return;

//     // Reference to the specific course's messages sub-collection
//     await FirebaseFirestore.instance
//         .collection('chats')
//         .doc(widget.courseId)
//         .collection('messages')
//         .add({
//       'message': _messageController.text,
//       'userId': user.uid,
//       'timestamp': Timestamp.now(),
//     });

//     _messageController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('${widget.courseId} Discussion'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection('chats')
//                   .doc(widget.courseId)
//                   .collection('messages')
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 final chatDocs = snapshot.data!.docs;

//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: chatDocs.length,
//                   itemBuilder: (context, index) {
//                     return ChatMessage(
//                       chatDocs[index]['message'],
//                       chatDocs[index]['userId'] == _auth.currentUser!.uid,
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(labelText: 'Send a message...'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// class ChatMessage extends StatelessWidget {
//   final String message;
//   final bool isMe;

//   ChatMessage(this.message, this.isMe);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: isMe ? Colors.blueAccent : Colors.grey[300],
//             borderRadius: BorderRadius.circular(12),
//           ),
//           width: 140,
//           padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//           margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//           child: Text(
//             message,
//             style: TextStyle(color: isMe ? Colors.white : Colors.black),
//           ),
//         ),
//       ],
//     );
//   }
// }
