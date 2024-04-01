import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:task_manager/presentation/controller/task_count_by_status_controller.dart';
import 'package:task_manager/presentation/screen/add_task.dart';
import 'package:task_manager/presentation/utility/app_colors.dart';
import 'package:task_manager/presentation/widget/background.dart';
import 'package:task_manager/presentation/widget/empty_list.dart';
import '../controller/new_tasks_controller.dart';
import '../controller/shared_preference.dart';
import '../widget/dashboard_card.dart';
import '../widget/task_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final TaskCountByStatusController _taskCountByStatusController=Get.find<TaskCountByStatusController>();
  final NewTasksController _newTaskController=Get.find<NewTasksController>();

  @override
  void initState() {
    super.initState();
    Local.isLoggedIn();
    apiCalls();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: ()async{
          await apiCalls();
        },
        child: Background(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                GetBuilder<TaskCountByStatusController>(
                  builder: (controller) {
                    return Visibility(
                      visible: !controller.inProgress,
                      replacement: const Center(
                        child: LinearProgressIndicator(
                          color: AppColors.themeColor,
                        ),
                      ),
                      child: Row(
                        children: [
                          dashboardCard(context,'New',controller.taskCounts.data?[0].count ?? 0),
                          dashboardCard(context,'Progress',controller.taskCounts.data?[1].count ?? 0),
                          dashboardCard(context,'Cancelled',controller.taskCounts.data?[2].count ?? 0),
                          dashboardCard(context,'Completed',controller.taskCounts.data?[3].count ?? 0),
                        ],
                      ),
                    );
                  }
                ),
                Expanded(
                  child: GetBuilder<NewTasksController>(
                    builder: (controller) {
                      return Visibility(
                        visible: !controller.inProgress,
                        replacement: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.themeColor,
                          ),
                        ),
                        child: Visibility(
                          visible: controller.newTasks.tasks?.isNotEmpty ?? false,
                          replacement: const EmptyList(),
                          child: ListView.builder(
                            itemCount: controller.newTasks.tasks?.length ?? 0,
                            itemBuilder: (context,index){
                              return TaskCard( task: controller.newTasks.tasks![index],reloadFunction: apiCalls,);
                            },
                          ),
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          bool taskAdded= await Get.to(() => const AddTaskScreen()) ?? false;
          if(taskAdded){
            await apiCalls();
          }
        },
        backgroundColor: AppColors.themeColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)
        ),
        child: const Icon(
          Icons.add
        ),
      ),
    );
  }

  Future<void> _getTaskCountByStatus()async{
    bool result=await _taskCountByStatusController.getTaskCountByStatus();
    if(!result){
      EasyLoading.showToast('Error fetching task counts!',toastPosition: EasyLoadingToastPosition.bottom);
    }
  }

  Future<void> _getNewTasks()async{
    bool result=await _newTaskController.getNewTasks();
    if(!result){
      EasyLoading.showToast('Error fetching tasks list!',toastPosition: EasyLoadingToastPosition.bottom);
    }
  }

  Future<void> apiCalls() async {
    await _getTaskCountByStatus();
    await _getNewTasks();
  }
}

