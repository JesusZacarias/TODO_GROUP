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
    final description = textController.text.trim();

    if (description.isNotEmpty) {
      textController.clear();
      final task = Task(description: description);
      task.group.target = widget.group;
      widget.store.box<Task>().put(task);
      _reloadTasks();
    }
  }

  void _reloadTasks() {
    _task.clear();
    QueryBuilder<Task> builder = widget.store.box<Task>().query();
    builder.link(Task_.group, Group_.id.equals(widget.group.id));
    Query<Task> query = builder.build();
    List<Task> taskResult = query.find();
    setState(() {
      _task.addAll(taskResult);
    });
    query.close();
  }

  void _onUpdate(int index, bool completed) {
    final task = _task[index];
    task.completed = completed;
    widget.store.box<Task>().put(task);
    _reloadTasks();
  }

  void _onDelete(Task task) {
    widget.store.box<Task>().remove(task.id);
    _reloadTasks();
  }

  @override
  void initState() {
    _task.addAll(List.from(widget.group.tasks));
    super.initState();
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
              onPressed: _onSave,
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Create Task',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _task.length,
                itemBuilder: (context, index) {
                  final task = _task[index];
                  return ListTile(
                    title: Text(
                      task.description,
                      style: TextStyle(
                        decoration:
                            task.completed ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    leading: Checkbox(
                      value: task.completed,
                      onChanged: (val) => _onUpdate(index, val!),
                    ),
                    trailing: IconButton(
                      onPressed: () => _onDelete(task),
                      icon: const Icon(Icons.close),
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
