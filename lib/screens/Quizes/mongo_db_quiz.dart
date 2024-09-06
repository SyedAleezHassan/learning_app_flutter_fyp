import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MongoDBQuizPage extends StatefulWidget {
  @override
  _MongoDBQuizPageState createState() => _MongoDBQuizPageState();
}

class _MongoDBQuizPageState extends State<MongoDBQuizPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  String? _userEmail;
  String? _studentName;
  bool _quizCompleted = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What type of database is MongoDB?',
      'options': ['Relational', 'Document', 'Graph', 'Time-Series'],
      'answer': 'Document'
    },
    {
      'question': 'Which query language does MongoDB use?',
      'options': ['SQL', 'MongoDB Query Language (MQL)', 'GraphQL', 'Cypher'],
      'answer': 'MongoDB Query Language (MQL)'
    },
    {
      'question': 'What is a collection in MongoDB?',
      'options': ['A document', 'A table', 'A schema', 'A database'],
      'answer': 'A table'
    },
    {
      'question': 'Which of the following is a valid MongoDB document?',
      'options': ['{ name: "John", age: 30 }', '[ { name: "John" }, { age: 30 } ]', '<name>John</name>', 'name=John&age=30'],
      'answer': '{ name: "John", age: 30 }'
    },
    {
      'question': 'How does MongoDB store data?',
      'options': ['In tables', 'In rows', 'In documents', 'In columns'],
      'answer': 'In documents'
    },
    {
      'question': 'What is the purpose of the MongoDB Aggregation Framework?',
      'options': ['Data analysis', 'Data storage', 'Data indexing', 'Data replication'],
      'answer': 'Data analysis'
    },
    {
      'question': 'Which of the following is a valid MongoDB operator?',
      'options': ['\$gt', '\$lt', '\$in', '\$not', '\$and'],
      'answer': '\$gt'
    },
    {
      'question': 'What does the \$match stage do in MongoDB aggregation?',
      'options': ['Filters documents', 'Sorts documents', 'Groups documents', 'Projects fields'],
      'answer': 'Filters documents'
    },
    {
      'question': 'Which of the following is used for indexing in MongoDB?',
      'options': ['Indexes', 'Tables', 'Views', 'Schemas'],
      'answer': 'Indexes'
    },
    {
      'question': 'What is a shard in MongoDB?',
      'options': ['A partition of data', 'A replica set', 'A collection', 'A document'],
      'answer': 'A partition of data'
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
        'course': 'MongoDB', // Course name set to MongoDB
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
          title: Text('MongoDB Quiz'), // Updated title for MongoDB
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
