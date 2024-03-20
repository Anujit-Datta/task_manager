import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:task_manager/data/model/task_count_response_model.dart';
import 'package:task_manager/data/model/task_list_response.dart';
import 'package:task_manager/presentation/screen/add_task.dart';
import 'package:task_manager/presentation/utility/app_colors.dart';
import 'package:task_manager/presentation/widget/background.dart';
import 'package:task_manager/presentation/widget/empty_list.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';
import '../controller/shared_preference.dart';
import '../widget/dashboard_card.dart';
import '../widget/task_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _dashboardLoading=false;
  bool _newTasksListLoading=false;
  TaskCountByStatus taskCounts=TaskCountByStatus();
  TaskList newTasks=TaskList();

  @override
  void initState() {
    super.initState();
    Local.isLoggedIn();
    _getTaskCountByStatus();
    _getNewTasks();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: ()async{
          await apiCalls();
        },
        child: Background(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Visibility(
                  visible: !_dashboardLoading,
                  replacement: const Center(
                    child: LinearProgressIndicator(
                      color: AppColors.themeColor,
                    ),
                  ),
                  child: Row(
                    children: [
                      dashboardCard(context,'New',taskCounts.data?[0].count ?? 0),
                      dashboardCard(context,'Progress',taskCounts.data?[1].count ?? 0),
                      dashboardCard(context,'Cancelled',taskCounts.data?[2].count ?? 0),
                      dashboardCard(context,'Completed',taskCounts.data?[3].count ?? 0),
                    ],
                  ),
                ),
                Expanded(
                  child: Visibility(
                    visible: !_newTasksListLoading,
                    replacement: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.themeColor,
                      ),
                    ),
                    child: Visibility(
                      visible: newTasks.tasks?.isNotEmpty ?? false,
                      replacement: const EmptyList(),
                      child: ListView.builder(
                        itemCount: newTasks.tasks?.length ?? 0,
                        itemBuilder: (context,index){
                          return TaskCard( task: newTasks.tasks![index],reloadFunction: apiCalls,);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          bool taskAdded= await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTaskScreen()));
          if(taskAdded){
            await _getTaskCountByStatus();
            await _getNewTasks();
          }
        },
        backgroundColor: AppColors.themeColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)
        ),
        child: const Icon(
          Icons.add
        ),
      ),
    );
  }

  Future<void> _getTaskCountByStatus()async{
    _dashboardLoading=true;
    if(mounted){setState(() {});}
    await NetworkCaller.getRequest(Urls.taskStatusCount).then((value) {
      if(value.isSuccess){
        taskCounts=TaskCountByStatus.fromJson(value.responseBody);
      }else{
        taskCounts=TaskCountByStatus(status: 'failed');
        EasyLoading.showToast('Failed to get task counts!',toastPosition: EasyLoadingToastPosition.bottom);
      }
      _dashboardLoading=false;
      if(mounted){setState(() {});}
    });
  }

  Future<void> _getNewTasks()async{
    _newTasksListLoading=true;
    if(mounted){
      setState(() {});
    }
    await NetworkCaller.getRequest(Urls.newTasks).then((value) {
      if(value.isSuccess){
        newTasks=TaskList.fromJson(value.responseBody);
      }else{
        EasyLoading.showToast('Failed to get new tasks list!',toastPosition: EasyLoadingToastPosition.bottom);
      }
      _newTasksListLoading=false;
      if(mounted){
        setState(() {});
      }
    });
  }

  Future<void> apiCalls() async {
    await _getTaskCountByStatus();
    await _getNewTasks();
  }
}

