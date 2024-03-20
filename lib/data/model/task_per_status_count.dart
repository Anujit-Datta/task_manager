class TaskCount {
  String? statusId;
  int? count;

  TaskCount({this.statusId, this.count});

  TaskCount.fromJson(Map<String, dynamic> json) {
    statusId = json['_id'];
    count = json['sum'];
  }
}