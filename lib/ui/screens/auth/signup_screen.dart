import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/state_managers/signup_controller.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

   final GlobalKey<FormState> _formKey=GlobalKey<FormState>();

   final TextEditingController _emailTEController=TextEditingController();
   final TextEditingController _firstNameController=TextEditingController();
   final TextEditingController _lastNameTEController=TextEditingController();
   final TextEditingController _mobileTEController=TextEditingController();
   final TextEditingController _passwordTEController=TextEditingController();

  // bool _signUpInProgress=false;

  /* Future<void> userSignUp()async{
     _signUpInProgress=true;
     if(mounted){
       setState(() {});
     }
     final response= await NetworkCaller().postRequest(Urls.registration, <String,dynamic>{
         "email":_emailTEController.text.trim(),
         "firstName":_firstNameController.text.trim(),
         "lastName":_lastNameTEController.text.trim(),
         "mobile":_mobileTEController.text.trim(),
         "password":_passwordTEController.text,
         "photo":""
     });
     _signUpInProgress=false;
     if(mounted){
       setState(() {});
     }
     if(response.isSuccess){
       _emailTEController.clear();
       _firstNameController.clear();
       _lastNameTEController.clear();
       _mobileTEController.clear();
       _passwordTEController.clear();
       if(mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('Registration Successful')));
       }
     }else{
       if(mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('Registration Failed')));
       }
     }
   }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScreenBackground(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 64,
                ),
                Text('Join With Us',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _emailTEController,
                  decoration: const InputDecoration(
                    hintText: 'email',
                  ),
                  validator: (String? value){
                    if(value?.isEmpty ?? true){
                      return 'Enter valid Email';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    hintText: 'First Name',
                  ),
                  validator: (String? value){
                    if(value?.isEmpty ?? true){
                      return 'Enter valid first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _lastNameTEController,
                  decoration: const InputDecoration(
                    hintText: 'Last Name',
                  ),
                  validator: (String? value){
                    if(value?.isEmpty ?? true){
                      return 'Enter valid last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _mobileTEController,
                  decoration: const InputDecoration(
                    hintText: 'Mobile',
                  ),
                  validator: (String? value){
                    if((value?.isEmpty ?? true) || value!.length< 11){
                      return 'Enter valid mobile number';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _passwordTEController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: ' password',
                  ),
                  validator: (String? value){
                    if((value?.isEmpty ?? true) || value!.length<=5){
                      return 'Enter more than 6 digit password';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                GetBuilder<SignUpController>(
                  builder: (signUpController) {
                    return SizedBox(
                        width: double.infinity,
                          child: Visibility(
                            visible:signUpController.signUpInProgress==false,
                            replacement: const Center(child: CircularProgressIndicator(),),
                            child: ElevatedButton(
                              onPressed: () {
                                if(!_formKey.currentState!.validate()){
                                  return;
                                }
                                signUpController.userSignUp(
                                    _emailTEController.text.trim(),
                                    _firstNameController.text.trim(),
                                    _lastNameTEController.text.trim(),
                                    _mobileTEController.text.trim(),
                                   _passwordTEController.text.trim()
                                   ).then((result) => {
                                     if(result == true){
                                       Get.snackbar('Successful','Registration Successful')
                                     }else{
                                       Get.snackbar('Failed', 'Registration failed')
                                     }
                                });
                              },
                              child: const Icon(
                                Icons.arrow_circle_right_rounded,
                                color: Colors.white,
                              )

                                                ),
                          ));
                  }
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Have account ?",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, letterSpacing: 0.5),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(color: Colors.green),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
