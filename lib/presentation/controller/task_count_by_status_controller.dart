import 'package:get/get.dart';
import 'package:task_manager/data/model/reponse_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';
import 'package:task_manager/data/model/task_count_response_model.dart';

class TaskCountByStatusController extends GetxController{
  bool _inProgress=false;
  bool _isSuccess=false;
  TaskCountByStatus _taskCounts=TaskCountByStatus();

  bool get inProgress=>_inProgress;
  TaskCountByStatus get taskCounts => _taskCounts;

  Future<bool> getTaskCountByStatus()async{
    _inProgress=true;
    update();
    ResponseObject response=await NetworkCaller.getRequest(Urls.taskStatusCount);
    if(response.isSuccess){
      _taskCounts=TaskCountByStatus.fromJson(response.responseBody);
      _isSuccess=true;
    }else{
      _taskCounts=TaskCountByStatus(status: 'failed');
      _isSuccess=false;
    }
    _inProgress=false;
    update();
    return _isSuccess;
  }
}