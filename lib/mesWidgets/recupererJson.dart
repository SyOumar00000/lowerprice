import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:developer';
import 'package:location/location.dart';

//je creer un modele qui va décrire la structure de mes données a recuperer dans mon json
class Pharmacies {
  final int id_part;
  final String nom_part;
  final String ville_part;
  final String longitude;
  final String latitude;
  final String heureO;
  final String heureF;
  final String telephone;
  final String paracetamol;
  final String efferalgan;



  Pharmacies(
      {this.id_part,this.nom_part, this.ville_part,this.longitude, this.latitude, this.heureO, this.heureF, this.telephone, this.paracetamol, this.efferalgan});
  factory Pharmacies.fromJson(Map<String, dynamic> json) {
    return Pharmacies(
      id_part: json['id_part'] as int,
      nom_part: json['nom_part'] as String,
      ville_part: json['ville_part'] as String,
      longitude: json['longitude'],
      latitude: json['latitude'],
      heureO: json['heureO'] as String,
      heureF: json['heureF'] as String,
      telephone: json['telephone'] as String,
      paracetamol: json['paracetamol'] as String,
      efferalgan: json['efferalgan'] as String,
    );
  }
}
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
      log('nombre de pharmacies trouvées: $size');
    }
    pharmacieTrouve.forEach((element) {
      print("element ${element.nom_part} ");
    });
    return pharmacieTrouve;
  } catch (e) {
    print("nous avons une erreur: $e");
  }
}
getFirstLocation() async {
  Location location;
  LocationData locationData;
  try{
    locationData = await location.getLocation();
    var  maLatitude = locationData.latitude;
    var  maLongitude = locationData.longitude;
    var monRayon = 5000;
    print("nouvelle position: ${maLatitude} / ${maLongitude}");
    //locationToString();
  } catch (e){
    print("nous avons une erreur: $e");
  }
}

// fin pharmacie et debut hotel
//je creer un modele qui va décrire la structure de mes données a recuperer dans mon fichier hotel.json
class Hotels {
  final int id_part;
  final String nom_part;
  final String ville_part;
  final String longitude;
  final String latitude;
  final String nbre_chambres;
  final String prix_chambres;
  final String telephone;

  Hotels(
      {this.id_part,this.nom_part, this.ville_part,this.longitude, this.latitude, this.nbre_chambres, this.prix_chambres, this.telephone});
  factory Hotels.fromJson(Map<String, dynamic> json) {
    return Hotels(
      id_part: json['id_part'] as int,
      nom_part: json['nom_part'] as String,
      ville_part: json['ville_part'] as String,
      longitude: json['longitude'],
      latitude: json['latitude'],
      nbre_chambres: json['nbre_chambres'] as String,
      prix_chambres: json['prix_chambres'] as String,
      telephone: json['telephone'] as String,
    );
  }
}
//analysons le fichier Hotels json
List<Hotels> analyseHotels(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Hotels>((json) => Hotels.fromJson(json)).toList();

}
//recuperation du fichier et affichage de Hotel
Future<List<Hotels>> fetchHotels() async {
  final response = await rootBundle.loadString('assets/hotel.json');
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
    for (int i = 0; i < hotelRepertorie.length; i++) {
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
      log('nombre de hotels trouvés: $size');
    }
    hotelTrouve.forEach((element) {
      print("element ${element.nom_part} ");
    });
    return hotelTrouve;
  } catch (e) {
    print("nous avons une erreur: $e");
  }
}

//fin hotel et debut restaurant
//je creer un modele qui va décrire la structure de mes données a recuperer dans mon fichier restaurant.json
class Restaurants {
  final int id_part;
  final String nom_part;
  final String ville_part;
  final String longitude;
  final String latitude;
  final String heureO;
  final String heureF;
  final String telephone;


  Restaurants(
      {this.id_part,this.nom_part, this.ville_part,this.longitude, this.latitude, this.heureO, this.heureF, this.telephone});
  factory Restaurants.fromJson(Map<String, dynamic> json) {
    return Restaurants(
      id_part: json['id_part'] as int,
      nom_part: json['nom_part'] as String,
      ville_part: json['ville_part'] as String,
      longitude: json['longitude'],
      latitude: json['latitude'],
      heureO: json['heureO'] as String,
      heureF: json['heureF'] as String,
      telephone: json['telephone'] as String,

    );
  }
}
//analysons le fichier Restaurants json
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
    List<Restaurants> restaurantTrouve = [];
    //parcourir ma liste de restaurant afin de trouver les restaurants dans un rayon de 5km
    for (int i = 0; i < restaurantRepertorie.length; i++) {
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
      log('listes des restaurants trouvées: $size');
    }
    restaurantTrouve.forEach((element) {
      print("element ${element.nom_part} ");
    });
    return restaurantTrouve;
  } catch (e) {
    print("nous avons une erreur: $e");
  }
}

//fin restaurants et debut de supermarche

//je creer un modele qui va décrire la structure de mes données a recuperer dans mon fichier supermarche.json
class Supermarches {
  final int id_part;
  final String nom_part;final String ville_part;
  final String longitude;final String latitude;
  final String heureO;final String heureF;final String telephone;final String infouserpharma;

  Supermarches(
      {this.id_part,this.nom_part, this.ville_part,this.longitude, this.latitude, this.heureO,
        this.heureF, this.telephone, this.infouserpharma});
  factory Supermarches.fromJson(Map<String, dynamic> json) {
    return Supermarches(
      id_part: json['id_part'] as int,
      nom_part: json['nom_part'] as String,
      ville_part: json['ville_part'] as String,
      longitude: json['longitude'],
      latitude: json['latitude'],
      heureO: json['heureO'] as String,
      heureF: json['heureF'] as String,
      telephone: json['telephone'] as String,
    );
  }
}
//analysons le fichier Restaurants json
List<Supermarches> analyseSupermarches(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Supermarches>((json) => Supermarches.fromJson(json)).toList();

}
//recuperation du fichier et affichage de Restaurants
Future<List<Supermarches>> fetchSupermarches() async {
  final response = await rootBundle.loadString('assets/supermarche.json');
  return supermarchecopy(analyseSupermarches(response));
}
Future<List<Supermarches>> supermarchecopy(List<Supermarches> supermarcheRepertorie) async {
  //var lisons = maListe.length;
  //print("${lisons}");
  // log('usecopieDebut: $usecopy');
  Location location;
  LocationData locationData;
  location = new Location();
  locationData = await location.getLocation();
  //je recupère mes coordonnées
  var maLatitude = locationData.latitude;
  var maLongitude = locationData.longitude;
  var infouserpharma;
  try {
    List<Supermarches> supermarcheTrouve = [];
    //parcourir ma liste de pharmacie afin de trouver les pharmacies dans un rayon de 5km
    for (int i = 0; i < supermarcheRepertorie.length; i++) {
      double distancesInMeters = Geolocator.distanceBetween(maLatitude, maLongitude, double.parse(supermarcheRepertorie[i].latitude), double.parse(supermarcheRepertorie[i].longitude));
      var distanceSupermarche = distancesInMeters / 5000;
      if (distancesInMeters <= 5000) {
        var madistance = (distancesInMeters / 1000);
       // log('veritable distance: ${madistance.toInt()}');
        supermarcheTrouve.add(supermarcheRepertorie[i]);
        infouserpharma.add(madistance.toInt());
      }
    }
    if (supermarcheTrouve.length == 0) {
      // aucune pharmacie dans ce rayon
      print("Aucune pharmacie n'a été trouvée");
    } else {
      //un ou plusieurs supermarches ont été trouvés
      // var maVariable = supermarcheTrouve[i];
      var size = supermarcheTrouve.length;
      log('liste des supermarches trouvés: $size');
      log('distance dans tableau: ${infouserpharma}');
    }
    supermarcheTrouve.forEach((element) {
      print("element ${element.nom_part} ");
    });
    return supermarcheTrouve;
  } catch (e) {
    print("nous avons une erreur: $e");
  }
}
