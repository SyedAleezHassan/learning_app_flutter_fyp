import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MariaDBQuizPage extends StatefulWidget {
  @override
  _MariaDBQuizPageState createState() => _MariaDBQuizPageState();
}

class _MariaDBQuizPageState extends State<MariaDBQuizPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  String? _userEmail;
  String? _studentName;
  bool _quizCompleted = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is MariaDB?',
      'options': [
        'A NoSQL database',
        'A relational database',
        'A cloud storage service',
        'A programming language'
      ],
      'answer': 'A relational database'
    },
    {
      'question': 'MariaDB is a fork of which database?',
      'options': ['PostgreSQL', 'MongoDB', 'MySQL', 'SQLite'],
      'answer': 'MySQL'
    },
    {
      'question': 'Which query is used to retrieve data from a MariaDB database?',
      'options': ['INSERT', 'UPDATE', 'SELECT', 'DELETE'],
      'answer': 'SELECT'
    },
    {
      'question': 'What is the command to create a database in MariaDB?',
      'options': [
        'CREATE TABLE',
        'CREATE DATABASE',
        'CREATE DB',
        'NEW DATABASE'
      ],
      'answer': 'CREATE DATABASE'
    },
    {
      'question': 'What type of SQL language is MariaDB?',
      'options': ['DDL', 'DML', 'DQL', 'All of the above'],
      'answer': 'All of the above'
    },
    {
      'question': 'Which MariaDB feature helps improve performance?',
      'options': ['Indexes', 'Triggers', 'Views', 'Cursors'],
      'answer': 'Indexes'
    },
    {
      'question': 'Which command is used to delete a database in MariaDB?',
      'options': ['DELETE DATABASE', 'DROP DATABASE', 'REMOVE DB', 'TRUNCATE'],
      'answer': 'DROP DATABASE'
    },
    {
      'question': 'MariaDB supports which type of replication?',
      'options': [
        'Synchronous replication',
        'Asynchronous replication',
        'Both synchronous and asynchronous',
        'Neither'
      ],
      'answer': 'Both synchronous and asynchronous'
    },
    {
      'question': 'Which tool is commonly used to manage MariaDB?',
      'options': ['phpMyAdmin', 'Oracle SQL Developer', 'pgAdmin', 'SQLite Studio'],
      'answer': 'phpMyAdmin'
    },
    {
      'question': 'Which keyword is used to sort the result set in MariaDB?',
      'options': ['SORT BY', 'GROUP BY', 'ORDER BY', 'FILTER BY'],
      'answer': 'ORDER BY'
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
        'course': 'MariaDB', // Updated for MariaDB
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
          title: Text('MariaDB Quiz'), // Updated title for MariaDB
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
