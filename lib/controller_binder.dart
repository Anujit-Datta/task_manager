import 'package:get/get.dart';
import 'package:task_manager/presentation/controller/add_task_controller.dart';
import 'package:task_manager/presentation/controller/cancelled_tasks_controller.dart';
import 'package:task_manager/presentation/controller/completed_tasks_controller.dart';
import 'package:task_manager/presentation/controller/new_tasks_controller.dart';
import 'package:task_manager/presentation/controller/progress_tasks_controller.dart';
import 'package:task_manager/presentation/controller/sign_in_controller.dart';
import 'package:task_manager/presentation/controller/task_count_by_status_controller.dart';
import 'package:task_manager/presentation/controller/update_profile_controller.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    Get.put(SignInController());
    Get.put(TaskCountByStatusController());
    Get.put(NewTasksController());
    Get.put(ProgressTasksController());
    Get.put(CancelledTasksController());
    Get.put(CompletedTasksController());
    Get.put(AddTaskController());
    Get.put(UpdateProfileController());
  }
}