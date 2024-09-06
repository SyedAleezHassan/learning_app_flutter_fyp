import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PhotoshopQuizPage extends StatefulWidget {
  @override
  _PhotoshopQuizPageState createState() => _PhotoshopQuizPageState();
}

class _PhotoshopQuizPageState extends State<PhotoshopQuizPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  String? _userEmail;
  String? _studentName;
  bool _quizCompleted = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is Photoshop primarily used for?',
      'options': ['Video editing', 'Photo editing', 'Sound mixing', 'Animation'],
      'answer': 'Photo editing'
    },
    {
      'question': 'Which file format is Photoshop\'s native format?',
      'options': ['JPG', 'PNG', 'PSD', 'TIFF'],
      'answer': 'PSD'
    },
    {
      'question': 'What tool is used to remove a background from an image?',
      'options': ['Brush Tool', 'Lasso Tool', 'Pen Tool', 'Magic Wand Tool'],
      'answer': 'Magic Wand Tool'
    },
    {
      'question': 'Which panel in Photoshop is used for managing layers?',
      'options': ['Layers Panel', 'Tools Panel', 'History Panel', 'Properties Panel'],
      'answer': 'Layers Panel'
    },
    {
      'question': 'What is the shortcut for copying a selection in Photoshop?',
      'options': ['Ctrl + S', 'Ctrl + X', 'Ctrl + C', 'Ctrl + V'],
      'answer': 'Ctrl + C'
    },
    {
      'question': 'Which tool is used to clone or duplicate parts of an image?',
      'options': ['Eraser Tool', 'Pen Tool', 'Clone Stamp Tool', 'Brush Tool'],
      'answer': 'Clone Stamp Tool'
    },
    {
      'question': 'Which feature allows you to apply non-destructive changes to an image?',
      'options': ['Adjustment Layers', 'Filters', 'Blending Modes', 'Masking'],
      'answer': 'Adjustment Layers'
    },
    {
      'question': 'Which file format supports transparency in Photoshop?',
      'options': ['JPG', 'GIF', 'TIFF', 'PNG'],
      'answer': 'PNG'
    },
    {
      'question': 'What is the purpose of the "History" panel in Photoshop?',
      'options': [
        'Track changes and undo steps',
        'Manage layers',
        'Apply filters',
        'Adjust colors'
      ],
      'answer': 'Track changes and undo steps'
    },
    {
      'question': 'Which blending mode lightens an image?',
      'options': ['Overlay', 'Multiply', 'Screen', 'Darken'],
      'answer': 'Screen'
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
        'course': 'Photoshop', // Updated for Photoshop
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
          title: Text('Photoshop Quiz'), // Updated title for Photoshop
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
