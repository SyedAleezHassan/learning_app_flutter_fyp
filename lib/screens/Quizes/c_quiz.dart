import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CQuizPage extends StatefulWidget {
  @override
  _CQuizPageState createState() => _CQuizPageState();
}

class _CQuizPageState extends State<CQuizPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  String? _userEmail;
  String? _studentName;
  bool _quizCompleted = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is C++ primarily used for?',
      'options': ['Web development', 'System programming', 'Mobile apps', 'Data science'],
      'answer': 'System programming'
    },
    {
      'question': 'Which of the following is a feature of C++?',
      'options': ['Object-oriented', 'Functional', 'Declarative', 'None of the above'],
      'answer': 'Object-oriented'
    },
    {
      'question': 'Who developed C++?',
      'options': ['James Gosling', 'Bjarne Stroustrup', 'Guido van Rossum', 'Dennis Ritchie'],
      'answer': 'Bjarne Stroustrup'
    },
    {
      'question': 'Which operator is used for dynamic memory allocation in C++?',
      'options': ['malloc()', 'new', 'alloc()', 'dynamic'],
      'answer': 'new'
    },
    {
      'question': 'Which header file is required to use cout in C++?',
      'options': ['iostream', 'cstdio', 'cstring', 'cstdlib'],
      'answer': 'iostream'
    },
    {
      'question': 'What is the entry point of a C++ program?',
      'options': ['main()', 'start()', 'begin()', 'init()'],
      'answer': 'main()'
    },
    {
      'question': 'Which keyword is used to define a constant in C++?',
      'options': ['static', 'final', 'const', 'constexpr'],
      'answer': 'const'
    },
    {
      'question': 'What is the default return type of the main() function in C++?',
      'options': ['void', 'int', 'float', 'double'],
      'answer': 'int'
    },
    {
      'question': 'Which of the following is not a C++ loop construct?',
      'options': ['for', 'while', 'do-while', 'repeat'],
      'answer': 'repeat'
    },
    {
      'question': 'Which of the following is used to declare a class in C++?',
      'options': ['class', 'struct', 'object', 'interface'],
      'answer': 'class'
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


//====================geenrate certificate acc to user id
// void _generateCertificate() async {
//   User? user = _auth.currentUser; // Get current user
//   if (_userEmail != null && _studentName != null && user != null) {
//     await _firestore.collection('certificates').add({
//       'name': _studentName,
//       'email': _userEmail,
//       'uid': user.uid, // Store the UID of the user
//       'course': 'Flutter',
//       'date': DateTime.now(),
//     });


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
        'course': 'C++',
        'date': DateTime.now(),
      });
    } 
 
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


//====================
  // void _generateCertificate() async {
  //   if (_userEmail != null && _studentName != null) {
  //     await _firestore.collection('certificates').add({
  //       'name': _studentName,
  //       'email': _userEmail,
  //       'course': 'C++',
  //       'date': DateTime.now(),
  //     });

  //     Fluttertoast.showToast(
  //       msg: "Certificate added to Firebase!",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.black,
  //       textColor: Colors.white,
  //       fontSize: 16.0,
  //     );
  //   }
  // }

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
          title: Text('C++ Quiz'),
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
