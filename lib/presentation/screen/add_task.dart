import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/presentation/utility/validations.dart';
import 'package:task_manager/presentation/widget/background.dart';
import 'package:task_manager/presentation/widget/profile_bar.dart';
import '../../data/utils/urls.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _taskNameTEController=TextEditingController();
  final _taskDescriptionTEController=TextEditingController();
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileBar,
      body: Background(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50,),
                  Text('Add New Task',style: Theme.of(context).textTheme.titleLarge,),
                  const SizedBox(height: 16,),
                  TextFormField(
                    controller: _taskNameTEController,
                    decoration: const InputDecoration(
                      labelText: 'Subject',
                    ),
                    validator: (value) => normalValidation(value,'Subject'),
                  ),
                  const SizedBox(height: 16,),
                  TextFormField(
                    controller: _taskDescriptionTEController,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      alignLabelWithHint: true
                    ),
                    validator: (value) => normalValidation(value,'Description'),
                  ),
                  const SizedBox(height: 24,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (){
                        if(_formKey.currentState!.validate()){
                          addTask();
                        }
                      },
                      child: const Icon(
                        Icons.arrow_circle_right_outlined,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addTask()async{
    EasyLoading.show(status: 'Adding',dismissOnTap: false);
    Map<String,dynamic> task={
      "title": _taskNameTEController.text.trim(),
      "description":_taskDescriptionTEController.text.trim(),
      "status":"New"
    };
    await NetworkCaller.postRequest(Urls.createTask, task).then((value) {
      if(value.isSuccess){
        EasyLoading.showToast('Task Added',toastPosition: EasyLoadingToastPosition.bottom);
        if(mounted){
          Navigator.pop(context);
        }
      }else{
        EasyLoading.showToast(value.errorMessage.toString(),toastPosition: EasyLoadingToastPosition.bottom);
      }
      EasyLoading.dismiss();
    });

  }

  @override
  void dispose() {
    _taskNameTEController.dispose();
    _taskDescriptionTEController.dispose();
    super.dispose();
  }
}
