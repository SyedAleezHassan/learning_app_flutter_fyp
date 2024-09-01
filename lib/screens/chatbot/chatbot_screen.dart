import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/color/color.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class ChatbotAi extends StatefulWidget {
  const ChatbotAi({super.key});

  @override
  State<ChatbotAi> createState() => _ChatbotAiState();
}

class _ChatbotAiState extends State<ChatbotAi> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
      id: "1",
      firstName: "Mr. AI",
      profileImage:
          'https://yt3.googleusercontent.com/swv9wQxWDXdKL4ZBEV8mvlDSySyxQeANhC4AjrtZ2PAidPhj7H5AI27GqFy5GOAPneEAMYIO=s900-c-k-c0x00ffffff-no-rj');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mr AI",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: appColor.primaryColor,
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      inputOptions: InputOptions(
        inputDecoration: InputDecoration(
          hintText: 'Type a message...',
          hintStyle: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[400]
                : Colors.grey,
          ),
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black12
              : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            // borderSide: BorderSide., // Remove border if needed
          ),
          contentPadding: EdgeInsets.symmetric(
              vertical: 8.0, horizontal: 12.0), // Adjust height here
        ),
        trailing: [
          IconButton(
            onPressed: _sendMediaMessage,
            icon: Icon(
              Icons.image,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : appColor.primaryColor,
            ),
          ),
        ],
        sendButtonBuilder: (sendMessage) => IconButton(
          icon: Icon(
            Icons.send,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : appColor
                    .primaryColor, // White in dark mode, primary color in light mode
          ),
          onPressed: sendMessage,
        ),
      ),
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
      messageOptions: MessageOptions(
        messageTextBuilder: (message, previousMessage, nextMessage) {
          bool isUser = message.user.id == currentUser.id;
          return Text(
            message.text,
            style: TextStyle(
              color: isUser
                  ? (Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.white)
                  : (Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.black87),
            ),
          );
        },
      ),
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }
      gemini
          .streamGenerateContent(
        question,
        images: images,
      )
          .listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          lastMessage.text += response;
          setState(() {
            messages = [lastMessage!, ...messages];
          });
        } else {
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Describe this picture?",
        medias: [
          ChatMedia(
            url: file.path,
            fileName: "",
            type: MediaType.image,
          ),
        ],
      );
      _sendMessage(chatMessage);
    }
  }
}








// import 'dart:io';
// import 'dart:typed_data';

// import 'package:dash_chat_2/dash_chat_2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/color/color.dart';
// import 'package:flutter_gemini/flutter_gemini.dart';
// import 'package:image_picker/image_picker.dart';

// class ChatbotAi extends StatefulWidget {
//   const ChatbotAi({super.key});

//   @override
//   State<ChatbotAi> createState() => _ChatbotAiState();
// }

// class _ChatbotAiState extends State<ChatbotAi> {
//   final Gemini gemini = Gemini.instance;
//   List<ChatMessage> messages = [];

//   // Define the current user and the chatbot AI user
//   ChatUser currentUser = ChatUser(id: "0", firstName: "User");
//   ChatUser geminiUser = ChatUser(
//       id: "1",
//       firstName: "Mr. AI",
//       profileImage:
//           'https://yt3.googleusercontent.com/swv9wQxWDXdKL4ZBEV8mvlDSySyxQeANhC4AjrtZ2PAidPhj7H5AI27GqFy5GOAPneEAMYIO=s900-c-k-c0x00ffffff-no-rj');

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Mr AI"),
//         backgroundColor: appColor.primaryColor,
//       ),
//       body: _buildUI(),
//     );
//   }

//   Widget _buildUI() {
//     return DashChat(
//       inputOptions: InputOptions(
//         inputDecoration: InputDecoration(
//           hintText: 'Type a message...',
//           hintStyle: TextStyle(
//             color: Theme.of(context).brightness == Brightness.dark
//                 ? Colors.grey[400]
//                 : Colors.grey,
//           ),
//           filled: true,
//           fillColor: Theme.of(context).brightness == Brightness.dark
//               ? Colors.black12
//               : Colors.white,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//         ),
//         trailing: [
//           IconButton(
//             onPressed: _sendMediaMessage,
//             icon: Icon(
//               Icons.image,
//               color: Theme.of(context).brightness == Brightness.dark
//                   ? Colors.white
//                   : appColor.primaryColor,
//             ),
//           ),
//         ],
//       ),
//       currentUser: currentUser,
//       onSend: _sendMessage,
//       messages: messages,
//       messageOptions: MessageOptions(
//         messageTextBuilder: (message, previousMessage, nextMessage) {
//           bool isUser = message.user.id == currentUser.id;
//           return Text(
//             message.text,
//             style: TextStyle(
//               color: isUser
//                   ? (Theme.of(context).brightness == Brightness.dark
//                       ? Colors.white
//                       : Colors.black)
//                   : (Theme.of(context).brightness == Brightness.dark
//                       ? Colors.blueGrey[300]
//                       : Colors.black87),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void _sendMessage(ChatMessage chatMessage) {
//     setState(() {
//       messages = [chatMessage, ...messages];
//     });

//     try {
//       String question = chatMessage.text;
//       List<Uint8List>? images;
//       if (chatMessage.medias?.isNotEmpty ?? false) {
//         images = [
//           File(chatMessage.medias!.first.url).readAsBytesSync(),
//         ];
//       }
//       gemini.streamGenerateContent(
//         question,
//         images: images,
//       ).listen((event) {
//         ChatMessage? lastMessage = messages.firstOrNull;
//         if (lastMessage != null && lastMessage.user == geminiUser) {
//           lastMessage = messages.removeAt(0);
//           String response = event.content?.parts?.fold(
//                   "", (previous, current) => "$previous ${current.text}") ??
//               "";
//           lastMessage.text += response;
//           setState(() {
//             messages = [lastMessage!, ...messages];
//           });
//         } else {
//           String response = event.content?.parts?.fold(
//                   "", (previous, current) => "$previous ${current.text}") ??
//               "";
//           ChatMessage message = ChatMessage(
//             user: geminiUser,
//             createdAt: DateTime.now(),
//             text: response,
//           );
//           setState(() {
//             messages = [message, ...messages];
//           });
//         }
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   void _sendMediaMessage() async {
//     ImagePicker picker = ImagePicker();
//     XFile? file = await picker.pickImage(
//       source: ImageSource.gallery,
//     );
//     if (file != null) {
//       ChatMessage chatMessage = ChatMessage(
//         user: currentUser,
//         createdAt: DateTime.now(),
//         text: "Describe this picture?",
//         medias: [
//           ChatMedia(
//             url: file.path,
//             fileName: "",
//             type: MediaType.image,
//           ),
//         ],
//       );
//       _sendMessage(chatMessage);
//     }
//   }
// }






// import 'dart:io';
// import 'dart:typed_data';

// import 'package:dash_chat_2/dash_chat_2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/color/color.dart';
// import 'package:flutter_gemini/flutter_gemini.dart';
// import 'package:image_picker/image_picker.dart';

// class chatbotAi extends StatefulWidget {
//   const chatbotAi({super.key});

//   @override
//   State<chatbotAi> createState() => _chatbotAiState();
// }

// class _chatbotAiState extends State<chatbotAi> {
//   final Gemini gemini = Gemini.instance;

//   List<ChatMessage> messages = [];

//   ChatUser currentUser = ChatUser(id: "0", firstName: "User");
//   ChatUser geminiUser = ChatUser(
//       id: "1",
//       firstName: "Mr. AI",
//       profileImage:
//           'https://yt3.googleusercontent.com/swv9wQxWDXdKL4ZBEV8mvlDSySyxQeANhC4AjrtZ2PAidPhj7H5AI27GqFy5GOAPneEAMYIO=s900-c-k-c0x00ffffff-no-rj'
//       //"https://seeklogo.com/images/G/google-gemini-logo-A5787B2669-seeklogo.com.png",
//       ); //https://yt3.googleusercontent.com/swv9wQxWDXdKL4ZBEV8mvlDSySyxQeANhC4AjrtZ2PAidPhj7H5AI27GqFy5GOAPneEAMYIO=s900-c-k-c0x00ffffff-no-rj
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // centerTitle: true,
//         title: const Text(
//           "Mr AI",
//         ),
//         backgroundColor: appColor.primaryColor,
//       ),
//       body: _buildUI(),
//     );
//   }

//   Widget _buildUI() {
//     return DashChat(
//       inputOptions: InputOptions(trailing: [
//         IconButton(
//           onPressed: _sendMediaMessage,
//           icon: Icon(Icons.image,
//               // color: Theme.of(context).iconTheme.color,
//               color: appColor.primaryColor),
//         )
//       ]),
//       currentUser: currentUser,
//       onSend: _sendMessage,
//       messages: messages,
//     );
//   }

//   void _sendMessage(ChatMessage chatMessage) {
//     setState(() {
//       messages = [chatMessage, ...messages];
//     });
//     try {
//       String question = chatMessage.text;
//       List<Uint8List>? images;
//       if (chatMessage.medias?.isNotEmpty ?? false) {
//         images = [
//           File(chatMessage.medias!.first.url).readAsBytesSync(),
//         ];
//       }
//       gemini
//           .streamGenerateContent(
//         question,
//         images: images,
//       )
//           .listen((event) {
//         ChatMessage? lastMessage = messages.firstOrNull;
//         if (lastMessage != null && lastMessage.user == geminiUser) {
//           lastMessage = messages.removeAt(0);
//           String response = event.content?.parts?.fold(
//                   "", (previous, current) => "$previous ${current.text}") ??
//               "";
//           lastMessage.text += response;
//           setState(
//             () {
//               messages = [lastMessage!, ...messages];
//             },
//           );
//         } else {
//           String response = event.content?.parts?.fold(
//                   "", (previous, current) => "$previous ${current.text}") ??
//               "";
//           ChatMessage message = ChatMessage(
//             user: geminiUser,
//             createdAt: DateTime.now(),
//             text: response,
//           );
//           setState(() {
//             messages = [message, ...messages];
//           });
//         }
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   void _sendMediaMessage() async {
//     ImagePicker picker = ImagePicker();
//     XFile? file = await picker.pickImage(
//       source: ImageSource.gallery,
//     );
//     if (file != null) {
//       ChatMessage chatMessage = ChatMessage(
//         user: currentUser,
//         createdAt: DateTime.now(),
//         text: "Describe this picture?",
//         medias: [
//           ChatMedia(
//             url: file.path,
//             fileName: "",
//             type: MediaType.image,
//           )
//         ],
//       );
//       _sendMessage(chatMessage);
//     }
//   }
// }
