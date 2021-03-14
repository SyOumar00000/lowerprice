import 'dart:convert';
import 'package:bleble/models/pharmacie-model.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
//import 'location-service.dart';

//analysons le fichier json
List<Pharmacies> analysePharmacies(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Pharmacies>((json) => Pharmacies.fromJson(json)).toList();
}

//recuperation du fichier et affichage
Future<List<Pharmacies>> fetchPharmacies() async {
  final response = await rootBundle.loadString('assets/pharmacie.json');
  return usecopy(analysePharmacies(response));
}

Future<List<Pharmacies>> usecopy(List<Pharmacies> pharmacieRepertorie) async {
//var lisons = maListe.length;
//print("${lisons}");
// log('usecopieDebut: $usecopy');
  Location location;
  LocationData locationData;
  location = new Location();
  locationData = await location.getLocation();
//je recupére mes coordonnées
  var maLatitude = locationData.latitude;
  var maLongitude = locationData.longitude;
  try {
    List<Pharmacies> pharmacieTrouve = [];
//parcourir ma liste de pharmacie afin de trouver les pharmacies dans un rayon de 5km
    for (int i = 0; i < pharmacieRepertorie.length; i++) {
// print(" latitude ${pharmacieRepertorie[i].latitude} ... longitude ${pharmacieRepertorie[i].longitude}");
      double distancesInMeters = Geolocator.distanceBetween(maLatitude, maLongitude, double.parse(pharmacieRepertorie[i].latitude), double.parse(pharmacieRepertorie[i].longitude));
      var distancePharmacie = distancesInMeters / 5000;
//  log('pharmacie:  $distancePharmacie');
      if (distancesInMeters <= 5000) {
        pharmacieTrouve.add(pharmacieRepertorie[i]);
      }
    }
    if (pharmacieTrouve.length == 0) {
// aucune pharmacie dans ce rayon
      print("Aucune pharmacie n'a été trouvée");
    } else {
//un ou plusieurs pharmacies ont été trouvées
// var maVariable = pharmacieTrouve[i];
      var size = pharmacieTrouve.length;
//log('nombre de pharmacies trouvées: $size');
    }
    pharmacieTrouve.forEach((element) {
      print("element ${element.nom_part} ");
    });
    return pharmacieTrouve;
  } catch (e) {
    print("nous avons une erreur: $e");
  }
}