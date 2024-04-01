import 'dart:developer';

import 'package:get/get.dart';
import 'package:task_manager/data/model/reponse_model.dart';
import 'package:task_manager/presentation/controller/shared_preference.dart';

import '../../data/model/login_response_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

class SignInController extends GetxController{
  String? _errorMessage;

  String get errorMessage => _errorMessage ?? '';

  Future<bool> signIn(String email,String password) async {
    Map<String,dynamic> loginData={
      "email": email,
      "password": password,
    };

    ResponseObject response=await NetworkCaller.postRequest(Urls.login, loginData,fromLogin: true);
    if(response.isSuccess){
      LoginResponseModel loginResponse= LoginResponseModel.fromJson(response.responseBody);
      await Local.saveData(loginResponse.data!);
      await Local.saveToken(loginResponse.token!);
      log(loginResponse.token.toString());
      log(Local.accessToken.toString());
      return true;
    }else{
      _errorMessage=response.errorMessage.toString();
      return false;
    }
  }
}