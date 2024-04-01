import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:task_manager/presentation/controller/cancelled_tasks_controller.dart';
import 'package:task_manager/presentation/widget/background.dart';
import '../utility/app_colors.dart';
import '../widget/empty_list.dart';
import '../widget/task_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  final CancelledTasksController _cancelledTasksController=Get.find<CancelledTasksController>();

  @override
  void initState() {
    super.initState();
    _getCancelledTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: GetBuilder<CancelledTasksController>(
                builder: (controller) {
                  return Visibility(
                    visible: !controller.inProgress,
                    replacement: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.themeColor,
                      ),
                    ),
                    child: Visibility(
                      visible: controller.cancelledTasks.tasks?.isNotEmpty ?? false,
                      replacement: const EmptyList(),
                      child: ListView.builder(
                        itemCount: controller.cancelledTasks.tasks?.length ?? 0,
                        itemBuilder: (context,index){
                          return TaskCard(task: controller.cancelledTasks.tasks![index],reloadFunction: _getCancelledTasks,);
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

  Future<void> _getCancelledTasks()async{
    bool result=await _cancelledTasksController.getCancelledTasks();
    if(!result){
      EasyLoading.showToast('Error fetching tasks list',toastPosition: EasyLoadingToastPosition.bottom);
    }
  }
}

