import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:task_manager/presentation/controller/sign_in_controller.dart';
import 'package:task_manager/presentation/screen/Auth/email_varification.dart';
import 'package:task_manager/presentation/screen/home.dart';
import 'package:task_manager/presentation/screen/Auth/sign_up.dart';
import 'package:task_manager/presentation/utility/validations.dart';
import 'package:task_manager/presentation/widget/background.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailTEController=TextEditingController();
  final _passwordTEController=TextEditingController();
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  final SignInController _signInController=Get.find<SignInController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(48),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100,),
                  Text('Get Started With',style: Theme.of(context).textTheme.titleLarge,),
                  const SizedBox(height: 16,),
                  TextFormField(
                    controller: _emailTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    validator: (value) => emailValidation(value),
                  ),
                  const SizedBox(height: 16,),
                  TextFormField(
                    controller: _passwordTEController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    validator: (value) => passwordValidation(value),
                  ),
                  const SizedBox(height: 16,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (){
                        if(_formKey.currentState!.validate()){
                          signIn();
                        }
                      },
                      child: const Icon(
                        Icons.arrow_circle_right_outlined,
                      ),
                    ),
                  ),
                  const SizedBox(height: 60,),
                  Center(
                    child: TextButton(
                      onPressed: (){
                        Get.to(()=>const EmailVerifyScreen());
                      },
                      child: const Text(
                        'Forgot Password?',
                      ),
                    ),
                  ),
                  //const SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have account?"),
                      TextButton(
                        onPressed: (){
                          Get.off(() => const SignUpScreen());
                        },
                        child: const Text(
                          'Sign Up',
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signIn()async {
    EasyLoading.show(status: 'Signing in',dismissOnTap: false);
    bool signInStatus=await _signInController.signIn(_emailTEController.text.trim(), _passwordTEController.text.trim());
    if(signInStatus){
      EasyLoading.showToast('Login Success',toastPosition: EasyLoadingToastPosition.bottom);
      Get.offAll(() => const HomeScreen());
    }else{
      EasyLoading.showToast(_signInController.errorMessage,toastPosition: EasyLoadingToastPosition.bottom);
    }
    EasyLoading.dismiss();
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
