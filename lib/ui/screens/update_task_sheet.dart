
import 'package:flutter/material.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class UpdateTaskSheet extends StatefulWidget {
  final VoidCallback onUpdate;
  final TaskData task;
  const UpdateTaskSheet({super.key, required this.task, required this.onUpdate});

  @override
  State<UpdateTaskSheet> createState() => _UpdateTaskSheetState();
}

class _UpdateTaskSheetState extends State<UpdateTaskSheet> {
  late TextEditingController _titleTEController;
  late TextEditingController _descriptionTEController;
  bool _updateTaskInProgress = false;

  @override
  void initState() {
    super.initState();
    _titleTEController =
        TextEditingController(text: widget. task.title);
    _descriptionTEController =
        TextEditingController(text: widget.task.description);
  }
  Future<void> updateTask() async {
    _updateTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
    await NetworkCaller().postRequest(Urls.createTask, <String, dynamic>{
      "title": _titleTEController.text.trim(),
      "description": _descriptionTEController.text.trim(),
      "status": "New"
    });
    _updateTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      _titleTEController.clear();
      _descriptionTEController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task update successful')));
      }
      widget.onUpdate();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Task update failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Update Task',
                    style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon:const  Icon(Icons.close))
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: _titleTEController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: _descriptionTEController,
              maxLines: 4,
              decoration: const InputDecoration(hintText: 'Description'),

            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
                width: double.infinity,
                child: Visibility(
                  visible: _updateTaskInProgress == false,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: ElevatedButton(
                      onPressed: () {
                        updateTask();
                      }, child: const Text('Update')),
                ))
          ],
        ),
      ),
    );
  }
}