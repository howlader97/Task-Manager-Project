import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/ui/widgets/task_list_tile.dart';

import 'package:task_manager/ui/widgets/user_profile_appbar.dart';

import '../../data/utils/urls.dart';

class InProgressTaskScreen extends StatefulWidget {
  const InProgressTaskScreen({super.key});

  @override
  State<InProgressTaskScreen> createState() => _InProgressTaskScreenState();
}

class _InProgressTaskScreenState extends State<InProgressTaskScreen> {
  bool _getProgressInProgress = false;
  TaskListModel _taskListModel = TaskListModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      getInProgressTask();
    });
  }

  Future<void> getInProgressTask() async {
    _getProgressInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.inProgressTask);
    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.body!);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Inprogress data get failed')));
      }
    }
    _getProgressInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const UserProfileAppbar(),
            Expanded(
                child: _getProgressInProgress
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.separated(
                        itemCount: _taskListModel.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          return TaskListTile(
                            data: _taskListModel.data![index],
                            onDeleteTap: () { },
                            onEditTap: () {},
                          );
                          //return const TaskListTile();
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(
                            height: 0,
                          );
                        },
                      ))
          ],
        ),
      ),
    );
  }
}
