import 'package:flutter/material.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';


class UpdateTaskStatusSheet extends StatefulWidget {
  final TaskData task;
  final VoidCallback onUpdate;
  const UpdateTaskStatusSheet({super.key, required this.task, required this.onUpdate});

  @override
  State<UpdateTaskStatusSheet> createState() => _UpdateTaskStatusSheetState();
}

class _UpdateTaskStatusSheetState extends State<UpdateTaskStatusSheet> {
  List<String> taskStatusList = ['New', 'Progress', 'Canceled', 'Completed'];
  late String _selectedTask;
  bool _updateTaskInProgress=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedTask =widget. task.status!.toLowerCase();
  }

  Future<void> updateTask(String taskId,String newStatus) async {
    _updateTaskInProgress=true;
    if(mounted){
      setState(() {});
    }
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.updateTask(taskId, newStatus));
    _updateTaskInProgress=false;
    if(mounted){
      setState(() {});
    }
    if (response.isSuccess) {
      widget.onUpdate();
      if(mounted){
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('update task status  get failed')));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Column(
        children: [
          const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Update status')),
          Expanded(
            child: ListView.builder(
                itemCount: taskStatusList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      _selectedTask = taskStatusList[index];
                      setState(() {});
                    },
                    title: Text(taskStatusList[index].toUpperCase()),
                    trailing: _selectedTask == taskStatusList[index]
                        ? const Icon(Icons.check)
                        : null,
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Visibility(
              visible: _updateTaskInProgress== false,
              replacement: const Center(child: CircularProgressIndicator(),),
              child: ElevatedButton(
                  onPressed: () {
                   updateTask (widget.task.sId!, _selectedTask);
                  }, child: const Text('Update')),
            ),
          )
        ],
      ),
    );
  }
}

