import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quizzapp/models/category_model.dart';
import 'package:quizzapp/views/quiz_category_item.dart';

class QuizCategoryScreen extends StatelessWidget {
  const QuizCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('category').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final allCategory = snapshot.data?.docs;
        List<CategoryModel> allCategoryList = [];

        for (var e in allCategory!) {
          allCategoryList.add(CategoryModel.fromJson(e.data(), e.id));
        }

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text('Start your quiz'),
            automaticallyImplyLeading: false,
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              SvgPicture.asset(
                'assets/bg.svg',
              ),
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: allCategoryList.length,
                itemBuilder: (contex, index) {
                  return QuizCategoryItem(
                    allCategoryList[index],
                    isStart: index == 0,
                    isEnd: index == allCategoryList.length - 1,
                    task: allCategoryList.length,
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
