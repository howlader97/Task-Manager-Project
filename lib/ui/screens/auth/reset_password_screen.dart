import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/auth/login_screen.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../../../data/models/network_response.dart';
import '../../../data/services/network_caller.dart';
import '../../../data/utils/urls.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email, otp;

  const ResetPasswordScreen(
      {super.key, required this.email, required this.otp});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _setPasswordInProgress = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> resetPassword() async {
    _setPasswordInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final Map<String, dynamic> requestBody = {
      "email": widget.email,
      "OTP": widget.otp,
      "password": _passwordController.text
    };
    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.resetPassword, requestBody);

    _setPasswordInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password Reset successfully')));
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Reset Password  has been failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScreenBackground(
      child: SingleChildScrollView(
        child: SafeArea(
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
                  Text('Set Password',
                      style: Theme.of(context).textTheme.titleLarge),
                  Text(
                      'Minimum length password 8 character with letter and number combination',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey)),
                  const SizedBox(
                    height: 8,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                   TextFormField(
                     controller: _passwordController,
                    decoration: const InputDecoration(
                      hintText: 'password',
                    ),
                       validator: (String? value){
                         if(value?.isEmpty ?? true){
                           return 'Enter your password';
                         }
                         return null;
                       }
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      hintText: 'Confirm password',
                    ),
                    validator: (String? value){
                      if(value?.isEmpty ?? true){
                        return 'Enter your confirm password';
                      }else if(value! != _passwordController.text){
                        return 'Confirm Password does not match';
                      }
                      return null;
                    }
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if(!_formKey.currentState!.validate()){
                            return;
                          }
                          resetPassword();
                        },
                        child: const Text(
                          'Confirm',
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
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
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                                (route) => false);
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
      ),
    ));
  }
}
