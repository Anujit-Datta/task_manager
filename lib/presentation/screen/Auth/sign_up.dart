import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/presentation/screen/Auth/sign_in.dart';
import 'package:task_manager/presentation/utility/validations.dart';
import 'package:task_manager/presentation/widget/background.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailTEController=TextEditingController();
  final _firstNameTEController=TextEditingController();
  final _lastNameTEController=TextEditingController();
  final _mobileTEController=TextEditingController();
  final _passwordTEController=TextEditingController();
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();

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
                  const SizedBox(height: 70,),
                  Text('Join With Us',style: Theme.of(context).textTheme.titleLarge,),
                  const SizedBox(height: 16,),
                  TextFormField(
                    controller: _emailTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                    validator: (value) => emailValidation(value),
                  ),
                  const SizedBox(height: 12,),
                  TextFormField(
                    controller: _firstNameTEController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                    ),
                    validator: (value) => normalValidation(value, 'First Name'),
                  ),
                  const SizedBox(height: 12,),
                  TextFormField(
                    controller: _lastNameTEController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                    ),
                    validator: (value) => normalValidation(value, 'Last Name'),
                  ),
                  const SizedBox(height: 12,),
                  TextFormField(
                    controller: _mobileTEController,
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                    decoration: const InputDecoration(
                      labelText: 'Mobile',
                    ),
                    validator: (value) => mobileValidation(value),
                  ),
                  const SizedBox(height: 12,),
                  TextFormField(
                    controller: _passwordTEController,
                    keyboardType: TextInputType.visiblePassword,
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
                          signUp();
                        }
                      },
                      child: const Icon(
                        Icons.arrow_circle_right_outlined,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Have account?"),
                      TextButton(
                        onPressed: (){
                          Get.off(() => const SignInScreen());
                        },
                        child: const Text(
                          'Sign In',
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
  
  Future<void> signUp()async{
    EasyLoading.show(status: 'Signing Up',dismissOnTap: false);
    Map<String,dynamic> userData={
      "email":_emailTEController.text.trim(),
      "firstName":_firstNameTEController.text.trim(),
      "lastName":_lastNameTEController.text.trim(),
      "mobile":_mobileTEController.text.trim(),
      "password":_passwordTEController.text.trim(),
      //"photo":"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",
    };
    await NetworkCaller.postRequest(Urls.registration, userData).then((value) {
      if(value.isSuccess){
        EasyLoading.showToast('Signed up successfully, now sign in',toastPosition: EasyLoadingToastPosition.bottom);
        Get.offAll(() => const SignInScreen());
      }else{
        EasyLoading.showToast(value.errorMessage.toString(),toastPosition: EasyLoadingToastPosition.bottom);
      }
      EasyLoading.dismiss(animation: true);
    });

  }
  
  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
