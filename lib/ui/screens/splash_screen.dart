import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/auth_utility.dart';
import 'package:task_manager/ui/screens/auth/login_screen.dart';
import 'package:task_manager/ui/screens/bottom_nav_base_screen.dart';
import 'package:task_manager/ui/utils/asset_utils.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigatorToLogin();
  }

  Future<void> navigatorToLogin() async {
    Future.delayed(const Duration(seconds: 4)).then((_) async {
      final bool isLoggedIn=await AuthUtility.checkIfUserLoggedIn();
      if (mounted) {
        Get.offAll (() => isLoggedIn
            ? const BottomNavBaseScreen()
            : const LoginScreen());
      /*  Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => isLoggedIn
                    ? const BottomNavBaseScreen()
                    : const LoginScreen()),
            (route) => false);*/
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
          child: Center(
        child: SvgPicture.asset(
          AssetsUtils.logoSVG,
          fit: BoxFit.scaleDown,
          width: 80,
        ),
      )),
    );
  }
}
