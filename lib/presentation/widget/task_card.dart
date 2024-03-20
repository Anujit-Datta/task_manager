import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/presentation/utility/app_colors.dart';

import '../../data/model/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.reloadFunction,
  });

  final Task task;
  final Function reloadFunction;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 16,bottom: 8,left: 16,right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task.title!,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600
              ),
            ),
            Text(
              widget.task.description!,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
            const SizedBox(height: 5,),
            Text(
              'Date: ${widget.task.creationDate!}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,

              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              height: 18,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: _statusColor(widget.task.status!),
                    ),
                    child: SizedBox(width: 80,child: Center(child: Text(widget.task.status!,style: const TextStyle(fontSize: 12,color: Colors.white),),),),
                  ),
                  const Expanded(child: SizedBox()),
                  IconButton(
                    onPressed: (){
                      _updateTaskStatusDialogue(widget.task.status!);
                    },
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.edit_note,size: 20,color: AppColors.themeColor,),
                  ),
                  IconButton(
                    onPressed: (){
                      _deleteConfirmationDialogue();
                    },
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.delete_forever,size: 20,color: Colors.red[300],),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _deleteConfirmationDialogue(){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Text('Delete Task?'),
        content: Text('Are you sure you want to delete the task named "${widget.task.title}"?'),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: (){
              _deleteTask();
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      );
    });
  }

  Future<void> _deleteTask()async{
    EasyLoading.show(status: 'Deleting Task',dismissOnTap: false);
    await NetworkCaller.getRequest(Urls.deleteTask(widget.task.id!)).whenComplete(() {
      EasyLoading.dismiss();
      EasyLoading.showToast('Task deleted successfully.',toastPosition: EasyLoadingToastPosition.bottom);
    });
    widget.reloadFunction();
  }

  Color _statusColor(String status){
    switch(status){
      case 'New':
        return Colors.lightBlue[300]!;
      case 'Progress':
        return Colors.purple[400]!;
      case 'Cancelled':
        return Colors.red[300]!;
      case 'Completed':
        return AppColors.themeColor;
      default:
        return Colors.transparent;
    }
  }

  List<String> statusList=['New','Progress','Cancelled','Completed'];

  void _updateTaskStatusDialogue(String status){
    showDialog(context: navigatorKey.currentState!.context, builder: (context){
      return AlertDialog(
        title: const Text('Update Task Status'),
        content: StatefulBuilder(
          builder: (context,setState){
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 250,
                  width: 170,
                  child: ListView.separated(
                    itemCount: 4,
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 5,); // You can replace this with your custom widget
                      },
                    itemBuilder: (context,index){
                      return Container(
                        height: 55,
                        width: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50) ,
                          color: status==statusList[index]?_statusColor(statusList[index]):Colors.transparent,
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          title: Text(statusList[index]),
                          trailing: status==statusList[index]? const Icon(Icons.check):null,
                          onTap: (){
                            status=statusList[index];
                            if(mounted){setState(() {});}
                          },
                        ),
                      );
                    }
                  ),
                )
              ],
            );
          }
        ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: (){
              _updateTask(status);
            },
            child: const Text('Update'),
          ),
        ],
      );
    });
  }

  Future<void> _updateTask(String status)async{
    EasyLoading.show(status: 'Updating Task Status',dismissOnTap: false);
    await NetworkCaller.getRequest(Urls.updateTaskStatus(widget.task.id!,status)).then((value) {
      if(value.isSuccess){
        widget.reloadFunction();
        if(mounted){Navigator.pop(context);}
        EasyLoading.showToast('Task status updated successfully.',toastPosition: EasyLoadingToastPosition.bottom);
      }else{
        EasyLoading.showToast('Failed to update task status!',toastPosition: EasyLoadingToastPosition.bottom);
      }
      EasyLoading.dismiss();
    });
  }
}
