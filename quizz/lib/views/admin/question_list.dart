import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
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
    Future<void> delete(String qID) async {
      try {
        await FirebaseFirestore.instance
            .collection('category')
            .doc(widget.docID)
            .collection('Questions')
            .doc(qID)
            .delete();
      } catch (error) {
        print('Error deleting class: $error');
      }
      print(qID);
      Get.back();
    }

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
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  Dialogs.bottomMaterialDialog(
                                    msg:
                                        'Are you sure? you want to delete this question?',
                                    title: 'Delete',
                                    context: context,
                                    // ignore: deprecated_member_use
                                    actions: [
                                      IconsOutlineButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        text: 'Cancel',
                                        iconData: Icons.cancel_outlined,
                                        textStyle:
                                            const TextStyle(color: Colors.grey),
                                        iconColor: Colors.grey,
                                      ),
                                      IconsButton(
                                        onPressed: () async {
                                          await delete(documents[index].id);
                                        },
                                        text: 'Delete',
                                        iconData: Icons.delete,
                                        color: Colors.red,
                                        textStyle: const TextStyle(
                                            color: Colors.white),
                                        iconColor: Colors.white,
                                      ),
                                    ],
                                  );
                                },
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
