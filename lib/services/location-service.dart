import 'package:location/location.dart';

getFirstLocation() async {
  Location location;
  LocationData locationData;
  try{
    locationData = await location.getLocation();
    var  maLatitude = locationData.latitude;
    var  maLongitude = locationData.longitude;
    var monRayon = 5000;
    //print("nouvelle position: ${maLatitude} / ${maLongitude}");
    //locationToString();
  } catch (e){
    print("nous avons une erreur: $e");
  }
}