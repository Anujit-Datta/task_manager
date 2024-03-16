import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:task_manager/data/model/login_response_model.dart';
import 'package:task_manager/data/model/user_model.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/presentation/controller/shared_preference.dart';
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const EmailVerifyScreen()));
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
                          if(mounted){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const SignUpScreen()));
                          }
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
    Map<String,dynamic> loginData={
      "email": _emailTEController.text.trim(),
      "password": _passwordTEController.text.trim(),
    };
    await NetworkCaller.postRequest(Urls.login, loginData).then((value) {
      if(value.isSuccess){
        LoginResponseModel loginResponse= LoginResponseModel.fromJson(value.responseBody);
        Local.saveData(loginResponse.data!);
        Local.saveToken(loginResponse.token!);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
      }else{
        EasyLoading.showError(value.errorMessage.toString());
      }
      EasyLoading.dismiss();
    });
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
