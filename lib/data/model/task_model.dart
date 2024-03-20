class Task {
  String? id;
  String? title;
  String? description;
  String? status;
  String? creationDate;

  Task({this.id, this.title, this.description, this.status, this.creationDate});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    creationDate = json['createdDate'];
  }

}