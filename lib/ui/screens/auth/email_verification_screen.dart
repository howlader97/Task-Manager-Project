import 'package:flutter/material.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/ui/screens/auth/login_screen.dart';
import 'package:task_manager/ui/screens/auth/otp_verification_screen.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../../../data/utils/urls.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _emailVerificationInProgress = false;

  Future<void> otpSentToEmail() async {
    _emailVerificationInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response = await NetworkCaller()
        .getRequest(Urls.sentOtp(_emailController.text.trim()));
    _emailVerificationInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      if (mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OtpVerificationScreen(
                      email: _emailController.text.trim(),
                    )));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email verification failed')));
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 64,
                ),
                Text('Your Email Address',
                    style: Theme.of(context).textTheme.titleLarge),
                Text(
                    'A 6 digit verification pin will sent to your email address ',
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
                 TextField(
                     controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                    width: double.infinity,
                    child: Visibility(
                      visible: _emailVerificationInProgress==false,
                      replacement:const Center(child:  CircularProgressIndicator()),
                      child: ElevatedButton(
                        onPressed: () {
                          otpSentToEmail();
                        },
                        child: const Icon(
                          Icons.arrow_circle_right_rounded,
                          color: Colors.white,
                        ),
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
    ));
  }
}
