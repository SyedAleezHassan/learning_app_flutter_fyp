import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RustQuizPage extends StatefulWidget {
  @override
  _RustQuizPageState createState() => _RustQuizPageState();
}

class _RustQuizPageState extends State<RustQuizPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  String? _userEmail;
  String? _studentName;
  bool _quizCompleted = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is Rust primarily used for?',
      'options': ['Web development', 'Systems programming', 'Mobile apps', 'Data science'],
      'answer': 'Systems programming'
    },
    {
      'question': 'Which of the following is a key feature of Rust?',
      'options': ['Automatic memory management', 'Garbage collection', 'Memory safety without GC', 'None of the above'],
      'answer': 'Memory safety without GC'
    },
    {
      'question': 'Which company originally developed Rust?',
      'options': ['Google', 'Mozilla', 'Microsoft', 'Apple'],
      'answer': 'Mozilla'
    },
    {
      'question': 'How do you declare a variable in Rust?',
      'options': ['let', 'var', 'define', 'int'],
      'answer': 'let'
    },
    {
      'question': 'What is the default mutability of variables in Rust?',
      'options': ['Mutable', 'Immutable', 'Read-only', 'None'],
      'answer': 'Immutable'
    },
    {
      'question': 'Which keyword is used to define a function in Rust?',
      'options': ['fn', 'def', 'function', 'func'],
      'answer': 'fn'
    },
    {
      'question': 'What is the package manager for Rust?',
      'options': ['npm', 'cargo', 'bundler', 'pip'],
      'answer': 'cargo'
    },
    {
      'question': 'Which Rust feature ensures memory safety?',
      'options': ['Lifetimes', 'Garbage collection', 'Reference counting', 'Manual deallocation'],
      'answer': 'Lifetimes'
    },
    {
      'question': 'How do you define a constant in Rust?',
      'options': ['const', 'let', 'var', 'static'],
      'answer': 'const'
    },
    {
      'question': 'What is the extension of Rust source files?',
      'options': ['.rs', '.rust', '.r', '.ru'],
      'answer': '.rs'
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
        'course': 'Rust', // Updated for Rust
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
          title: Text('Rust Quiz'), // Updated title for Rust
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
