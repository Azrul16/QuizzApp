import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quizzapp/models/question_models.dart';
import 'package:quizzapp/views/result_screen.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key, required this.docID});

  final String docID;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  int _remainingTime = 10;
  late Timer _timer;
  int _currentQuestionIndex = 0;
  String _selectedOption = '';
  int _score = 0; // Track user score
  List<Question> _questions = [];

  @override
  void initState() {
    super.initState();
    fetchQuestions();
    startTimer();
  }

  // Fetch questions from Firestore
  Future<void> fetchQuestions() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference questionsCollection = firestore
        .collection('category')
        .doc(widget.docID)
        .collection('Questions');

    QuerySnapshot querySnapshot = await questionsCollection.get();
    setState(() {
      _questions = querySnapshot.docs.map((doc) {
        return Question.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Start countdown timer
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _nextQuestion();
        }
      });
    });
  }

  // Fetch next question or redirect to ResultScreen
  void _nextQuestion() {
    if (_selectedOption.isNotEmpty &&
        _selectedOption == _questions[_currentQuestionIndex].answer) {
      _score++; // Increase score if the answer is correct
      Get.snackbar("Correct", "You got a correct answer");
    } else {
      Get.snackbar("Wrong",
          "Correct answer is \"${_questions[_currentQuestionIndex].answer}\"");
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _remainingTime = 10;
        _selectedOption = '';
      });
    } else {
      _timer.cancel(); // End timer
      _goToResultScreen();
    }
  }

  // Redirect to the result page
  void _goToResultScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ResultScreen(score: _score, totalQuestions: _questions.length),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$_remainingTime seconds',
          style: const TextStyle(fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // SVG Background
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/bg.svg', // Path to your bg.svg in assets folder
              fit: BoxFit.cover, // Make the SVG cover the entire background
            ),
          ),

          // Content (Quiz)
          _questions.isEmpty
              ? const Center(
                  child:
                      CircularProgressIndicator()) // Show loader until questions are fetched
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(
                          0.8), // Make the container semi-transparent
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _questions[_currentQuestionIndex].question,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildOption(
                            _questions[_currentQuestionIndex].options1),
                        _buildOption(
                            _questions[_currentQuestionIndex].options2),
                        _buildOption(
                            _questions[_currentQuestionIndex].options3),
                        _buildOption(
                            _questions[_currentQuestionIndex].options4),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          onPressed: _nextQuestion,
                          child: const Text('Next'),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  // Build Radio option
  Widget _buildOption(String option) {
    return RadioListTile<String>(
      title: Text(option,
          style: const TextStyle(fontSize: 18, color: Colors.black)),
      value: option,
      groupValue: _selectedOption,
      onChanged: (value) {
        setState(() {
          _selectedOption = value!;
        });
      },
      activeColor: Colors.blue,
    );
  }
}
