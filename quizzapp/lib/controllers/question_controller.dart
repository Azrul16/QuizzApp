import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzapp/models/question_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionController extends GetxController {
  final List<Question> _questions = [];
  List<Question> get question => _questions;

  final String _categoryKey = "Category Title";
  final String _subtitleKey = "Subtitle";

  TextEditingController categoryTitleController = TextEditingController();
  TextEditingController categorySubTitleController = TextEditingController();

  RxList<String> savedCategories = <String>[].obs;
  RxList<String> savedSubtitle = <String>[].obs;

  void savedQuestionCategoryToSharedPreference(
      String title, String subtitle) async {
    final prefs = await SharedPreferences.getInstance();
    savedCategories.add(title);
    print('-------------------------------');
    print(title);
    savedSubtitle.add(subtitle);
    await prefs.setStringList(_categoryKey, savedCategories);
    await prefs.setStringList(_subtitleKey, savedSubtitle);

    categorySubTitleController.clear();
    categoryTitleController.clear();
    Get.snackbar("Saved", "Category created successfully");
    update();
  }

  void loadQuestionCaegortyFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final categories = prefs.getStringList(_categoryKey) ?? [];
    final subTitle = prefs.getStringList(_subtitleKey) ?? [];

    savedCategories.assignAll(categories);
    savedSubtitle.assignAll(subTitle);
    update();
  }
}
