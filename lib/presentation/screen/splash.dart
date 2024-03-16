import 'package:flutter/material.dart';
import 'package:task_manager/presentation/screen/home.dart';
import 'package:task_manager/presentation/widget/background.dart';
import '../controller/shared_preference.dart';
import '../widget/app_logo.dart';
import 'Auth/sign_in.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    splashTimer();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Background(
        child: Center(
          child: AppLogo(),
        ),
      ),
    );
  }

  Future<void> splashTimer()async{
    if(mounted){
      await Future.delayed(const Duration(seconds: 2)).then((v) async {
        if(await Local.isLoggedIn()) {
          if(mounted) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          }
        }else{
          if(mounted) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const SignInScreen()));
          }
        }
      });
    }
  }
}

