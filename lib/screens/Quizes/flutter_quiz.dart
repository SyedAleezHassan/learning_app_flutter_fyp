import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FlutterQuizPage extends StatefulWidget {
  @override
  _FlutterQuizPageState createState() => _FlutterQuizPageState();
}

class _FlutterQuizPageState extends State<FlutterQuizPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  String? _userEmail;
  String? _studentName;
  bool _quizCompleted = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is Flutter?',
      'options': ['A web framework', 'A mobile SDK', 'A database', 'An OS'],
      'answer': 'A mobile SDK'
    },
    {
      'question': 'Which language is used to write Flutter apps?',
      'options': ['Java', 'Kotlin', 'Swift', 'Dart'],
      'answer': 'Dart'
    },
    {
      'question': 'Who developed Flutter?',
      'options': ['Apple', 'Facebook', 'Google', 'Microsoft'],
      'answer': 'Google'
    },
    {
      'question': 'What is the command to create a new Flutter project?',
      'options': ['flutter new', 'flutter create', 'flutter init', 'flutter start'],
      'answer': 'flutter create'
    },
    {
      'question': 'Which widget is used to create a scrollable list?',
      'options': ['Column', 'ListView', 'Container', 'Stack'],
      'answer': 'ListView'
    },
    {
      'question': 'What is a stateful widget?',
      'options': ['A widget that does not maintain state', 'A widget that maintains state', 'A widget with no UI', 'None of the above'],
      'answer': 'A widget that maintains state'
    },
    {
      'question': 'What is a stateless widget?',
      'options': ['A widget that maintains state', 'A widget that does not maintain state', 'A widget with no UI', 'None of the above'],
      'answer': 'A widget that does not maintain state'
    },
    {
      'question': 'Which tool is used to manage Flutter packages?',
      'options': ['npm', 'flutter_tool', 'pub', 'gradle'],
      'answer': 'pub'
    },
    {
      'question': 'Which widget is used to display an image in Flutter?',
      'options': ['ImageView', 'Image', 'ImageWidget', 'ImageBox'],
      'answer': 'Image'
    },
    {
      'question': 'Which method is used to build the UI in Flutter?',
      'options': ['build()', 'render()', 'create()', 'display()'],
      'answer': 'build()'
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
    final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

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


User? get currentUser => _auth.currentUser;

  void _generateCertificate() async {
    if (_userEmail != null && _studentName != null && currentUser != null) {
      await _firestore
          .collection('certificates')
          .doc(currentUser!.uid)
          .collection('records')
          .add({
        'name': _studentName,
        'email': _userEmail,
        'course': 'Flutter',
        'date': DateTime.now(),
      });
    } 
  
      
      // await _firestore.collection('certificates').add({
      //   'name': _studentName,
      //   'email': _userEmail,
      //   'course': 'Flutter',
      //   'date': DateTime.now(),
      // });

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
          title: Text('Flutter Quiz'),
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
