import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzapp/models/category_model.dart';
import 'package:quizzapp/views/question_page.dart';

class QuizCategoryItem extends StatelessWidget {
  const QuizCategoryItem(this.allCategory,
      {super.key,
      required this.isStart,
      required this.isEnd,
      required this.task});

  final CategoryModel allCategory;
  final bool isStart;
  final bool isEnd;
  final int task;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          QuestionPage(
            docID: allCategory.docID,
          ),
        );
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.question_answer),
            const SizedBox(
              height: 10,
            ),
            Text(
              allCategory.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              allCategory.subTitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
