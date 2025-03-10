import 'package:flutter/material.dart';
import 'database_helper.dart';

class CreatePlanModal extends StatefulWidget {
  final DatabaseHelper dbHelper;
  final Function reloadPlans;

  const CreatePlanModal({required this.dbHelper, required this.reloadPlans, super.key});

  @override
  _CreatePlanModalState createState() => _CreatePlanModalState();
}

class _CreatePlanModalState extends State<CreatePlanModal> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();

  Future<void> _createPlan() async {
    final name = nameController.text;
    final planDesc = descController.text;
    if (name.isNotEmpty) {
      await widget.dbHelper.insert({
        DatabaseHelper.columnName: name,
        DatabaseHelper.columnPlanDesc: planDesc,
        DatabaseHelper.columnCompleted: 0,
      });
      widget.reloadPlans(); // Reload the plans list
      Navigator.pop(context); // Close the modal
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Plan'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Plan Title'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description (optional)'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Close the modal without saving
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _createPlan,
          child: const Text('Save Plan'),
        ),
      ],
    );
  }
}
