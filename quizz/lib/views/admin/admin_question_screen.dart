import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzapp/models/question_models.dart';

class AdminQuestionScreen extends StatelessWidget {
  const AdminQuestionScreen(
      {super.key, required this.title, required this.docID});

  final String title;
  final String docID;

  @override
  Widget build(BuildContext context) {
    TextEditingController ques = TextEditingController();
    TextEditingController ans = TextEditingController();
    TextEditingController op1 = TextEditingController();
    TextEditingController op2 = TextEditingController();
    TextEditingController op3 = TextEditingController();
    TextEditingController op4 = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add question to $title'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Question",
                ),
                controller: ques,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Option 1",
                  ),
                  controller: op1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Option 2",
                  ),
                  controller: op2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Option 3",
                  ),
                  controller: op3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Option 4",
                  ),
                  controller: op4,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Correct answer",
                  ),
                  controller: ans,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      print(docID);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Question question = Question(
                        question: ques.text,
                        category: title,
                        options1: op1.text,
                        options2: op2.text,
                        options3: op3.text,
                        options4: op4.text,
                        answer: ans.text,
                        id: '',
                      );
                      await sendQuestionToFirestore(question, docID);
                      Get.back();
                      Get.snackbar("Saved", "Question saved successfully");
                    },
                    child: const Text('Save'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> sendQuestionToFirestore(Question question, String docID) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    await firestore
        .collection('category')
        .doc(docID)
        .collection('Questions')
        .add(question.toJson());
    print('Question added to Category successfully');
  } catch (e) {
    print('Error adding ClassNotes to Firestore: $e');
  }
}
