import 'package:elearning/pages/pages.dart';
import 'package:elearning/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:elearning/theme.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';

import 'controllers/controllers.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final _courseController = Get.put(CourseController());
  final _categoryController = Get.put(CategoryController());
  final _userController = Get.put(UserController());

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-learning',
      theme: AppTheme.dark.copyWith(
        platform: Theme.of(context).platform,
      ),
      initialRoute: RouteName.login,
      home: LoginPage(load: true),
      getPages: RoutePage.pages,
    );
  }
}