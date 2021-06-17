import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/main_app/view/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Home(),
    );
  }
}
