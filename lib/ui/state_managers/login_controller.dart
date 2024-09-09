import 'package:get/get.dart';

import '../../data/models/auth_utility.dart';
import '../../data/models/login_model.dart';
import '../../data/models/network_response.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class LoginController extends GetxController{
  bool _loginInProgress=false;
  bool get loginInProgress => _loginInProgress;

  Future<bool> userLogin(String email,String password) async {
    _loginInProgress=true;

    update();
    final NetworkResponse response =
    await NetworkCaller().postRequest(Urls.login, <String, dynamic>{
      "email": email,
      "password": password,
    },isLogin: true);
    _loginInProgress=false;
    update();
    if (response.isSuccess) {

      await AuthUtility.saveUserInfo(LoginModel.fromJson(response.body!));
     /* if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const BottomNavBaseScreen()),
                (route) => false);
      }*/
      return true;
    } else {
      return false;
     /* if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect email or password')));
      }*/
    }
  }
}