import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/ui/widgets/user_profile_appbar.dart';

import '../../data/utils/urls.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();
  bool _addNewTaskInProgress = false;

  Future<void> addNewTask() async {
    _addNewTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.createTask, <String, dynamic>{
      "title": _titleTEController.text.trim(),
      "description": _descriptionTEController.text.trim(),
      "status": "New"
    });
    _addNewTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      _titleTEController.clear();
      _descriptionTEController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task added successful')));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Task added failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _globalKey,
          child: Column(
            children: [
              const UserProfileAppbar(),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add New Task',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _titleTEController,
                      decoration: const InputDecoration(hintText: 'Title'),
                      validator: (String? value) {
                        if (value?.isEmpty ?? true) {
                          return 'enter title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _descriptionTEController,
                      maxLines: 4,
                      decoration: const InputDecoration(hintText: 'Description'),
                      validator: (String? value) {
                        if (value?.isEmpty ?? true) {
                          return 'enter description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: Visibility(
                          visible: _addNewTaskInProgress == false,
                          replacement: const Center(
                            child: CircularProgressIndicator(),
                          ),
                          child: ElevatedButton(
                              onPressed: () {
                                if (!_globalKey.currentState!.validate()) {
                                  return;
                                }
                                addNewTask();
                              },
                              child: const Icon(Icons.arrow_forward_ios)),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
