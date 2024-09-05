import 'package:flutter/material.dart';
import 'package:task_manager/data/models/auth_utility.dart';
import 'package:task_manager/data/models/login_model.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/ui/screens/auth/email_verification_screen.dart';
import 'package:task_manager/ui/screens/auth/signup_screen.dart';
import 'package:task_manager/ui/screens/bottom_nav_base_screen.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../../../data/utils/urls.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  bool _loginInProgress=false;

  Future<void> userLogin() async {
    _loginInProgress=true;
    if(mounted){
      setState(() {});
    }
    final NetworkResponse response =
        await NetworkCaller().postRequest(Urls.login, <String, dynamic>{
      "email": _emailTEController.text.trim(),
      "password": _passwordTEController.text,
    },isLogin: true);
    _loginInProgress=false;
    if(mounted){
      setState(() {});
    }
    if (response.isSuccess) {
      final LoginModel model=LoginModel.fromJson(response.body!);
      await AuthUtility.saveUserInfo(model);
      if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const BottomNavBaseScreen()),
            (route) => false);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect email or password')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScreenBackground(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _globalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Text('Get Started With',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _emailTEController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                  validator: (String? value) {
                    if (value?.isEmpty ?? true) {
                      return 'Enter valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _passwordTEController,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                  validator: (String? value) {
                    if ((value?.isEmpty ?? true) || value!.length <= 5) {
                      return 'Enter valid password';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                    width: double.infinity,
                    child: Visibility(
                      visible: _loginInProgress==false,
                      replacement:const Center(child: CircularProgressIndicator()),
                      child: ElevatedButton(
                          onPressed: () {
                            if(!_globalKey.currentState!.validate()){
                              return;
                            }
                            userLogin();
                          },
                          child: const Icon(Icons.arrow_forward_ios)),
                    )),
                const SizedBox(
                  height: 12,
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const EmailVerificationScreen()));
                    },
                    child: const Text(
                      'Forget Password ?',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't Have account ?",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, letterSpacing: 0.5),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()));
                        },
                        child: const Text(
                          'Sign Up',
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
