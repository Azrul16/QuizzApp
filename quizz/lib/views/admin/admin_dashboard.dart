import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizzapp/models/category_model.dart';
import 'package:quizzapp/views/admin/admin_category_item.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
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
          appBar: AppBar(
            title: const Text("Admin Dashboard"),
            automaticallyImplyLeading: false,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showDialog(context);
            },
            child: const Icon(Icons.add),
          ),
          body: ListView.builder(
            itemCount: allCategoryList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, index) {
              return AdminCategoryItem(
                allCategoryList[index],
                isStart: index == 0,
                isEnd: index == allCategoryList.length - 1,
                task: allCategoryList.length,
              );
            },
          ),
        );
      },
    );
  }
}

TextEditingController categoryTitleController = TextEditingController();
TextEditingController categorySubTitleController = TextEditingController();
void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 16,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          width: 300,
          height: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Quiz',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                controller: categoryTitleController,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Subtitle',
                ),
                controller: categorySubTitleController,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade300, // Custom color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () async {
                      CategoryModel category = CategoryModel(
                          title: categoryTitleController.text,
                          subTitle: categorySubTitleController.text,
                          docID: '');

                      await sendCategoryToFirestore(category);
                      categoryTitleController.clear();
                      categorySubTitleController.clear();

                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    },
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> sendCategoryToFirestore(CategoryModel category) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    await firestore.collection('category').add(category.toJson());
    print('Category added to Firestore successfully');
  } catch (e) {
    print('Error adding ClassNotes to Firestore: $e');
  }
}
