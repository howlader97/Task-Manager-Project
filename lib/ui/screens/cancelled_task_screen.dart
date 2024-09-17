import 'package:flutter/material.dart';

import '../../data/models/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/task_list_tile.dart';
import '../widgets/user_profile_appbar.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  bool _getCancelledInProgress = false;
  TaskListModel _taskListModel = TaskListModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      getCancelledTask();
    });
  }
  Future<void> getCancelledTask() async {
    _getCancelledInProgress = true;
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
            const SnackBar(content: Text('Cancelled data get failed')));
      }
    }
    _getCancelledInProgress = false;
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
              child: _getCancelledInProgress
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
