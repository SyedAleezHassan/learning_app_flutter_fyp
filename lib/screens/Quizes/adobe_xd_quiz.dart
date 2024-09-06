import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdobeXDQuizPage extends StatefulWidget {
  @override
  _AdobeXDQuizPageState createState() => _AdobeXDQuizPageState();
}

class _AdobeXDQuizPageState extends State<AdobeXDQuizPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  String? _userEmail;
  String? _studentName;
  bool _quizCompleted = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is Adobe XD primarily used for?',
      'options': [
        'Photo editing',
        'UI/UX design and prototyping',
        'Video editing',
        '3D modeling'
      ],
      'answer': 'UI/UX design and prototyping'
    },
    {
      'question': 'Which feature in Adobe XD allows interactive prototypes?',
      'options': ['Layers', 'Artboards', 'Prototyping', 'Assets panel'],
      'answer': 'Prototyping'
    },
    {
      'question': 'Adobe XD is available for which platforms?',
      'options': ['Windows and macOS', 'iOS only', 'Windows only', 'Linux'],
      'answer': 'Windows and macOS'
    },
    {
      'question': 'Which file extension is used for Adobe XD projects?',
      'options': ['.xd', '.psd', '.ai', '.xdx'],
      'answer': '.xd'
    },
    {
      'question': 'Which tool is used to create vector shapes in Adobe XD?',
      'options': ['Pen tool', 'Text tool', 'Move tool', 'Eyedropper tool'],
      'answer': 'Pen tool'
    },
    {
      'question': 'Which Adobe product is best integrated with Adobe XD for design?',
      'options': ['Photoshop', 'Premiere Pro', 'Lightroom', 'After Effects'],
      'answer': 'Photoshop'
    },
    {
      'question': 'What is a key feature of Adobe XD that helps in design collaboration?',
      'options': ['Share for Review', 'Export as PNG', 'Color Picker', 'Shape tool'],
      'answer': 'Share for Review'
    },
    {
      'question': 'Which panel in Adobe XD stores reusable components?',
      'options': ['Layers panel', 'Components panel', 'Assets panel', 'History panel'],
      'answer': 'Assets panel'
    },
    {
      'question': 'What does the Repeat Grid tool in Adobe XD do?',
      'options': [
        'Create grids for layout',
        'Duplicate objects in a grid pattern',
        'Align layers',
        'Group artboards together'
      ],
      'answer': 'Duplicate objects in a grid pattern'
    },
    {
      'question': 'Can you create animations in Adobe XD?',
      'options': ['Yes', 'No', 'Only in the paid version', 'With plugins only'],
      'answer': 'Yes'
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
        'course': 'Adobe XD', // Updated for Adobe XD
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
          title: Text('Adobe XD Quiz'), // Updated title for Adobe XD
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
