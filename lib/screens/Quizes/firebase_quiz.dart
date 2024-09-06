import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseQuizPage extends StatefulWidget {
  @override
  _FirebaseQuizPageState createState() => _FirebaseQuizPageState();
}

class _FirebaseQuizPageState extends State<FirebaseQuizPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  String? _userEmail;
  String? _studentName;
  bool _quizCompleted = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is Firebase primarily used for?',
      'options': ['Mobile development', 'Cloud services', 'Analytics', 'All of the above'],
      'answer': 'All of the above'
    },
    {
      'question': 'Which Firebase service is used for user authentication?',
      'options': ['Firestore', 'Firebase Auth', 'Firebase ML', 'Firebase Realtime Database'],
      'answer': 'Firebase Auth'
    },
    {
      'question': 'Which Firebase database supports real-time data synchronization?',
      'options': ['Firestore', 'SQLite', 'Firebase Realtime Database', 'MongoDB'],
      'answer': 'Firebase Realtime Database'
    },
    {
      'question': 'What is Firestore?',
      'options': ['A NoSQL database', 'A SQL database', 'A document database', 'An in-memory database'],
      'answer': 'A NoSQL database'
    },
    {
      'question': 'What is Firebase Cloud Messaging used for?',
      'options': [
        'User authentication',
        'Real-time data syncing',
        'Push notifications',
        'Hosting'
      ],
      'answer': 'Push notifications'
    },
    {
      'question': 'Which tool is used to monitor app crashes in Firebase?',
      'options': ['Firebase Crashlytics', 'Firebase Hosting', 'Firebase Auth', 'Firebase Realtime Database'],
      'answer': 'Firebase Crashlytics'
    },
    {
      'question': 'Firebase is a product of which company?',
      'options': ['Microsoft', 'Apple', 'Google', 'Amazon'],
      'answer': 'Google'
    },
    {
      'question': 'Which Firebase service provides cloud storage for app data?',
      'options': ['Firebase Auth', 'Firebase Hosting', 'Firebase Storage', 'Firestore'],
      'answer': 'Firebase Storage'
    },
    {
      'question': 'Which of the following is used to host web apps in Firebase?',
      'options': ['Firebase Auth', 'Firebase Hosting', 'Firebase Firestore', 'Firebase ML'],
      'answer': 'Firebase Hosting'
    },
    {
      'question': 'Which Firebase feature tracks app analytics?',
      'options': ['Firebase Analytics', 'Firebase Auth', 'Firestore', 'Firebase Realtime Database'],
      'answer': 'Firebase Analytics'
    },
  ];

  @override
  void initState() {
    super.initState();
    _getUserEmail();
    _askForStudentName();
  }

  void _getUserEmail() async {
    User? user = _auth.currentUser;
    setState(() {
      _userEmail = user?.email;
    });
  }

  void _askForStudentName() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String? name = await _showNameDialog();
      if (name != null && name.isNotEmpty) {
        setState(() {
          _studentName = name;
        });
      } else {
        Navigator.of(context).pop(); // Close quiz if no name is provided
      }
    });
  }

  Future<String?> _showNameDialog() async {
    String? name;
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Your Name'),
          content: TextField(
            onChanged: (value) {
              name = value;
            },
            decoration: InputDecoration(hintText: "Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(name);
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _submitAnswer(String selectedOption) {
    if (_questions[_currentQuestionIndex]['answer'] == selectedOption) {
      _correctAnswers++;
    }

    if (_currentQuestionIndex == _questions.length - 1) {
      setState(() {
        _quizCompleted = true;
      });
      _showResultDialog();
    } else {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _showResultDialog() {
    bool passed = _correctAnswers >= 5;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(passed ? 'Congratulations!' : 'Try Again'),
        content: Text(
          passed
              ? 'You passed the quiz! A certificate has been generated.'
              : 'You did not pass the quiz. Please try again.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (passed) {
                _generateCertificate();
              }
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _generateCertificate() async {
    if (_userEmail != null && _studentName != null) {
      await _firestore
          .collection('certificates')
          .doc(_auth.currentUser!.uid)
          .collection('records')
          .add({
        'name': _studentName,
        'email': _userEmail,
        'course': 'Firebase', // Course name set to Firebase
        'date': DateTime.now(),
      });

      Fluttertoast.showToast(
        msg: "Certificate added to Firebase!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<bool> _onWillPop() async {
    if (!_quizCompleted) {
      Fluttertoast.showToast(
        msg: "You failed the quiz by exiting.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Firebase Quiz'), // Updated title for Firebase
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                _questions[_currentQuestionIndex]['question'],
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              ..._questions[_currentQuestionIndex]['options'].map((option) {
                return ElevatedButton(
                  onPressed: () => _submitAnswer(option),
                  child: Text(option),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
