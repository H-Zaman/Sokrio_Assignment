import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/main_app/model/locationDataModel.dart';

class LocationTile extends StatelessWidget {
  final LocationDataModel data;
  const LocationTile({Key? key , required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      leading: CircleAvatar(child: Text(data.id.toString()),),
      title: Text(
          data.title
      ),
      subtitle: Text(
          DateFormat().add_yMMMMEEEEd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(data.createdAt))
      ),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'Latitude : ${data.location.latitude}'
        ),
        SizedBox(height: 8,width: double.infinity,),
        Text(
            'Latitude : ${data.location.longitude}'
        ),
        SizedBox(height: 8),

      ],
    );
  }
}