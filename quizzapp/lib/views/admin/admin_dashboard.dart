import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Icon(Icons.question_answer),
              title: Text("Title"),
              subtitle: Text("Subtitle"),
              trailing: IconButton(
                onPressed: () {},
                icon: Icon(Icons.delete),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialogue,
        child: Icon(Icons.add),
      ),
    );
  }

  _showDialogue() {
    Get.defaultDialog(
      contentPadding: EdgeInsets.all(25),
      titlePadding: EdgeInsets.only(top: 15),
      title: "Add Quiz",
      content: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              hintText: "Enter the category name",
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: "Enter the category subtitle",
            ),
          ),
        ],
      ),
      textConfirm: "Confirm",
      textCancel: "Cancel",
      onConfirm: () {
        print('Queston saves Successfully');
      },
    );
  }
}
