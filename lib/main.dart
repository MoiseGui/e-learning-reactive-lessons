import 'package:elearning/pages/pages.dart';
import 'package:elearning/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:elearning/theme.dart';
import 'package:get/route_manager.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-learning',
      theme: AppTheme.dark.copyWith(
        platform: Theme.of(context).platform,
      ),
      initialRoute: RouteName.home,
      home: const HomePage(title: 'E-learning'),
      getPages: RoutePage.pages,
    );
  }
}