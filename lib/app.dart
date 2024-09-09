import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/screens/splash_screen.dart';
import 'package:task_manager/ui/state_managers/login_controller.dart';
class TaskManagerApp extends StatelessWidget {

  static GlobalKey<NavigatorState> globalKey=GlobalKey<NavigatorState>();
  const TaskManagerApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: TaskManagerApp.globalKey,
      title: 'Task ManagerApp',
      home: const SplashScreen(),
      themeMode: ThemeMode.light,
      theme: ThemeData(
          brightness: Brightness.light,
        primarySwatch: Colors.amber,
         inputDecorationTheme: const InputDecorationTheme(
           filled: true,
           fillColor: Colors.white,
           contentPadding: EdgeInsets.symmetric(vertical: 18,horizontal: 16),
           border: OutlineInputBorder(
             borderSide: BorderSide.none,
           ),
         ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          )
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 12,)
          )
        )
      ),
      initialBinding: ControllerBinding(),
    );
  }
}

class ControllerBinding extends Bindings{
  @override
  void dependencies() {
    Get.put<LoginController>(LoginController());
  }

}