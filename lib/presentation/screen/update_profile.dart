import 'package:flutter/material.dart';
import 'package:task_manager/presentation/controller/globals.dart';
import 'package:task_manager/presentation/screen/Auth/sign_in.dart';
import 'package:task_manager/presentation/utility/validations.dart';
import 'package:task_manager/presentation/widget/background.dart';
import 'package:task_manager/presentation/widget/profile_bar.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _emailTEController=TextEditingController();
  final _firstNameTEController=TextEditingController();
  final _lastNameTEController=TextEditingController();
  final _mobileTEController=TextEditingController();
  final _passwordTEController=TextEditingController();
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    appBarActive=false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileBar,
      body: Background(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(48),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40,),
                  Text('Update Profile',style: Theme.of(context).textTheme.titleLarge,),
                  const SizedBox(height: 16,),
                  Container(
                    width: double.infinity,
                    //height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10)),
                            color: Colors.grey[700],
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15,horizontal: 20),
                            child: Text(
                              'Upload',
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        const Text('image.jpg',style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,),
                      ],
                    )
                  ),
                  const SizedBox(height: 16,),
                  TextFormField(
                    controller: _emailTEController,
                    enabled: false,
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
                    maxLength: 11,
                    decoration: const InputDecoration(
                      labelText: 'Mobile',
                    ),
                    validator: (value) => normalValidation(value, 'Mobile Number'),
                  ),
                  const SizedBox(height: 12,),
                  TextFormField(
                    controller: _passwordTEController,
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
                        _formKey.currentState!.validate();
                      },
                      child: const Icon(
                        Icons.arrow_circle_right_outlined,
                      ),
                    ),
                  ),
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
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    appBarActive=true;
    super.dispose();
  }
}
