import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:task_manager/presentation/widget/background.dart';
import '../../data/model/task_list_response.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';
import '../utility/app_colors.dart';
import '../widget/empty_list.dart';
import '../widget/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  bool _completedTasksListLoading=false;
  TaskList completedTasks=TaskList();

  @override
  void initState() {
    super.initState();
    _getCompletedTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Visibility(
                visible: !_completedTasksListLoading,
                replacement: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.themeColor,
                  ),
                ),
                child: Visibility(
                  visible: completedTasks.tasks?.isNotEmpty ?? false,
                  replacement: const EmptyList(),
                  child: ListView.builder(
                    itemCount: completedTasks.tasks?.length ?? 0,
                    itemBuilder: (context,index){
                      return TaskCard(task: completedTasks.tasks![index],reloadFunction: _getCompletedTasks,);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getCompletedTasks()async{
    _completedTasksListLoading=true;
    if(mounted){setState(() {});}
    await NetworkCaller.getRequest(Urls.completedTasks).then((value) {
      if(value.isSuccess){
        completedTasks=TaskList.fromJson(value.responseBody);
      }else{
        EasyLoading.showToast('Failed to get new tasks list!',toastPosition: EasyLoadingToastPosition.bottom);
      }
      _completedTasksListLoading=false;
      if(mounted){setState(() {});}
    });
  }
}

