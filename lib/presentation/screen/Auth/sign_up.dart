import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
                          if(mounted){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const SignInScreen()));
                          }
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
      "photo":"",
    };
    await NetworkCaller.postRequest(Urls.registration, userData).then((value) {
      if(value.isSuccess){
        EasyLoading.showToast('Signed up successfully, now sign in',toastPosition: EasyLoadingToastPosition.bottom);
        if(mounted){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SignInScreen()), (route) => false);
        }
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
