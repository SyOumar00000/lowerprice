import 'dart:convert';
import 'package:bleble/models/supermarche-model.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

List<Supermarches> analyseSupermarches(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<Supermarches>((json) => Supermarches.fromJson(json))
      .toList();
}

//recuperation du fichier et affichage de Restaurants
Future<List<Supermarches>> fetchSupermarches(
    List<Supermarches> supermarcheTrouve) async {
  final response = await rootBundle.loadString('assets/supermarche.json');
  return supermarchecopy(analyseSupermarches(response), supermarcheTrouve);
}

Future<List<Supermarches>> supermarchecopy(
    List<Supermarches> supermarcheRepertorie,
    List<Supermarches> supermarcheTrouve) async {
  Location location;
  LocationData locationData;
  location = new Location();
  locationData = await location.getLocation();
  //je recupère mes coordonnées
  var maLatitude = locationData.latitude;
  var maLongitude = locationData.longitude;
  var infousersuper;
  //var madistance;
  try {
    // List<Supermarches> supermarcheTrouve = [];
    //parcourir ma liste de pharmacie afin de trouver les pharmacies dans un rayon de 5km
    for (int i = 0; i <= supermarcheRepertorie.length; i++) {
      double distancesInMeters = Geolocator.distanceBetween(
          maLatitude,
          maLongitude,
          double.parse(supermarcheRepertorie[i].latitude),
          double.parse(supermarcheRepertorie[i].longitude));
      var distanceSupermarche = distancesInMeters / 5000;
      if (distancesInMeters <= 5000) {
        infousersuper = distancesInMeters / 1000;
        // supermarcheTrouve.add(supermarcheTrouve[i].infousersuper);
        // supermarcheRepertorie.add(supermarcheRepertorie[i].infousersuper);
        //log('veritable distance: ${infousersuper} km');
        supermarcheRepertorie[i].infousersuper = infousersuper.toString();
        print("infouser: ${supermarcheRepertorie[i].infousersuper}");
        supermarcheRepertorie[i].article.forEach((article) {
          print("les articles: ${article.toString()}");
          // print("tout: ${supermarcheRepertorie}");
        });
        // print("infouser: ${supermarcheTrouve[i].infousersuper}");
        supermarcheTrouve.add(supermarcheRepertorie[i]);
      }
    }
    if (supermarcheTrouve.length == 0) {
      // aucune pharmacie dans ce rayon
      print("Aucun supermarche n'a été trouvé");
    } else {
      //un ou plusieurs supermarches ont été trouvés
      // var maVariable = supermarcheTrouve[i];
      var size = supermarcheTrouve.length;
      // log('liste des supermarches trouvés: $size');
      //log('distance dans tableau: ${infousersuper}');
    }
    supermarcheTrouve.forEach((element) {
      print("element ${element.nom_part} ");
      // print("element ${element.infousersuper}");
    });
    return supermarcheTrouve;
  } catch (e) {
    print("nous avons une erreur: $e");
  }
}
