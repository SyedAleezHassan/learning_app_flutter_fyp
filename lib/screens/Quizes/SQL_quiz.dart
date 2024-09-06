import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SQLQuizPage extends StatefulWidget {
  @override
  _SQLQuizPageState createState() => _SQLQuizPageState();
}

class _SQLQuizPageState extends State<SQLQuizPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  String? _userEmail;
  String? _studentName;
  bool _quizCompleted = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What does SQL stand for?',
      'options': [
        'Structured Query Language',
        'Sequential Query Language',
        'Simple Query Language',
        'Systematic Query Language'
      ],
      'answer': 'Structured Query Language'
    },
    {
      'question': 'Which SQL command is used to retrieve data from a database?',
      'options': ['INSERT', 'SELECT', 'UPDATE', 'DELETE'],
      'answer': 'SELECT'
    },
    {
      'question': 'Which clause is used to filter results in an SQL query?',
      'options': ['ORDER BY', 'WHERE', 'GROUP BY', 'HAVING'],
      'answer': 'WHERE'
    },
    {
      'question': 'What does the SQL command `JOIN` do?',
      'options': [
        'Merge two tables into one',
        'Delete records from a table',
        'Link rows from two tables',
        'Create a new table'
      ],
      'answer': 'Link rows from two tables'
    },
    {
      'question': 'Which SQL statement is used to update data in a database?',
      'options': ['UPDATE', 'INSERT', 'SELECT', 'ALTER'],
      'answer': 'UPDATE'
    },
    {
      'question': 'Which function is used to count the number of records in an SQL table?',
      'options': ['SUM()', 'COUNT()', 'AVG()', 'MAX()'],
      'answer': 'COUNT()'
    },
    {
      'question': 'What is the purpose of the SQL `GROUP BY` clause?',
      'options': [
        'To sort the result set',
        'To filter records',
        'To group rows that have the same values',
        'To join two tables'
      ],
      'answer': 'To group rows that have the same values'
    },
    {
      'question': 'Which SQL keyword is used to sort the result-set?',
      'options': ['ORDER BY', 'GROUP BY', 'SORT BY', 'WHERE'],
      'answer': 'ORDER BY'
    },
    {
      'question': 'What does the SQL `INSERT` statement do?',
      'options': [
        'Insert new data into a database',
        'Update existing data',
        'Delete data from a database',
        'Create a new table'
      ],
      'answer': 'Insert new data into a database'
    },
    {
      'question': 'Which SQL statement is used to delete data from a table?',
      'options': ['REMOVE', 'DELETE', 'TRUNCATE', 'DROP'],
      'answer': 'DELETE'
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
        'course': 'SQL', // Updated for SQL
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
          title: Text('SQL Quiz'), // Updated title for SQL
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
