import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:task_manager/data/model/user_model.dart';
import 'package:task_manager/presentation/controller/globals.dart';
import 'package:task_manager/presentation/screen/home.dart';
import 'package:task_manager/presentation/utility/validations.dart';
import 'package:task_manager/presentation/widget/background.dart';
import 'package:task_manager/presentation/widget/profile_bar.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';
import '../controller/shared_preference.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _emailTEController=TextEditingController();
  final _firstNameTEController=TextEditingController();
  final _lastNameTEController=TextEditingController();
  final _mobileTEController=TextEditingController();
  final _passwordTEController=TextEditingController();
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    appBarActive=false;
    _emailTEController.text=Local.user!.email ?? '';
    _firstNameTEController.text=Local.user!.firstName ?? '';
    _lastNameTEController.text=Local.user!.lastName ?? '';
    _mobileTEController.text=Local.user!.mobile ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileBar,
      body: Background(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(48),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40,),
                  Text('Update Profile',style: Theme.of(context).textTheme.titleLarge,),
                  const SizedBox(height: 16,),
                  imagePickerContainer(),
                  const SizedBox(height: 16,),
                  TextFormField(
                    controller: _emailTEController,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: _emailTEController.text,
                    ),
                  ),
                  const SizedBox(height: 12,),
                  TextFormField(
                    controller: _firstNameTEController,
                    decoration: InputDecoration(
                      labelText: _firstNameTEController.text,
                    ),
                    validator: (value) => normalValidation(value, 'First Name'),
                  ),
                  const SizedBox(height: 12,),
                  TextFormField(
                    controller: _lastNameTEController,
                    decoration: InputDecoration(
                      labelText: _lastNameTEController.text,
                    ),
                    validator: (value) => normalValidation(value, 'Last Name'),
                  ),
                  const SizedBox(height: 12,),
                  TextFormField(
                    controller: _mobileTEController,
                    maxLength: 11,
                    decoration: InputDecoration(
                      labelText: _mobileTEController.text,
                    ),
                    validator: (value) => mobileValidation(value),
                  ),
                  const SizedBox(height: 12,),
                  TextFormField(
                    controller: _passwordTEController,
                    decoration: const InputDecoration(
                      labelText: 'New Password',
                    ),
                  ),
                  const SizedBox(height: 16,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (){
                        if(_formKey.currentState!.validate()){
                          _updateProfile();
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

  Widget imagePickerContainer() {
    return GestureDetector(
      onTap: (){
        _pickImage();
      },
      child: Container(
        width: double.infinity,
        //height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10)),
                color: Colors.grey[700],
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15,horizontal: 20),
                child: Text(
                  'Upload',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10,),
            Expanded(child: Text(_pickedImage?.name ?? '',style: const TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,)),
          ],
        )
      ),
    );
  }

  void _pickImage()async{
    final pickedImage=await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedImage!=null){
      _pickedImage=pickedImage;
      if(mounted){setState(() {});}
    }
  }

  Future<void> _updateProfile() async{
    EasyLoading.show(status: 'Updating Profile');
    String? image;
    Map<String,dynamic> updatedInfo={
      'email': _emailTEController.text.trim(),
      'firstName': _firstNameTEController.text.trim(),
      'lastName': _lastNameTEController.text.trim(),
      'mobile': _mobileTEController.text.trim(),
    };
    if(_passwordTEController.text.trim().isNotEmpty){
      updatedInfo['password']=_passwordTEController.text.trim();
    }
    if(_pickedImage!=null){
      List<int> photoBytes=File(_pickedImage!.path).readAsBytesSync();
      image=base64Encode(photoBytes);
      updatedInfo['photo']=image;
    }

    await NetworkCaller.postRequest(Urls.profileUpdate, updatedInfo).then((value) async{
      if(value.isSuccess){
        if(value.responseBody['status']=='success'){
          UserModel updatedUserData=UserModel(
            photo: _pickedImage==null ? Local.user!.photo : image,
            email: Local.user!.email,
            firstName: _firstNameTEController.text.trim()!=Local.user!.firstName ? _firstNameTEController.text.trim() : Local.user!.firstName,
            lastName: _lastNameTEController.text.trim()!=Local.user!.lastName ? _lastNameTEController.text.trim() : Local.user!.lastName,
            mobile: _mobileTEController.text.trim()!=Local.user!.mobile ? _mobileTEController.text.trim() : Local.user!.mobile,
            password: _passwordTEController.text.trim()!=Local.user!.password ? _passwordTEController.text.trim() : Local.user!.password,
          );
          await Local.saveData(updatedUserData).whenComplete(() {
            EasyLoading.showToast('Profile Updated Successfully!',toastPosition: EasyLoadingToastPosition.bottom);
          });
        }
        if(mounted){Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const HomeScreen()), (route) => false);}
      }else{
        EasyLoading.showToast('Failed to update profile!',toastPosition: EasyLoadingToastPosition.bottom);
        if(!mounted){
          return;
        }
        setState(() {});
      }
      EasyLoading.dismiss();
    });



  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    appBarActive=true;
    super.dispose();
  }
}
