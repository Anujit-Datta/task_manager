import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/data/model/user_model.dart';

class Local{
  static String? accessToken;
  static UserModel? user;


  static Future<void> saveData(UserModel user)async {
    SharedPreferences sharedPref= await SharedPreferences.getInstance();
    await sharedPref.setString('data', jsonEncode(user.toJson())).whenComplete(() {
      Local.user=user;
      log(Local.user!.photo.toString());
    });

  }

  static Future<UserModel?> getData()async {
    SharedPreferences sharedPref= await SharedPreferences.getInstance();
    String? data=sharedPref.getString('data');
    if(data==null){
      return null;
    }
    UserModel user= UserModel.fromJson(jsonDecode(data));
    Local.user=user;
    return user;
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
    accessToken=token;
    bool loginState= token!=null;
    if(loginState){
      final user=await getData();
      Local.user=user;
    }
    return loginState;
  }

  static Future<void> clear()async {
    SharedPreferences sharedPref= await SharedPreferences.getInstance();
    await sharedPref.clear();
  }


}