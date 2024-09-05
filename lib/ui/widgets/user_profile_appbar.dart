import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/auth_utility.dart';
import 'package:task_manager/ui/screens/auth/login_screen.dart';
import 'package:task_manager/ui/screens/update_profile_screen.dart';

class UserProfileAppbar extends StatefulWidget {
  final bool? isUpdateScreen;

  const UserProfileAppbar({
    super.key,
    this.isUpdateScreen,
  });

  @override
  State<UserProfileAppbar> createState() => _UserProfileAppbarState();
}

class _UserProfileAppbarState extends State<UserProfileAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.green,
        title: InkWell(
          onTap: () {
            if ((widget.isUpdateScreen ?? false) == false) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UpdateProfileScreen()));
            }
          },
          child: Row(
            children: [
              Visibility(
                visible: (widget.isUpdateScreen ?? false) == false,
                child: Row(
                  children: [
                      CachedNetworkImage(
                        placeholder: (_,__) => const Icon(Icons.account_circle_outlined),
                        imageUrl:AuthUtility.userInfo.data?.photo ?? '' ,
                       errorWidget:(_,__,___)  => const Icon(Icons.account_circle_outlined),

                    ),
                    const SizedBox(
                      width: 16,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AuthUtility.userInfo.data?.firstName ?? ''}  ${AuthUtility.userInfo.data?.lastName ?? ''}',
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  Text(AuthUtility.userInfo.data?.email ?? 'Unknown',
                      style:
                          const TextStyle(fontSize: 12, color: Colors.white)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              AuthUtility.clearUserInfo();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false);
            },
            icon: const Icon(Icons.logout),
          )
        ]);
  }
}
