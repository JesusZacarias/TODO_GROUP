import 'package:flutter/material.dart';
import 'package:todo_list/models/group.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/objectbox.g.dart';

class TaskScreen extends StatefulWidget {
  final Group group;
  final Store store;
  TaskScreen({Key? key, required this.group, required this.store})
      : super(key: key);

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final textController = TextEditingController();

  final _task = <Task>[];

  void _onSave() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.group.name}\'s Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'Task',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              color: Colors.blue,
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Create Task',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: _onSave,
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _task.length,
                itemBuilder: (context, index) {
                  
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
