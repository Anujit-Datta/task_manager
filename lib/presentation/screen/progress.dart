import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:task_manager/presentation/widget/background.dart';
import '../../data/model/task_list_response.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';
import '../utility/app_colors.dart';
import '../widget/empty_list.dart';
import '../widget/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  bool _progressTasksListLoading=false;
  TaskList progressTasks=TaskList();

  @override
  void initState() {
    super.initState();
    _getProgressTasks();
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
                visible: !_progressTasksListLoading,
                replacement: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.themeColor,
                  ),
                ),
                child: Visibility(
                  visible: progressTasks.tasks?.isNotEmpty ?? false,
                  replacement: const EmptyList(),
                  child: ListView.builder(
                    itemCount: progressTasks.tasks?.length ?? 0,
                    itemBuilder: (context,index){
                      return TaskCard(task: progressTasks.tasks![index],reloadFunction: _getProgressTasks,);
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

  Future<void> _getProgressTasks()async{
    _progressTasksListLoading=true;
    if(mounted){setState(() {});}
    await NetworkCaller.getRequest(Urls.progressTasks).then((value) {
      if(value.isSuccess){
        progressTasks=TaskList.fromJson(value.responseBody);
      }else{
        EasyLoading.showToast('Failed to get new tasks list!',toastPosition: EasyLoadingToastPosition.bottom);
      }
      _progressTasksListLoading=false;
      if(mounted){setState(() {});}
    });
  }
}

