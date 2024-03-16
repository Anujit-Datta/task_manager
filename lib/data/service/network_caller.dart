import 'dart:convert';
import 'package:http/http.dart';
import 'dart:developer';
import 'package:task_manager/data/model/reponse_model.dart';
import 'package:task_manager/presentation/controller/shared_preference.dart';
class NetworkCaller{
  static Future<ResponseObject> getRequest(String url)async{
    try{
      final Response response = await get(Uri.parse(url),headers: {'token':Local.accessToken});
      log(response.statusCode.toString());
      log(response.body);

      if (response.statusCode == 200) {
        return ResponseObject(
            isSuccess: true,
            statusCode: 200,
            responseBody: jsonDecode(response.body));
      } else {
        return ResponseObject(
            isSuccess: false, statusCode: response.statusCode, responseBody: '');
      }
    }catch(e){
      return ResponseObject(isSuccess: false, statusCode: -1, responseBody: '',errorMessage: e.toString());
    }
  }

  static Future<ResponseObject> postRequest(String url,Map<String,dynamic> body)async{
    try{
      final Response response = await post(Uri.parse(url),body: jsonEncode(body),headers: {'Content-type':'application/json','token':Local.accessToken});
      log(response.statusCode.toString());
      log(response.body);

      if (response.statusCode == 200) {
        return ResponseObject(
            isSuccess: true,
            statusCode: 200,
            responseBody: jsonDecode(response.body));
      } else {
        return ResponseObject(
            isSuccess: false, statusCode: response.statusCode, responseBody: '');
      }
    }catch(e){
      return ResponseObject(isSuccess: false, statusCode: -1, responseBody: '',errorMessage: e.toString());
    }
  }
}