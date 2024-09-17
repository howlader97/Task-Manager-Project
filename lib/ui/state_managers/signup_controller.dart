import 'package:get/get.dart';

import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class SignUpController extends GetxController{
  bool _signUpInProgress=false;
  bool get signUpInProgress => _signUpInProgress;
  Future<bool> userSignUp(String email,String fastName,String lastName,String mobile,String password)async{
    _signUpInProgress=true;
    update();
    final response= await NetworkCaller().postRequest(Urls.registration, <String,dynamic>{
      "email":email,
      "firstName":fastName,
      "lastName":lastName,
      "mobile":mobile,
      "password":password,
      "photo":""
    });
    _signUpInProgress=false;
    update();
    if(response.isSuccess){
     return true;
    }else{
     return false;
    }
  }
}