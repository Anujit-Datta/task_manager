import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:task_manager/presentation/controller/globals.dart';
import 'package:task_manager/presentation/controller/shared_preference.dart';
import 'package:task_manager/presentation/screen/Auth/sign_in.dart';
import '../../app.dart';
import '../screen/update_profile.dart';
import '../utility/app_colors.dart';

AppBar get profileBar {
  String photo=Local.user?.photo ?? '';
  if(photo.contains('base64,')){
    List l=photo.split('base64,');
    photo=l[1];
  }
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: AppColors.themeColor,
    title: GestureDetector(
      onTap: (){
        if(appBarActive){
          navigatorKey.currentState!.push(MaterialPageRoute(
              builder: (context) => const UpdateProfileScreen()));
        }
      },
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage:const AssetImage('asset/image/user-male-circle.png'),
            foregroundImage: MemoryImage(base64Decode(photo==''?defaultImage:photo)),
          ),
          const SizedBox(width: 6,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Local.user!.name!,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white
                ),
              ),
              Text(
                Local.user!.email!,
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w400
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    actions: [
      IconButton(
        onPressed: (){
          Local.clear();
          navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const SignInScreen()), (route) => false);
        },
        icon: const Icon(
          Icons.logout_rounded,
          color: Colors.white,
        ),
      ),
    ],
  );
}
