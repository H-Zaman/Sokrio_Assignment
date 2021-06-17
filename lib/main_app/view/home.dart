import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/main_app/model/locationDataModel.dart';
import 'package:untitled/main_app/repository/locationRepo.dart';
import 'package:untitled/main_app/view/widget/locationTile.dart';

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
  }
  bool dataFetchActive = true;
  LocationDataModel? _locationDataModel;
  fetchData() async{

    _locationDataModel = await LocationRepo.getUserCurrentLocation();
    setState(() {
      dataFetchActive = false;
    });
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