import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/data/model/user_model.dart';

class Local{
  static String accessToken='';
  static Future<void> saveData(UserModel user)async {
    SharedPreferences sharedPref= await SharedPreferences.getInstance();
    await sharedPref.setString('data', jsonEncode(user.toJson()));
  }

  static Future<UserModel?> getData()async {
    SharedPreferences sharedPref= await SharedPreferences.getInstance();
    String? data=sharedPref.getString('data');
    if(data==null){
      return null;
    }
    return UserModel.fromJson(jsonDecode(data));
  }

  static Future<void> saveToken(String token)async {
    SharedPreferences sharedPref= await SharedPreferences.getInstance();
    await sharedPref.setString('token', token);
    accessToken=token;
  }

  static Future<String?> getToken()async {
    SharedPreferences sharedPref= await SharedPreferences.getInstance();
    String? token=sharedPref.getString('token');
    if(token==null){
      return null;
    }
    return token;
  }

  static Future<bool> isLoggedIn()async {
    final token = await getToken();
    accessToken=token??'';
    return token!=null;
  }

  static Future<void> clear()async {
    SharedPreferences sharedPref= await SharedPreferences.getInstance();
    await sharedPref.clear();
  }


}