import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/presentation/screen/Auth/set_password.dart';
import 'package:task_manager/presentation/screen/Auth/sign_in.dart';
import 'package:task_manager/presentation/utility/app_colors.dart';
import 'package:task_manager/presentation/widget/background.dart';

import '../../../data/service/network_caller.dart';
import '../../../data/utils/urls.dart';

class PinVerifyScreen extends StatefulWidget {
  const PinVerifyScreen({super.key, required this.email});

  final String email;

  @override
  State<PinVerifyScreen> createState() => _PinVerifyScreenState();
}

class _PinVerifyScreenState extends State<PinVerifyScreen> {
  final _pinTEController=TextEditingController();
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
                  const SizedBox(height: 120,),
                  Text('OTP Verification',style: Theme.of(context).textTheme.titleLarge,),
                  Padding(
                    padding: const EdgeInsets.only(right: 32,left: 4),
                    child: Text(
                      'Enter the 6 digit OTP sent to your email.',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                  const SizedBox(height: 16,),
                  PinCodeTextField(
                    keyboardType: TextInputType.number,
                    length: 6,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      inactiveColor: Colors.grey[200],
                      selectedFillColor: AppColors.themeColor,
                      selectedColor: AppColors.themeColor
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    controller: _pinTEController,
                    beforeTextPaste: (text) {
                      EasyLoading.showToast('My Tasks pasted from clipboard\n$text',toastPosition: EasyLoadingToastPosition.bottom);
                      return true;
                    },
                    appContext: context,
                  ),
                  const SizedBox(height: 16,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (){
                        if(_formKey.currentState!.validate()){
                          _checkOtp();
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
                            Get.to(()=>SignInScreen());
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

  Future<void> _checkOtp()async{
    EasyLoading.show(status: 'Verifying OTP');
    await NetworkCaller.getRequest(Urls.recoverOTPCheck(widget.email,_pinTEController.text.trim())).then((value) {
      if(value.isSuccess && value.responseBody['status']=='success'){
        EasyLoading.showToast('OTP verified',toastPosition: EasyLoadingToastPosition.bottom);
        Get.offAll(()=>SetPassword(email: widget.email,pin: _pinTEController.text));
      }else{
        EasyLoading.showToast('Failed OTP match',toastPosition: EasyLoadingToastPosition.bottom);
      }
      EasyLoading.dismiss();
    });
  }
}
