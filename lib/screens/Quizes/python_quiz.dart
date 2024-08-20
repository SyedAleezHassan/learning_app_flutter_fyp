import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PythonQuizPage extends StatefulWidget {
  @override
  _PythonQuizPageState createState() => _PythonQuizPageState();
}

class _PythonQuizPageState extends State<PythonQuizPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  String? _userEmail;
  String? _studentName;
  bool _quizCompleted = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is Python?',
      'options': ['A snake', 'A programming language', 'A movie', 'A car'],
      'answer': 'A programming language'
    },
    {
      'question': 'Who developed Python?',
      'options': ['James Gosling', 'Guido van Rossum', 'Linus Torvalds', 'Bjarne Stroustrup'],
      'answer': 'Guido van Rossum'
    },
    {
      'question': 'Which of the following is a Python data type?',
      'options': ['List', 'Array', 'Vector', 'Pointer'],
      'answer': 'List'
    },
    {
      'question': 'Which Python keyword is used for defining functions?',
      'options': ['function', 'def', 'lambda', 'define'],
      'answer': 'def'
    },
    {
      'question': 'What is the output of 3 + 4 * 2?',
      'options': ['14', '11', '7', '10'],
      'answer': '11'
    },
    {
      'question': 'Which Python library is used for data analysis?',
      'options': ['numpy', 'pandas', 'matplotlib', 'scikit-learn'],
      'answer': 'pandas'
    },
    {
      'question': 'What does the `len()` function do?',
      'options': ['Calculates length', 'Calculates sum', 'Calculates average', 'None of the above'],
      'answer': 'Calculates length'
    },
    {
      'question': 'Which keyword is used to create a loop in Python?',
      'options': ['loop', 'repeat', 'for', 'iterate'],
      'answer': 'for'
    },
    {
      'question': 'How do you comment a single line in Python?',
      'options': ['//', '/*', '#', '--'],
      'answer': '#'
    },
    {
      'question': 'What is the output of `print("Hello" + "World")`?',
      'options': ['Hello World', 'HelloWorld', 'Hello+World', 'Error'],
      'answer': 'HelloWorld'
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

  // void _generateCertificate() async {
  //   if (_userEmail != null && _studentName != null) {
  //     await _firestore.collection('certificates').add({
  //       'name': _studentName,
  //       'email': _userEmail,
  //       'course': 'Python',
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
        'course': 'Python',
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
          title: Text('Python Quiz'),
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
