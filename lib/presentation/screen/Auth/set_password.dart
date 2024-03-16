import 'package:flutter/material.dart';
import 'package:task_manager/presentation/screen/Auth/sign_in.dart';
import 'package:task_manager/presentation/utility/validations.dart';
import 'package:task_manager/presentation/widget/background.dart';

class SetPassword extends StatefulWidget {
  const SetPassword({super.key});

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
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    validator: (value) => emailValidation(value),
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
                        // if(_formKey.currentState!.validate()){
                        //
                        // }
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SignInScreen()),(route)=>false);
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
  @override
  void dispose() {
    _password1TEController.dispose();
    _password2TEController.dispose();
    super.dispose();
  }
}
