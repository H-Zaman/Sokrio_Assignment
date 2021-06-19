import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/main_app/model/locationDataModel.dart';
import 'package:untitled/main_app/repository/locationRepo.dart';
import 'package:untitled/main_app/view/widget/locationTile.dart';

import 'package:background_fetch/background_fetch.dart';

class Home extends StatefulWidget {

  static RxList<LocationDataModel> data = <LocationDataModel>[].obs;
  static void setData (List<LocationDataModel> newData) => data.value = newData;

  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
    fetchData();
    initPlatformState();
  }
  bool dataFetchActive = true;
  LocationDataModel? _locationDataModel;
  fetchData() async{

    _locationDataModel = await LocationRepo.getUserCurrentLocation();
    setState(() {
      dataFetchActive = false;
    });
  }


  bool _enabled = true;
  int _status = 0;
  List<DateTime> _events = [];
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    int status = await BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.NONE
    ), (String taskId) async {  // <-- Event handler
      // This is the fetch-event callback.
      print("[BackgroundFetch] Event received $taskId");
      setState(() {
        _events.insert(0, new DateTime.now());
      });
      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {  // <-- Task timeout handler.
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });
    print('[BackgroundFetch] configure success: $status');
    setState(() {
      _status = status;
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _locationDataModel == null ? Text('Fetching Location...') : Row(
          children: [
            Icon(
              Icons.location_on_rounded
            ),
            SizedBox(width: 8),
            Text(
              _locationDataModel!.title
            )
          ]
        )
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location History:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: Obx(()=>Home.data.length > 0 ? ListView.builder(
                shrinkWrap: true,
                itemCount: Home.data.length,
                padding: EdgeInsets.zero,
                itemBuilder: (_, index) => LocationTile(data: Home.data[index]),
              ) : Center(child: CircularProgressIndicator()))
            )
          ],
        ),
      ),
    );
  }
}