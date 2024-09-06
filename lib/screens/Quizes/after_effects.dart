import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AfterEffectsQuizPage extends StatefulWidget {
  @override
  _AfterEffectsQuizPageState createState() => _AfterEffectsQuizPageState();
}

class _AfterEffectsQuizPageState extends State<AfterEffectsQuizPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  String? _userEmail;
  String? _studentName;
  bool _quizCompleted = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is Adobe After Effects used for?',
      'options': ['Photo editing', 'Motion graphics and visual effects', '3D modeling', 'Web design'],
      'answer': 'Motion graphics and visual effects'
    },
    {
      'question': 'Which panel is used to manage and organize layers?',
      'options': ['Project Panel', 'Timeline Panel', 'Effects Panel', 'Composition Panel'],
      'answer': 'Timeline Panel'
    },
    {
      'question': 'What is the purpose of keyframes in After Effects?',
      'options': ['To add text to a composition', 'To animate properties over time', 'To apply effects', 'To create masks'],
      'answer': 'To animate properties over time'
    },
    {
      'question': 'Which tool is used to create and edit masks?',
      'options': ['Pen Tool', 'Selection Tool', 'Shape Tool', 'Type Tool'],
      'answer': 'Pen Tool'
    },
    {
      'question': 'What is a composition in After Effects?',
      'options': ['A container for layers and effects', 'A type of animation preset', 'A rendered video file', 'A color adjustment'],
      'answer': 'A container for layers and effects'
    },
    {
      'question': 'How can you preview your animation in After Effects?',
      'options': ['Using the RAM Preview', 'Using the Render Queue', 'Using the Timeline Panel', 'Using the Effects Panel'],
      'answer': 'Using the RAM Preview'
    },
    {
      'question': 'What is the purpose of the Render Queue in After Effects?',
      'options': ['To organize layers', 'To apply effects', 'To render final output', 'To create masks'],
      'answer': 'To render final output'
    },
    {
      'question': 'Which panel allows you to apply effects to layers?',
      'options': ['Effects & Presets Panel', 'Project Panel', 'Timeline Panel', 'Composition Panel'],
      'answer': 'Effects & Presets Panel'
    },
    {
      'question': 'What does the term "rendering" refer to in After Effects?',
      'options': ['Creating and saving project files', 'Applying filters to layers', 'Generating the final video output', 'Exporting assets'],
      'answer': 'Generating the final video output'
    },
    {
      'question': 'What is a "precomposition" in After Effects?',
      'options': ['A project file', 'A composition within a composition', 'A type of animation', 'A rendered output'],
      'answer': 'A composition within a composition'
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
        'course': 'Adobe After Effects', // Course name set to Adobe After Effects
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
          title: Text('Adobe After Effects Quiz'), // Updated title for Adobe After Effects
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
