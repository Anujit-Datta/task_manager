import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:task_manager/presentation/screen/Auth/pin_verification.dart';
import 'package:task_manager/presentation/utility/validations.dart';
import 'package:task_manager/presentation/widget/background.dart';

import '../../../data/service/network_caller.dart';
import '../../../data/utils/urls.dart';

class EmailVerifyScreen extends StatefulWidget {
  const EmailVerifyScreen({super.key});

  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  final _emailTEController=TextEditingController();
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
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
                  const SizedBox(height: 120,),
                  Text('Your Email Address',style: Theme.of(context).textTheme.titleLarge,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'A 6 digit OTP will be sent to your email to verify that its yours.',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (){
                        if(_formKey.currentState!.validate()){
                          _verificationEmailSend();
                        }
                      },
                      child: const Icon(
                        Icons.arrow_circle_right_outlined,
                      ),
                    ),
                  ),
                  const SizedBox(height: 60,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Have account?",style: Theme.of(context).textTheme.labelSmall,),
                      TextButton(
                        onPressed: (){
                          if(mounted){
                            Navigator.pop(context);
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

  Future<void> _verificationEmailSend()async{
    EasyLoading.show(status: 'Sending OTP');
    await NetworkCaller.getRequest(Urls.recoverEmailSend(_emailTEController.text.trim())).then((value) {
      if(value.isSuccess && value.responseBody['status']=='success'){
        EasyLoading.showToast('OTP sent, Check email inbox/spam folder',toastPosition: EasyLoadingToastPosition.bottom);
        Navigator.push(context, MaterialPageRoute(builder: (context) => PinVerifyScreen(email: _emailTEController.text.trim(),)));
      }else{
        EasyLoading.showToast(value.errorMessage!,toastPosition: EasyLoadingToastPosition.bottom);
      }
      EasyLoading.dismiss();
    });
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}
