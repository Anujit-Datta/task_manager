import 'package:task_manager/data/model/task_per_status_count.dart';

class TaskCountByStatus {
  String? status;
  List<TaskCount>? data=[];

  TaskCountByStatus({this.status, this.data});

  TaskCountByStatus.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (status=='success' && json['data'] != null) {
      data = <TaskCount>[
        TaskCount(statusId: 'New', count: 0),
        TaskCount(statusId: 'Progress', count: 0),
        TaskCount(statusId: 'Cancelled', count: 0),
        TaskCount(statusId: 'Completed', count: 0),
      ];
      json['data'].forEach((v) {
        for (var datum in data!) {
          if (datum.statusId == v['_id']) {
            datum.count = v['sum'];
          }
        }
      });
    }else{
      status='failed';
      data = <TaskCount>[
        TaskCount(statusId: 'New', count: 0),
        TaskCount(statusId: 'Progress', count: 0),
        TaskCount(statusId: 'Cancelled', count: 0),
        TaskCount(statusId: 'Completed', count: 0),
      ];
    }
  }
}
