import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzapp/controllers/question_controller.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final QuestionController questionController = Get.put(QuestionController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
      ),
      body: GetBuilder<QuestionController>(
        builder: (controller) {
          return ListView.builder(
            itemCount: controller.savedCategories.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.question_answer),
                  title: Text(
                    controller.savedCategories[index],
                  ),
                  subtitle: Text(
                    controller.savedSubtitle[index],
                  ),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.delete),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialogue,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> uploadCategoryToFirebase(
      String title, String description) async {
    // Reference to the Firestore collection "category"
    CollectionReference categories =
        FirebaseFirestore.instance.collection('category');

    // Create a new document with the provided title and description
    try {
      await categories.add({
        'title': title, // Title of the package
        'description': description, // Description of the package
        'createdAt': FieldValue
            .serverTimestamp() // Timestamp for when the data is uploaded
      });

      print("Package uploaded successfully.");
    } catch (e) {
      print("Failed to upload package: $e");
    }
  }

  TextEditingController categoryTitleController = TextEditingController();
  TextEditingController categorySubTitleController = TextEditingController();
  _showDialogue() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(25),
      titlePadding: const EdgeInsets.only(top: 15),
      title: "Add Quiz",
      content: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              hintText: "Enter the category name",
            ),
            controller: categoryTitleController,
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: "Enter the category subtitle",
            ),
            controller: categorySubTitleController,
          ),
        ],
      ),
      textConfirm: "Confirm",
      textCancel: "Cancel",
      onConfirm: () {
        categorySubTitleController.clear();
        categoryTitleController.clear();
        print('Queston saves Successfully');
        questionController.savedQuestionCategoryToSharedPreference(
            categoryTitleController.text, categorySubTitleController.text);
        uploadCategoryToFirebase(
            categoryTitleController.text, categorySubTitleController.text);
        Get.back();
      },
    );
  }
}
