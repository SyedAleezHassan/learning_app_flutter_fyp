import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FigmaQuizPage extends StatefulWidget {
  @override
  _FigmaQuizPageState createState() => _FigmaQuizPageState();
}

class _FigmaQuizPageState extends State<FigmaQuizPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  String? _userEmail;
  String? _studentName;
  bool _quizCompleted = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is Figma?',
      'options': [
        'A database tool',
        'A design tool',
        'A programming language',
        'An operating system'
      ],
      'answer': 'A design tool'
    },
    {
      'question': 'Which company developed Figma?',
      'options': ['Adobe', 'Google', 'Figma Inc.', 'Microsoft'],
      'answer': 'Figma Inc.'
    },
    {
      'question': 'Which file format is commonly used to export Figma designs?',
      'options': ['JPG', 'SVG', 'HTML', 'DOCX'],
      'answer': 'SVG'
    },
    {
      'question': 'What is the main use of Figma?',
      'options': [
        'Web development',
        'UI/UX design',
        'Video editing',
        'Database management'
      ],
      'answer': 'UI/UX design'
    },
    {
      'question': 'Which feature in Figma is used for real-time collaboration?',
      'options': ['Live Editing', 'Team Workspaces', 'Multiplayer', 'Co-design'],
      'answer': 'Multiplayer'
    },
    {
      'question': 'What is the Frame tool used for in Figma?',
      'options': [
        'To create animations',
        'To create responsive layouts',
        'To manage code',
        'To style text'
      ],
      'answer': 'To create responsive layouts'
    },
    {
      'question': 'Which design principle is crucial for UI/UX design?',
      'options': [
        'Consistency',
        'Complexity',
        'Minimalism',
        'Decoration'
      ],
      'answer': 'Consistency'
    },
    {
      'question': 'Which Figma feature allows for component reusability?',
      'options': ['Prototypes', 'Pages', 'Components', 'Styles'],
      'answer': 'Components'
    },
    {
      'question': 'How can you share a Figma project?',
      'options': [
        'By exporting as PDF',
        'By sharing a live link',
        'By email attachment',
        'By saving to Dropbox'
      ],
      'answer': 'By sharing a live link'
    },
    {
      'question': 'What are Figma’s primary design tools?',
      'options': ['Vector networks', 'Layer styles', 'Frames', 'All of the above'],
      'answer': 'All of the above'
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
        'course': 'Figma', // Updated for Figma
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
          title: Text('Figma Quiz'), // Updated title for Figma
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
