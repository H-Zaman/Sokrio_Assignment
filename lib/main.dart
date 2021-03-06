import 'package:flutter/material.dart';
import 'package:untitled/app.dart';
import 'package:untitled/main_app/repository/localDbrepo.dart';
import 'package:untitled/main_app/repository/locationRepo.dart';

import 'package:background_fetch/background_fetch.dart';

// [Android-only] This "Headless Task" is run when the Android app
// is terminated with enableHeadless: true
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  print('[BackgroundFetch] Headless event received.');
  // Do your work here...
  BackgroundFetch.finish(taskId);
}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DBRepo.init();
  await LocationRepo.init();
  runApp(MyApp());
}