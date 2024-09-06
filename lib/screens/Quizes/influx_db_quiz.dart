import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InfluxDBQuizPage extends StatefulWidget {
  @override
  _InfluxDBQuizPageState createState() => _InfluxDBQuizPageState();
}

class _InfluxDBQuizPageState extends State<InfluxDBQuizPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  String? _userEmail;
  String? _studentName;
  bool _quizCompleted = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What type of database is InfluxDB?',
      'options': ['Relational', 'Time-Series', 'Document', 'Graph'],
      'answer': 'Time-Series'
    },
    {
      'question': 'Which query language does InfluxDB use?',
      'options': ['Flux', 'SQL', 'GraphQL', 'Cypher'],
      'answer': 'Flux'
    },
    {
      'question': 'What is a common use case for InfluxDB?',
      'options': ['Storing time-series data', 'Document storage', 'Graph analysis', 'Relational data'],
      'answer': 'Storing time-series data'
    },
    {
      'question': 'How does InfluxDB handle high write loads?',
      'options': ['Using a write-ahead log', 'In-memory storage', 'Sharding', 'Partitioning'],
      'answer': 'Sharding'
    },
    {
      'question': 'Which component of InfluxDB is used for querying?',
      'options': ['Telegraf', 'Chronograf', 'Kapacitor', 'InfluxQL'],
      'answer': 'InfluxQL'
    },
    {
      'question': 'What is the purpose of Telegraf in the InfluxDB ecosystem?',
      'options': ['Data collection', 'Data visualization', 'Data processing', 'Data storage'],
      'answer': 'Data collection'
    },
    {
      'question': 'Which tool is used for visualizing data in InfluxDB?',
      'options': ['Grafana', 'Kibana', 'Metabase', 'Tableau'],
      'answer': 'Grafana'
    },
    {
      'question': 'How does InfluxDB handle data retention?',
      'options': ['Using retention policies', 'Archiving data', 'Sharding', 'Partitioning'],
      'answer': 'Using retention policies'
    },
    {
      'question': 'Which of the following is a key feature of InfluxDB?',
      'options': ['ACID Transactions', 'Schema-less data storage', 'Graph relationships', 'Document versioning'],
      'answer': 'Schema-less data storage'
    },
    {
      'question': 'Which InfluxDB component is used for alerting and data processing?',
      'options': ['Chronograf', 'Telegraf', 'Kapacitor', 'InfluxDB'],
      'answer': 'Kapacitor'
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
        'course': 'InfluxDB', // Course name set to InfluxDB
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
          title: Text('InfluxDB Quiz'), // Updated title for InfluxDB
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
