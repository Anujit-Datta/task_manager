import 'package:get/get.dart';
import 'package:task_manager/data/model/reponse_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

class AddTaskController extends GetxController{
  String? _errorMessage;
  bool _isSuccess=false;

  String get errorMessage => _errorMessage ?? '';

  Future<bool> addTask(String name,String description) async {
    Map<String,dynamic> taskData={
      "title": name,
      "description": description,
      "status":"New"
    };

    ResponseObject response=await NetworkCaller.postRequest(Urls.createTask, taskData);
    if(response.isSuccess){
      _isSuccess=true;
    }else{
      _errorMessage=response.errorMessage.toString();
      _isSuccess= false;
    }
    return _isSuccess;
  }
}