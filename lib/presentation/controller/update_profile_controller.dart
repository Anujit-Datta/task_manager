import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/presentation/controller/shared_preference.dart';

import '../../data/model/user_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

class UpdateProfileController extends GetxController {
  bool _isSuccess=false;
  String? _errorMessage;

  String? get errorMessage=>_errorMessage;

  Future<bool> updateProfile(String firstName,String lastName, String mobile,String password,XFile? newImage ) async{
    String? image;
    Map<String,dynamic> updatedInfo={
      'firstName': firstName,
      'lastName': lastName,
      'mobile': mobile,
    };
    if(password.isNotEmpty){
      updatedInfo['password']=password;
    }
    if(newImage!=null){
      List<int> photoBytes=File(newImage.path).readAsBytesSync();
      image=base64Encode(photoBytes);
      updatedInfo['photo']=image;
    }

    await NetworkCaller.postRequest(Urls.profileUpdate, updatedInfo).then((value) async{
      if(value.isSuccess){
        if(value.responseBody['status']=='success'){
          UserModel updatedUserData=UserModel(
            photo: newImage==null ? Local.user!.photo : image,
            email: Local.user!.email,
            firstName: firstName!=Local.user!.firstName ? firstName : Local.user!.firstName,
            lastName: lastName!=Local.user!.lastName ? lastName : Local.user!.lastName,
            mobile: mobile!=Local.user!.mobile ? mobile : Local.user!.mobile,
            password: password!=Local.user!.password ? password : Local.user!.password,
          );
          await Local.saveData(updatedUserData).whenComplete(() {
            _isSuccess=true;
          });
        }
      }else{
        _isSuccess=false;
        _errorMessage=value.errorMessage.toString();
      }
    });
    update();
    return _isSuccess;
  }
}