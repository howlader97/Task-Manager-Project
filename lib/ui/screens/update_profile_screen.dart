import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/models/auth_utility.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/user_profile_appbar.dart';
import '../../data/models/login_model.dart';
import '../../data/models/network_response.dart';
import '../../data/utils/urls.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  UserData userData = AuthUtility.userInfo.data!;
  bool _updateProfileInProgress = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  ImagePicker picker = ImagePicker();
  XFile? imageFile;

  @override
  void initState() {
    super.initState();
    _emailTEController.text = userData.email ?? '';
    _firstNameTEController.text = userData.firstName ?? '';
    _lastNameTEController.text = userData.lastName ?? '';
    _mobileTEController.text = userData.mobile ?? '';
  }

  Future<void> updateProfile() async {
    _updateProfileInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final Map<String, dynamic> requestBody = {
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
      "photo": ""
    };
    if (_passwordTEController.text.isEmpty) {
      requestBody['password'] = _passwordTEController.text;
    }
    final NetworkResponse response =
    await NetworkCaller().postRequest(Urls.profileUpdate, requestBody);
    _updateProfileInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      userData.firstName=_firstNameTEController.text.trim();
      userData.lastName=_lastNameTEController.text.trim();
      userData.mobile=_mobileTEController.text.trim();
      AuthUtility.updateUserInfo(userData);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Update successful')));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
            const SnackBar(content: Text('Update failed!.try again')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                const UserProfileAppbar(
                isUpdateScreen: true,
              ),
              const SizedBox(
                height: 32,
              ),
              Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text('Update Profile',
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge),
                  const SizedBox(
                    height: 12,
                  ),
                  InkWell(
                    onTap: () {
                      selectImage();
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            color: Colors.grey,
                            child: const Text(
                              'photos',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Visibility(
                              visible: imageFile != null,
                              child: Text(imageFile?.name ?? ' ')),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: _emailTEController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      hintText: 'email',
                    ),
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return 'Enter valid Email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: _firstNameTEController,
                    decoration: const InputDecoration(
                      hintText: 'First Name',
                    ),
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
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
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
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
                    validator: (String? value) {
                      if ((value?.isEmpty ?? true) || value!.length < 11) {
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
                    validator: (String? value) {
                      if ((value?.isEmpty ?? true) || value!.length <= 5) {
                        return 'Enter more than 6 digit password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: _updateProfileInProgress ? const Center(
                          child: CircularProgressIndicator(),) : ElevatedButton(
                          onPressed: (){
                            updateProfile();
                          }, child: const Text('update'))
          )

          ],
        ),
      ),
      ],
    ),)
    ,
    )
    ,
    )
    ,
    );
  }

  void selectImage() {
    picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = xFile;
        if (mounted) {
          setState(() {});
        }
      }
    });
  }
}
