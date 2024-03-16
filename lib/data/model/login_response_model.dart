import 'package:task_manager/data/model/user_model.dart';

class LoginResponseModel {
  String? status;
  String? token;
  UserModel? data;

  LoginResponseModel({this.status, this.token, this.data});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    data = json['data'] != null ? UserModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['status'] = status;
    json['token'] = token;
    if (data != null) {
      json['data'] = data!.toJson();
    }else{
      json['data'] = '';
    }
    return json;
  }
}
