import 'dart:convert';
import 'package:bleble/models/restaurant-model.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

List<Restaurants> analyseRestaurants(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Restaurants>((json) => Restaurants.fromJson(json)).toList();

}
//recuperation du fichier et affichage de Restaurants
Future<List<Restaurants>> fetchRestaurants() async {
  final response = await rootBundle.loadString('assets/restaurant.json');
  return restaurantcopy(analyseRestaurants(response));
}
Future<List<Restaurants>> restaurantcopy(List<Restaurants> restaurantRepertorie) async {
  Location location;
  LocationData locationData;
  location = new Location();
  locationData = await location.getLocation();
  //je recupére mes coordonnées
  var maLatitude = locationData.latitude;
  var maLongitude = locationData.longitude;
  try {
    List<Restaurants> restaurantTrouve = [];
    //parcourir ma liste de restaurant afin de trouver les restaurants dans un rayon de 5km
    for (int i = 0; i <= restaurantRepertorie.length; i++) {
      // print(" latitude ${restaurantRepertorie[i].latitude} ... longitude ${restaurantRepertorie[i].longitude}");
      double distancesInMeters = Geolocator.distanceBetween(maLatitude, maLongitude, double.parse(restaurantRepertorie[i].latitude), double.parse(restaurantRepertorie[i].longitude));
      var distanceRestaurant = distancesInMeters / 5000;
      //  log('pharmacie:  distanceRestaurant');
      if (distancesInMeters <= 5000) {
        restaurantTrouve.add(restaurantRepertorie[i]);
      }
    }
    if (restaurantTrouve.length == 0) {
      // aucun restaurant dans ce rayon
      print("Aucun restaurant n'a été trouvée");
    } else {
      //un ou plusieurs restaurants ont été trouvées
      // var maVariable = restaurantTrouve[i];
      var size = restaurantTrouve.length;
     // log('listes des restaurants trouvées: $size');
    }
    restaurantTrouve.forEach((element) {
      print("element ${element.nom_part} ");
    });
    return restaurantTrouve;
  } catch (e) {
    print("nous avons une erreur: $e");
  }
}