import 'package:flutter/material.dart';
import 'database_helper.dart';

class CreatePlanModal extends StatefulWidget {
  final DatabaseHelper dbHelper;
  final VoidCallback reloadPlans;

  const CreatePlanModal({
    Key? key,
    required this.dbHelper,
    required this.reloadPlans,
  }) : super(key: key);

  @override
  _CreatePlanModalState createState() => _CreatePlanModalState();
}

class _CreatePlanModalState extends State<CreatePlanModal> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Plan'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Plan Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a plan name';
                }
                return null;
              },
              onSaved: (value) {
                _name = value!;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
              onSaved: (value) {
                _description = value!;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  widget.dbHelper.insert({
                    'name': _name,
                    'plan_desc': _description,
                    'completed': 0
                  }).then((_) {
                    widget.reloadPlans();
                    Navigator.of(context).pop();
                  });
                }
              },
              child: const Text('Create Plan'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditPlanModal extends StatefulWidget {
  final DatabaseHelper dbHelper;
  final Map<String, dynamic> plan;
  final VoidCallback reloadPlans;

  const EditPlanModal({
    Key? key,
    required this.dbHelper,
    required this.plan,
    required this.reloadPlans,
  }) : super(key: key);

  @override
  _EditPlanModalState createState() => _EditPlanModalState();
}

class _EditPlanModalState extends State<EditPlanModal> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _description;

  @override
  void initState() {
    super.initState();
    _name = widget.plan['name'];
    _description = widget.plan['plan_desc'];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Plan'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _name,
              decoration: const InputDecoration(labelText: 'Plan Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a plan name';
                }
                return null;
              },
              onSaved: (value) {
                _name = value!;
              },
            ),
            TextFormField(
              initialValue: _description,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
              onSaved: (value) {
                _description = value!;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  widget.dbHelper.update({
                    'id': widget.plan['id'],
                    'name': _name,
                    'plan_desc': _description,
                    'completed': widget.plan['completed'],
                  }).then((_) {
                    widget.reloadPlans();
                    Navigator.of(context).pop();
                  });
                }
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
