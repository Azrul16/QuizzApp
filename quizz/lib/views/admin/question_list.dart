import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzapp/views/admin/admin_question_screen.dart';

class QuestionList extends StatefulWidget {
  const QuestionList({super.key, required this.docID, required this.title});

  final String docID;
  final String title;

  @override
  State<QuestionList> createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  final CollectionReference _questionsCollection =
      FirebaseFirestore.instance.collection('category');

  void _addQuestios() {
    Get.to(
      AdminQuestionScreen(title: widget.title, docID: widget.docID),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions List'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addQuestios();
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: _questionsCollection
            .doc(widget.docID)
            .collection('Questions')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          // If data is available
          if (snapshot.hasData && snapshot.data != null) {
            List<DocumentSnapshot> documents = snapshot.data!.docs;

            if (documents.isEmpty) {
              return const Center(child: Text('No questions found'));
            }

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> questionData =
                    documents[index].data() as Map<String, dynamic>;

                return Card(
                  margin: const EdgeInsets.all(10.0),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Q${index + 1}: ${questionData['question']}',
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.delete)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Category: ${questionData['category']}',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Options:',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('1. ${questionData['options1']}'),
                        Text('2. ${questionData['options2']}'),
                        Text('3. ${questionData['options3']}'),
                        Text('4. ${questionData['options4']}'),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('No questions found'));
        },
      ),
    );
  }
}
