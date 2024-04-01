import 'package:get/get.dart';
import 'package:task_manager/data/model/reponse_model.dart';
import '../../data/model/task_list_response.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

class ProgressTasksController extends GetxController{
  bool _inProgress=false;
  bool _isSuccess=false;
  TaskList _progressTasks=TaskList();

  bool get inProgress => _inProgress;
  TaskList get progressTasks => _progressTasks;

  Future<bool> getProgressTasks()async{
    _inProgress=true;
    update();
    ResponseObject response=await NetworkCaller.getRequest(Urls.progressTasks);
    if(response.isSuccess){
      _progressTasks=TaskList.fromJson(response.responseBody);
      _isSuccess=true;
    }else{
      _isSuccess=false;
    }
    _inProgress=false;
    update();
    return _isSuccess;
  }
}