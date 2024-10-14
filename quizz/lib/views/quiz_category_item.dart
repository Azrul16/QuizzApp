import 'package:flutter/material.dart';
import 'package:quizzapp/models/category_model.dart';

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
    return Card(
      child: GestureDetector(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.question_answer),
            Text(allCategory.title),
            Text(allCategory.subTitle),
          ],
        ),
      ),
    );
  }
}
