import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:task_manager/presentation/controller/completed_tasks_controller.dart';
import 'package:task_manager/presentation/widget/background.dart';
import '../utility/app_colors.dart';
import '../widget/empty_list.dart';
import '../widget/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  final CompletedTasksController _completedTasksController=Get.find<CompletedTasksController>();

  @override
  void initState() {
    super.initState();
    _getCompletedTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: GetBuilder<CompletedTasksController>(
                builder: (controller) {
                  return Visibility(
                    visible: !controller.inProgress,
                    replacement: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.themeColor,
                      ),
                    ),
                    child: Visibility(
                      visible: controller.completedTasks.tasks?.isNotEmpty ?? false,
                      replacement: const EmptyList(),
                      child: ListView.builder(
                        itemCount: controller.completedTasks.tasks?.length ?? 0,
                        itemBuilder: (context,index){
                          return TaskCard(task: controller.completedTasks.tasks![index],reloadFunction: _getCompletedTasks,);
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
    );
  }

  Future<void> _getCompletedTasks()async{
    bool result=await _completedTasksController.getCompletedTasks();
    if(!result){
      EasyLoading.showToast('Error fetching tasks list',toastPosition: EasyLoadingToastPosition.bottom);
    }
  }
}

