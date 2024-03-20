import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:task_manager/presentation/screen/Auth/sign_in.dart';
import 'package:task_manager/presentation/utility/validations.dart';
import 'package:task_manager/presentation/widget/background.dart';

import '../../../data/service/network_caller.dart';
import '../../../data/utils/urls.dart';

class SetPassword extends StatefulWidget {
  const SetPassword({super.key, required this.pin, required this.email});

  final String email;
  final String pin;

  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  final _password1TEController=TextEditingController();
  final _password2TEController=TextEditingController();
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
                  const SizedBox(height: 100,),
                  Text('Get Started With',style: Theme.of(context).textTheme.titleLarge,),
                  const SizedBox(height: 16,),
                  TextFormField(
                    controller: _password1TEController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    validator: (value) => passwordValidation(value),
                  ),
                  const SizedBox(height: 16,),
                  TextFormField(
                    controller: _password2TEController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Repeat Password',
                    ),
                    validator: (value) => passwordValidation(value),
                  ),
                  const SizedBox(height: 16,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (){
                        if(_formKey.currentState!.validate()){
                          _resetPassword();
                        }
                      },
                      child: const Icon(
                        Icons.arrow_circle_right_outlined,
                      ),
                    ),
                  ),
                  const SizedBox(height: 60,),
                  //const SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Have account?"),
                      TextButton(
                        onPressed: (){
                          if(mounted){
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const SignInScreen()),(route)=>false);
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
  
  Future<void> _resetPassword()async{
    if(_password1TEController.text==_password2TEController.text){
      EasyLoading.show(status: 'Resetting Password');
      await NetworkCaller.postRequest(Urls.recoverResetPassword, {
        'email': widget.email,
        'OTP': widget.pin,
        'password': _password1TEController.text,
      }).then((value) {
        if(value.isSuccess && value.responseBody['status']=='success'){
          EasyLoading.showToast('Password reset successfully, Now Sign in',toastPosition: EasyLoadingToastPosition.bottom);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const SignInScreen()),(route)=>false);
        }else{
          EasyLoading.showToast('Password Reset failed, try again',toastPosition: EasyLoadingToastPosition.bottom);
        }
        EasyLoading.dismiss();
      });
    }else{
      EasyLoading.showError("Both password don't matched",);
    }
  }
  
  @override
  void dispose() {
    _password1TEController.dispose();
    _password2TEController.dispose();
    super.dispose();
  }
}
