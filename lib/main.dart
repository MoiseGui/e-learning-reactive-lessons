import 'package:elearning/home_page.dart';
import 'package:flutter/material.dart';
import 'package:elearning/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-learning',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      theme: AppTheme.dark.copyWith(
        platform: Theme.of(context).platform,
      ),
      home: const HomePage(title: 'E-learning'),
    );
  }
}