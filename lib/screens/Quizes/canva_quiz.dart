import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CanvaQuizPage extends StatefulWidget {
  @override
  _CanvaQuizPageState createState() => _CanvaQuizPageState();
}

class _CanvaQuizPageState extends State<CanvaQuizPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  String? _userEmail;
  String? _studentName;
  bool _quizCompleted = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is Canva primarily used for?',
      'options': ['Video editing', 'Graphic design', 'Programming', 'Database management'],
      'answer': 'Graphic design'
    },
    {
      'question': 'Which platform owns Canva?',
      'options': ['Adobe', 'Canva Inc.', 'Microsoft', 'Google'],
      'answer': 'Canva Inc.'
    },
    {
      'question': 'What can you create using Canva?',
      'options': ['Presentations', 'Social media posts', 'Marketing materials', 'All of the above'],
      'answer': 'All of the above'
    },
    {
      'question': 'Canva allows you to collaborate with others in real-time. True or False?',
      'options': ['True', 'False'],
      'answer': 'True'
    },
    {
      'question': 'Which of the following is a popular feature in Canva?',
      'options': ['Presentation mode', 'Code editor', 'Audio production', '3D modeling'],
      'answer': 'Presentation mode'
    },
    {
      'question': 'What type of tool is Canva?',
      'options': ['Web-based', 'Desktop only', 'Mobile only', 'None of the above'],
      'answer': 'Web-based'
    },
    {
      'question': 'Can you use Canva for free?',
      'options': ['Yes, fully free', 'Only with a subscription', 'Free with limited features', 'No'],
      'answer': 'Free with limited features'
    },
    {
      'question': 'Which of these file types can you export from Canva?',
      'options': ['JPG', 'PNG', 'PDF', 'All of the above'],
      'answer': 'All of the above'
    },
    {
      'question': 'Which Canva feature is used to create designs from scratch?',
      'options': ['Templates', 'Blank Canvas', 'Pre-made Designs', 'Auto Design'],
      'answer': 'Blank Canvas'
    },
    {
      'question': 'What is a brand kit in Canva?',
      'options': ['A collection of fonts and colors', 'A video editing tool', 'A programming language', 'A type of database'],
      'answer': 'A collection of fonts and colors'
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
        'course': 'Canva', // Updated for Canva
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
          title: Text('Canva Quiz'), // Updated title for Canva
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
