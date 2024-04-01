import 'package:get/get.dart';
import 'package:task_manager/data/model/reponse_model.dart';
import '../../data/model/task_list_response.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

class CancelledTasksController extends GetxController{
  bool _inProgress=false;
  bool _isSuccess=false;
  TaskList _cancelledTasks=TaskList();

  bool get inProgress => _inProgress;
  TaskList get cancelledTasks => _cancelledTasks;

  Future<bool> getCancelledTasks()async{
    _inProgress=true;
    update();
    ResponseObject response=await NetworkCaller.getRequest(Urls.cancelledTasks);
    if(response.isSuccess){
      _cancelledTasks=TaskList.fromJson(response.responseBody);
      _isSuccess=true;
    }else{
      _isSuccess=false;
    }
    _inProgress=false;
    update();
    return _isSuccess;
  }
}