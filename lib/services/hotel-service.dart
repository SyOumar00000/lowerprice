import 'dart:convert';
import 'package:bleble/models/hotel-model.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

List<Hotels> analyseHotels(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Hotels>((json) => Hotels.fromJson(json)).toList();

}
//recuperation du fichier et affichage de Hotel
Future<List<Hotels>> fetchHotels() async {
  final response = await rootBundle.loadString('assets/hotel.json');
  //print(".......${response}......");
  return hotelcopy(analyseHotels(response));
}

Future<List<Hotels>> hotelcopy(List<Hotels> hotelRepertorie) async {
  //var lisons = maListe.length;
  //print("${lisons}");
  // log('usecopieDebut: hotelcopy');
  Location location;
  LocationData locationData;
  location = new Location();
  locationData = await location.getLocation();
  //je recupère mes coordonnées
  var maLatitude = locationData.latitude;
  var maLongitude = locationData.longitude;
  try {
    List<Hotels> hotelTrouve = [];
    //parcourir ma liste de hotel afin de trouver les hotels dans un rayon de 5km
    for (int i = 0; i <= hotelRepertorie.length; i++) {
      // print(" latitude ${hotelRepertorie[i].latitude} ... longitude ${hotelRepertorie[i].longitude}");
      double distancesInMeters = Geolocator.distanceBetween(maLatitude, maLongitude, double.parse(hotelRepertorie[i].latitude), double.parse(hotelRepertorie[i].longitude));
      var distanceHotel = distancesInMeters / 5000;
      //  log('hotel:  $distanceHotel');
      if (distancesInMeters <= 5000) {
        hotelTrouve.add(hotelRepertorie[i]);
      }
    }
    if (hotelTrouve.length == 0) {
      // aucun hotel dans ce rayon
      print("Aucun hotel n'a été trouvée");
    } else {
      //un ou plusieurs hotels ont été trouvés
      // var maVariable = hotelTrouve[i];
      var size = hotelTrouve.length;
      //log('nombre de hotels trouvés: $size');
    }
    hotelTrouve.forEach((element) {
      print("element ${element.nom_part} ");
    });
    return hotelTrouve;
  } catch (e) {
    print("nous avons une erreur: $e");
  }
}