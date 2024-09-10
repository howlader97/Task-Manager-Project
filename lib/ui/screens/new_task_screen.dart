import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/screens/update_task_sheet.dart';
import 'package:task_manager/ui/screens/update_task_status_sheet.dart';
import 'package:task_manager/ui/state_managers/new_task_controller.dart';
import 'package:task_manager/ui/state_managers/summary_count_controller.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/summary_card.dart';
import 'package:task_manager/ui/widgets/task_list_tile.dart';
import 'package:task_manager/ui/widgets/user_profile_appbar.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {

  final SummaryCountController _summaryCountController =
  Get.find<SummaryCountController>();
  final NewTaskController _newTaskController=Get.find<NewTaskController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _summaryCountController.getCountSummary();
      _newTaskController.getNewTask();
    });
  }

  /**Future<void> getNewTask() async {
    _getNewTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.newTask);
    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.body!);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('get new task data failed')));
      }
    }
    _getNewTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }*/

  Future<void> deleteTask(String taskId) async {
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.deleteTask(taskId));
    if (response.isSuccess) {
      if (mounted) {
        setState(() {});
      }
     // _taskListModel.data!.removeWhere((element) => element.sId == taskId);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Deletion data get failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Column(
          children: [
            const UserProfileAppbar(),
            GetBuilder<SummaryCountController>(builder: (_) {
              if (_summaryCountController.getCountSummaryInProgress) {
                return const Center(
                  child: LinearProgressIndicator(),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 80,
                  width: double.infinity,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                    _summaryCountController.summaryCountModel.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      return SummaryCard(
                        title: _summaryCountController.summaryCountModel.data![index].sId ?? 'New',
                        number: _summaryCountController.summaryCountModel.data![index].sum ?? 0,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        height: 0,
                      );
                    },
                  ),
                ),
              );
            }),
            GetBuilder<NewTaskController>(

              builder: (_) {
                if(_newTaskController.getNewTaskInProgress){
                  return const Center(child: LinearProgressIndicator(),);
                }
                return Expanded(
                    child: RefreshIndicator(
                  onRefresh: () async {
                    _newTaskController.getNewTask();
                    _summaryCountController.getCountSummary();
                  },
                  child:_newTaskController.getNewTaskInProgress
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.separated(
                          itemCount: _newTaskController.taskListModel.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            return TaskListTile(
                              data: _newTaskController.taskListModel.data![index],
                              onDeleteTap: () {
                                deleteTask(_newTaskController.taskListModel.data![index].sId!);
                              },
                              onEditTap: () {
                                // showEditBottomSheet(_taskListModel.data![index]);
                                showStatusUpdateBottomSheet(
                                    _newTaskController.taskListModel.data![index]);
                              },
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider(
                              height: 0,
                            );
                          },
                        ),
                ));
              }
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddNewTaskScreen()));
        },
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void showEditBottomSheet(TaskData task) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return UpdateTaskSheet(
            task: task,
            onUpdate: () {
              _newTaskController.getNewTask();
            },
          );
        });
  }

  void showStatusUpdateBottomSheet(TaskData task) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return UpdateTaskStatusSheet(
              task: task,
              onUpdate: () {
                _newTaskController.getNewTask();
              });
        });
  }
}
