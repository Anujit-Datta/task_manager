import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:task_manager/app.dart';
import 'dart:developer';
import 'package:task_manager/data/model/reponse_model.dart';
import 'package:task_manager/presentation/controller/shared_preference.dart';

import '../../presentation/screen/Auth/sign_in.dart';
class NetworkCaller{
  static Future<ResponseObject> getRequest(String url)async{
    try{
      final Response response = await get(Uri.parse(url),headers: {'token':Local.accessToken?? ''});
      log(response.statusCode.toString());
      log(response.body);

      if (response.statusCode == 200) {
        return ResponseObject(
            isSuccess: true,
            statusCode: 200,
            responseBody: jsonDecode(response.body));
      } else if(response.statusCode==401){
          _moveToSignIn();
        return ResponseObject(
            isSuccess: false, statusCode: response.statusCode, responseBody: '');
      }else {
        return ResponseObject(
            isSuccess: false, statusCode: response.statusCode, responseBody: '');
      }
    }catch(e){
      return ResponseObject(isSuccess: false, statusCode: -1, responseBody: '',errorMessage: e.toString());
    }
  }

  static Future<ResponseObject> postRequest(String url,Map<String,dynamic> body,{bool fromLogin=false})async{
    try{
      final Response response = await post(Uri.parse(url),body: jsonEncode(body),headers: {'Content-type':'application/json','token':Local.accessToken?? ''});
      log(response.statusCode.toString());
      log(response.body);

      if (response.statusCode == 200) {
        return ResponseObject(
            isSuccess: true,
            statusCode: 200,
            responseBody: jsonDecode(response.body));
      } else if(response.statusCode == 401){
        if(!fromLogin){
          _moveToSignIn();
        }else{
          EasyLoading.showToast('Invalid Email or Password',toastPosition: EasyLoadingToastPosition.bottom);
        }
        return ResponseObject(
            isSuccess: false, statusCode: response.statusCode, responseBody: '',errorMessage: 'Invalid Email or Password');
      }else {
        return ResponseObject(
            isSuccess: false, statusCode: response.statusCode, responseBody: '');
      }
    }catch(e){
      return ResponseObject(isSuccess: false, statusCode: -1, responseBody: '',errorMessage: e.toString());
    }
  }

  static _moveToSignIn()async{
    EasyLoading.showToast('Session Expired, Please Login Again',toastPosition: EasyLoadingToastPosition.bottom);
    await Local.clear();
    navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const SignInScreen()), (route) => false);
  }
}