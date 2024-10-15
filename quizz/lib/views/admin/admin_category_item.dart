import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzapp/models/category_model.dart';
import 'package:quizzapp/views/admin/question_list.dart';

class AdminCategoryItem extends StatelessWidget {
  const AdminCategoryItem(
    this.allCategory, {
    super.key,
    required this.isStart,
    required this.isEnd,
    required this.task,
  });
  final CategoryModel allCategory;
  final bool isStart;
  final bool isEnd;
  final int task;

  Future<void> delete() async {
    try {
      await FirebaseFirestore.instance
          .collection('category')
          .doc(allCategory.docID)
          .delete();
    } catch (error) {
      print('Error deleting class: $error');
    }
    print(allCategory.docID);
  }

  @override
  Widget build(BuildContext context) {
    void showDeleteDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete'),
            content: const Text('Are you sure you want to delete this class?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              TextButton(
                onPressed: () async {
                  await delete();
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );
    }

    return GestureDetector(
      onTap: () {
        print('Gesture detector detected');
        Get.to(
          QuestionList(
            docID: allCategory.docID,
            title: allCategory.title,
          ),
        );
      },
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.question_answer),
          title: Text(allCategory.title),
          subtitle: Text(allCategory.subTitle),
          trailing: IconButton(
            onPressed: () {
              showDeleteDialog(context);
            },
            icon: const Icon(Icons.delete),
          ),
        ),
      ),
    );
  }
}
