import 'package:flutter/material.dart';
import 'package:untitled/app.dart';
import 'package:untitled/main_app/repository/localDbrepo.dart';
import 'package:untitled/main_app/repository/locationRepo.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DBRepo.init();
  await LocationRepo.init();
  runApp(MyApp());
}