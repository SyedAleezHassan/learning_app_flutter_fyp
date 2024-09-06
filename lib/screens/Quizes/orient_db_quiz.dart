import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrientDBQuizPage extends StatefulWidget {
  @override
  _OrientDBQuizPageState createState() => _OrientDBQuizPageState();
}

class _OrientDBQuizPageState extends State<OrientDBQuizPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  String? _userEmail;
  String? _studentName;
  bool _quizCompleted = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What type of database is OrientDB?',
      'options': ['Relational', 'Document', 'Graph', 'Object-Oriented'],
      'answer': 'Document'
    },
    {
      'question': 'Which query language does OrientDB use?',
      'options': ['SQL', 'GraphQL', 'SPARQL', 'Cypher'],
      'answer': 'SQL'
    },
    {
      'question': 'What feature of OrientDB supports hierarchical data?',
      'options': ['Document Model', 'Graph Model', 'Relational Model', 'Object Model'],
      'answer': 'Document Model'
    },
    {
      'question': 'How does OrientDB handle relationships between data?',
      'options': ['Foreign Keys', 'Joins', 'Edges', 'Tables'],
      'answer': 'Edges'
    },
    {
      'question': 'Which of the following is a key feature of OrientDB?',
      'options': ['ACID Transactions', 'NoSQL Database', 'Graph Database', 'All of the above'],
      'answer': 'All of the above'
    },
    {
      'question': 'Can OrientDB be used for both OLTP and OLAP operations?',
      'options': ['Yes', 'No', 'Only OLTP', 'Only OLAP'],
      'answer': 'Yes'
    },
    {
      'question': 'Which API does OrientDB provide for interaction?',
      'options': ['REST API', 'GraphQL API', 'SOAP API', 'All of the above'],
      'answer': 'REST API'
    },
    {
      'question': 'Which language is OrientDB written in?',
      'options': ['Java', 'Python', 'C++', 'JavaScript'],
      'answer': 'Java'
    },
    {
      'question': 'What is the main advantage of using OrientDB over traditional relational databases?',
      'options': ['Flexible Schema', 'ACID Compliance', 'Strong Typing', 'Limited Scalability'],
      'answer': 'Flexible Schema'
    },
    {
      'question': 'Which tool is used to manage OrientDB instances?',
      'options': ['OrientDB Studio', 'Firebase Console', 'MongoDB Compass', 'SQL Server Management Studio'],
      'answer': 'OrientDB Studio'
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
        'course': 'OrientDB', // Course name set to OrientDB
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
          title: Text('OrientDB Quiz'), // Updated title for OrientDB
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
