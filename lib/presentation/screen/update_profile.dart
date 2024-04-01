import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:task_manager/presentation/controller/globals.dart';
import 'package:task_manager/presentation/controller/update_profile_controller.dart';
import 'package:task_manager/presentation/utility/validations.dart';
import 'package:task_manager/presentation/widget/background.dart';
import 'package:task_manager/presentation/widget/profile_bar.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/shared_preference.dart';
import 'home.dart';

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
  final UpdateProfileController _updateProfileController=Get.find<UpdateProfileController>();
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
                      hintText: _emailTEController.text,
                      labelText: 'Email (fixed)'
                    ),
                  ),
                  const SizedBox(height: 12,),
                  TextFormField(
                    controller: _firstNameTEController,
                    decoration: InputDecoration(
                      hintText: _firstNameTEController.text,
                      labelText: 'First Name'
                    ),
                    validator: (value) => normalValidation(value, 'First Name'),
                  ),
                  const SizedBox(height: 12,),
                  TextFormField(
                    controller: _lastNameTEController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      hintText: _lastNameTEController.text,
                    ),
                    validator: (value) => normalValidation(value, 'Last Name'),
                  ),
                  const SizedBox(height: 12,),
                  TextFormField(
                    controller: _mobileTEController,
                    maxLength: 11,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: _mobileTEController.text,
                      labelText: 'Mobile',
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
            Expanded(child: Text(_pickedImage?.name ?? 'Tap to pick an image.',style: const TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,)),
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
    bool result = await _updateProfileController.updateProfile(
      _firstNameTEController.text,
      _lastNameTEController.text,
      _mobileTEController.text,
      _passwordTEController.text,
      _pickedImage,
    );
    if(result){
      EasyLoading.showToast('Profile Updated Successfully!', toastPosition: EasyLoadingToastPosition.bottom);
      Get.offAll(()=>const HomeScreen());
    }else{
      EasyLoading.showToast(_updateProfileController.errorMessage ?? 'Profile Update Failed',toastPosition: EasyLoadingToastPosition.bottom);
    }
    if(mounted){
      setState(() {});
    }
    EasyLoading.dismiss();
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
