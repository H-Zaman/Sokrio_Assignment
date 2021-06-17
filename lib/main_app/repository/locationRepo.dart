import 'dart:async';
import 'package:background_fetch/background_fetch.dart';
import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:untitled/main_app/model/locationDataModel.dart';
import 'package:untitled/main_app/repository/localDbrepo.dart';



class LocationRepo{

  static Future<void> init() async{

    await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 5,
        stopOnTerminate: false,
        startOnBoot: true,
      ),
      (){}
    );

    await BackgroundFetch.registerHeadlessTask(LocationRepo.getUserCurrentLocation);
    await BackgroundFetch.start();
  }

  static Future<LocationDataModel?> getUserCurrentLocation() async{

    try{
      Map<Permission, PermissionStatus> status = await [
        Permission.location,
        Permission.locationWhenInUse,
        Permission.locationAlways,
      ].request();

      if(status[Permission.location] != PermissionStatus.granted){
        return Future.error('Location Permisson not given');
      }

      final data = await Geolocator.getCurrentPosition();

      final _latLng =  LatLng(latitude: data.latitude, longitude: data.longitude);

      final model = LocationDataModel(
          title: await _getAddressFromLatLng(_latLng),
          location: _latLng
      );

      print(DateTime.now().millisecondsSinceEpoch);

      await DBRepo().saveData(model);

      return model;
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  static Future<String> _getAddressFromLatLng (LatLng latlng) async{
    final _geoCode = GeoCode();
    final address = await _geoCode.reverseGeocoding(latitude: latlng.latitude, longitude: latlng.longitude);
    return address.streetAddress!;
  }


}