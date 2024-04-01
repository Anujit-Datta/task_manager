import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:task_manager/presentation/utility/validations.dart';
import 'package:task_manager/presentation/widget/background.dart';
import 'package:task_manager/presentation/widget/profile_bar.dart';
import '../controller/add_task_controller.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _taskNameTEController=TextEditingController();
  final _taskDescriptionTEController=TextEditingController();
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  final _addTaskController=Get.find<AddTaskController>();

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
    bool result=await _addTaskController.addTask(_taskNameTEController.text, _taskDescriptionTEController.text);
    if(result){
      EasyLoading.showToast('Task Added',toastPosition: EasyLoadingToastPosition.bottom);
      Get.back(result: true);
    }else{
      EasyLoading.showToast(_addTaskController.errorMessage.toString(),toastPosition: EasyLoadingToastPosition.bottom);
    }
      EasyLoading.dismiss();
  }

  @override
  void dispose() {
    _taskNameTEController.dispose();
    _taskDescriptionTEController.dispose();
    super.dispose();
  }
}
