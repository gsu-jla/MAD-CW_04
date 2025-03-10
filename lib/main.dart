import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'plans.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PlansListScreen(),
    );
  }
}

class PlansListScreen extends StatefulWidget {
  const PlansListScreen({super.key});

  @override
  _PlansListScreenState createState() => _PlansListScreenState();
}

class _PlansListScreenState extends State<PlansListScreen> {
  late DatabaseHelper dbHelper;
  List<Map<String, dynamic>> records = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    await dbHelper.init();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    final data = await dbHelper.queryAllRows();
    setState(() {
      records = data;
    });
  }

  Future<void> _showCreatePlanModal() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreatePlanModal(dbHelper: dbHelper, reloadPlans: _loadPlans);
      },
    );
  }

  Future<void> _markAsCompleted(int id) async {
    await dbHelper.update({
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnCompleted: 1,
    });
    _loadPlans();  // Reload plans after update
  }

  Future<void> _editPlan(Map<String, dynamic> plan) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditPlanModal(
          dbHelper: dbHelper,
          plan: plan,
          reloadPlans: _loadPlans,
        );
      },
    );
  }

  Future<void> _deletePlan(int id) async {
    await dbHelper.delete(id);
    _loadPlans();  // Reload plans after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plans List(s)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _showCreatePlanModal,
              child: const Text('Create Plan'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final record = records[index];
                  final isCompleted = record['completed'] == 1;

                  return GestureDetector(
                    onLongPress: () => _editPlan(record), // Long press to edit
                    onDoubleTap: () => _deletePlan(record['id']), // Double-tap to delete
                    child: Builder(
                      builder: (context) {
                        // We need to wrap the ListTile with a GestureDetector for swipe handling
                        return GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            if (details.primaryDelta! < 0) {
                              // Swipe left gesture detected
                              _markAsCompleted(record['id']);
                            }
                          },
                          child: Container(
                            color: isCompleted ? Colors.green[100] : Colors.transparent,
                            child: ListTile(
                              title: Text(
                                record['name'],
                                style: TextStyle(
                                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              subtitle: Text("Description: ${record['plan_desc']}"),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
