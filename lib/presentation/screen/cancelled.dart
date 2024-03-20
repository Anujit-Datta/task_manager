import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:task_manager/presentation/widget/background.dart';
import '../../data/model/task_list_response.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';
import '../utility/app_colors.dart';
import '../widget/empty_list.dart';
import '../widget/task_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  bool _cancelledTasksListLoading=false;
  TaskList cancelledTasks=TaskList();

  @override
  void initState() {
    super.initState();
    _getCancelledTasks();
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
                visible: !_cancelledTasksListLoading,
                replacement: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.themeColor,
                  ),
                ),
                child: Visibility(
                  visible: cancelledTasks.tasks?.isNotEmpty ?? false,
                  replacement: const EmptyList(),
                  child: ListView.builder(
                    itemCount: cancelledTasks.tasks?.length ?? 0,
                    itemBuilder: (context,index){
                      return TaskCard(task: cancelledTasks.tasks![index],reloadFunction: _getCancelledTasks,);
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

  Future<void> _getCancelledTasks()async{
    _cancelledTasksListLoading=true;
    if(mounted){setState(() {});}
    await NetworkCaller.getRequest(Urls.cancelledTasks).then((value) {
      if(value.isSuccess){
        cancelledTasks=TaskList.fromJson(value.responseBody);
      }else{
        EasyLoading.showToast('Failed to get new tasks list!',toastPosition: EasyLoadingToastPosition.bottom);
      }
      _cancelledTasksListLoading=false;
      if(mounted){setState(() {});}
    });
  }
}

