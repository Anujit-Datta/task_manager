import 'package:flutter/material.dart';
import 'package:task_manager/presentation/controller/globals.dart';
import 'package:task_manager/presentation/controller/shared_preference.dart';
import 'package:task_manager/presentation/screen/Auth/sign_in.dart';
import '../../app.dart';
import '../screen/update_profile.dart';
import '../utility/app_colors.dart';
import '../utility/asset_paths.dart';

AppBar get profileBar {
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
            foregroundImage: AssetImage(AssetPath.appLogoPng),
          ),
          const SizedBox(width: 6,),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                ),
              ),
              Text(
                'Email@mail.com',
                style: TextStyle(
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
