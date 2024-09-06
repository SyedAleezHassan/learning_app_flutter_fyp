import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class IllustratorQuizPage extends StatefulWidget {
  @override
  _IllustratorQuizPageState createState() => _IllustratorQuizPageState();
}

class _IllustratorQuizPageState extends State<IllustratorQuizPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  String? _userEmail;
  String? _studentName;
  bool _quizCompleted = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is Adobe Illustrator primarily used for?',
      'options': ['Photo editing', 'Vector graphics', 'Video editing', '3D modeling'],
      'answer': 'Vector graphics'
    },
    {
      'question': 'Which tool in Illustrator is used for creating shapes?',
      'options': ['Pen Tool', 'Brush Tool', 'Shape Tool', 'Eraser Tool'],
      'answer': 'Shape Tool'
    },
    {
      'question': 'What is the function of the Pathfinder tool?',
      'options': ['Align objects', 'Create complex shapes', 'Edit paths', 'Change colors'],
      'answer': 'Create complex shapes'
    },
    {
      'question': 'What does the Direct Selection Tool do?',
      'options': ['Selects entire objects', 'Selects anchor points and paths', 'Deletes objects', 'Transforms objects'],
      'answer': 'Selects anchor points and paths'
    },
    {
      'question': 'How can you change the color of a stroke in Illustrator?',
      'options': ['Using the Color Picker', 'Using the Gradient Tool', 'Using the Shape Tool', 'Using the Eraser Tool'],
      'answer': 'Using the Color Picker'
    },
    {
      'question': 'Which panel in Illustrator is used to manage layers?',
      'options': ['Layers Panel', 'Tools Panel', 'Swatches Panel', 'Properties Panel'],
      'answer': 'Layers Panel'
    },
    {
      'question': 'What is a clipping mask used for?',
      'options': ['To hide parts of an object', 'To apply effects', 'To resize objects', 'To create gradients'],
      'answer': 'To hide parts of an object'
    },
    {
      'question': 'Which tool is used for drawing freeform paths in Illustrator?',
      'options': ['Pen Tool', 'Pencil Tool', 'Blob Brush Tool', 'Type Tool'],
      'answer': 'Pencil Tool'
    },
    {
      'question': 'What is the purpose of artboards in Illustrator?',
      'options': ['To organize different pages or sections', 'To apply filters', 'To group objects', 'To edit text'],
      'answer': 'To organize different pages or sections'
    },
    {
      'question': 'How do you create a new document in Adobe Illustrator?',
      'options': ['File > New', 'Edit > New', 'Window > New', 'Object > New'],
      'answer': 'File > New'
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
        'course': 'Adobe Illustrator', // Course name set to Adobe Illustrator
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
          title: Text('Adobe Illustrator Quiz'), // Updated title for Adobe Illustrator
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
