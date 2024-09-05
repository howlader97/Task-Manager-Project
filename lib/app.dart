import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/splash_screen.dart';
class TaskManagerApp extends StatelessWidget {

  static GlobalKey<NavigatorState> globalKey=GlobalKey<NavigatorState>();
  const TaskManagerApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}