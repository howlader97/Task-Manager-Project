import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/screens/auth/email_verification_screen.dart';
import 'package:task_manager/ui/screens/auth/signup_screen.dart';
import 'package:task_manager/ui/screens/bottom_nav_base_screen.dart';
import 'package:task_manager/ui/state_managers/login_controller.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

 // final LoginController loginController=Get.put(LoginController());

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
                GetBuilder<LoginController>(builder: (loginController) {
                  return SizedBox(
                      width: double.infinity,
                      child: Visibility(
                        visible: loginController.loginInProgress == false,
                        replacement:
                            const Center(child: CircularProgressIndicator()),
                        child: ElevatedButton(
                            onPressed: () {
                              if (!_globalKey.currentState!.validate()) {
                                return;
                              }
                              loginController.userLogin(
                                  _emailTEController.text.trim(),
                                  _passwordTEController.text).then((result) =>{
                                    if(result == true){
                                      Get.offAll(() => const BottomNavBaseScreen()),
                                    }else{
                                      Get.snackbar('failed', 'Login Failed! Try again')
                                    }
                              });
                            },
                            child: const Icon(Icons.arrow_forward_ios)),
                      ));
                }),
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
