import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:task_manager/presentation/controller/progress_tasks_controller.dart';
import 'package:task_manager/presentation/widget/background.dart';
import 'package:get/get.dart';
import '../utility/app_colors.dart';
import '../widget/empty_list.dart';
import '../widget/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  final ProgressTasksController _progressTasksController=Get.find<ProgressTasksController>();

  @override
  void initState() {
    super.initState();
    _getProgressTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: GetBuilder<ProgressTasksController>(
                builder: (controller) {
                  return Visibility(
                    visible: !_progressTasksController.inProgress,
                    replacement: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.themeColor,
                      ),
                    ),
                    child: Visibility(
                      visible: controller.progressTasks.tasks?.isNotEmpty ?? false,
                      replacement: const EmptyList(),
                      child: ListView.builder(
                        itemCount: controller.progressTasks.tasks?.length ?? 0,
                        itemBuilder: (context,index){
                          return TaskCard(task: controller.progressTasks.tasks![index],reloadFunction: _getProgressTasks,);
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

  Future<void> _getProgressTasks()async{
    bool result=await _progressTasksController.getProgressTasks();
    if(!result){
      EasyLoading.showToast('Error fetching tasks list',toastPosition: EasyLoadingToastPosition.bottom);
    }
  }
}

