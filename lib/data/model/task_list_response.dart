
import 'package:task_manager/data/model/task_model.dart';

class TaskList {
  String? status;
  List<Task>? tasks=[];

  TaskList({this.status, this.tasks});

  TaskList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null && json['status']=='success') {
      json['data'].forEach((v) {
        tasks?.add(Task.fromJson(v));
      });
    }
  }
}