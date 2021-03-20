import 'package:bleble/models/pharmacie-model.dart';
import 'package:bleble/services/pharmacie-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
//import 'recupererJson.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

class DetailPharmacie extends StatefulWidget {
  @override
  _DetailCategoriesPageState createState() => _DetailCategoriesPageState();
}

class _DetailCategoriesPageState extends State<DetailPharmacie> {
  Location location;
  LocationData locationData;
  Stream<LocationData> stream;
  Pharmacies pharmacies;
  bool isSearching = false;
  List<Pharmacies> pharmacieTrouve = [];
  TextEditingController articleController = TextEditingController();
  Future<List<Pharmacies>> futurePharmacie;
  bool exec = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    location = new Location();
    getFirstLocation();
    futurePharmacie = fetchPharmacies(pharmacieTrouve);
    // searchArticle(pharmacieTrouve);
    /* pharmacieTrouve.sort(
        (a, b) => a.article[0].prixArticle.compareTo(b.article[0].prixArticle)); */
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title:
            //!isSearching?
            new Text('Ma Pharmacie'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0, left: 20.0),
            child: Container(
              child: TextFormField(
                onTap: () {
                  // searchArticle(pharmacieTrouve);
                },
                controller: articleController,
                decoration: InputDecoration(
                  suffixIcon: (!exec)
                      ? IconButton(
                          icon: InkWell(
                              onTap: () {
                                setState(() {
                                  this.exec = !this.exec;
                                  // searchArticle(pharmacieTrouve);
                                  pharmacieTrouve.sort((a, b) => a
                                      .article[0].prixArticle
                                      .compareTo(b.article[0].prixArticle));
                                });
                              },
                              child: Icon(
                                Icons.search,
                                color: Colors.black,
                              )),
                        )
                      : IconButton(
                          icon: InkWell(
                              onTap: () {
                                setState(() {
                                  this.exec = !this.exec;
                                  articleController.clear();

                                  /*  List<Pharmacies> marche = pharmacieTrouve
                                      .where((element) => element
                                          .article[0].nomArticle
                                          .toLowerCase()
                                          .contains(articleController.text
                                              .toLowerCase()))
                                      .toList();

                                  marche.sort((a, b) => a.article[0].prixArticle
                                      .compareTo(b.article[0].prixArticle)); */
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.cancel,
                                    color: Colors.black,
                                  ),
                                ],
                              )),
                        ),
                  hintText: "Que rechercher vous ?",
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: (!exec)
                  ? FutureBuilder<List<Pharmacies>>(
                      future: futurePharmacie,
                      builder: (context, AsyncSnapshot<List> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          default:
                            if (snapshot.hasError) {
                              print(snapshot.error);
                              return Text('Error');
                            } else {
                              return PharmaciesList(
                                pharmacies: snapshot.data,
                              );
                            }
                        }
                      })
                  : ListView.builder(
                      itemCount: pharmacieTrouve.length,
                      itemBuilder: (context, int index) {
                        return Container(
                          width: 50.0,
                          height: 80.0,
                          child: Card(
                            elevation: 1.5,
                            child: Padding(
                              padding: const EdgeInsets.all(2.5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pharmacieTrouve[index].nom_part.toString(),
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                  Text(
                                    "Article : ${pharmacieTrouve[index].article[0].nomArticle.toString()} = ${pharmacieTrouve[index].article[0].prixArticle.toString()} Frcfa",
                                    style: TextStyle(
                                        color: Colors.lightBlueAccent.shade400),
                                  ),
                                  Text(
                                    " vous etes a  : ${pharmacieTrouve[index].infousersuper.toString()} kilometres",
                                    style:
                                        TextStyle(color: Colors.grey.shade600),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  //fonction de recherche
  maRecherche() async {
    getFirstLocation();
    var userLatitude = locationData.latitude;
    var userLongitude = locationData.longitude;
    List pharmacieRepertorie = new List<Pharmacies>();

    //parcourir ma liste de pharmacie afin de trouver les pharmacies dans un rayon de 5km
    for (int i = 0; i <= pharmacieRepertorie.length; i++) {
      print(
          " latitude ${pharmacieRepertorie[i].latitude} ... longitude ${pharmacieRepertorie[i].longitude}");
      double distancesInMeters = Geolocator.distanceBetween(
          userLatitude,
          userLongitude,
          pharmacieRepertorie[i].latitude,
          pharmacieRepertorie[i].longitude);

      if (distancesInMeters <= 5000) {
        pharmacieTrouve[i] = pharmacieRepertorie[i];
        print("listes des pharmacie trouvées: ${pharmacieTrouve}");
      }
    }
    if (pharmacieTrouve.length == 0) {
      // aucune pharmacie dans ce rayon
      print("Aucune pharmacie n'a été trouvée");
    } else {
      //un ou plusieurs pharmacies ont été trouvées
      print("listes des pharmacie trouvées: ${pharmacieTrouve}");
    }
  }

//location
  //obtenir sa premiere position
  getFirstLocation() async {
    try {
      locationData = await location.getLocation();
      var maLatitude = locationData.longitude;
      var maLongitude = locationData.latitude;
      var monRayon = 5000;
      print("nouvelle position: ${maLatitude} / ${maLongitude}");
      locationToString();
    } catch (e) {
      print("nous avons une erreur: $e");
    }
  }

  //obtenir ses positions quand il se deplace
  listenToStream() {
    stream = location.onLocationChanged;
    stream.listen((newPosition) {
      if ((locationData != null) ||
          (newPosition.latitude != locationData.latitude) &&
              (newPosition.longitude != locationData.longitude)) {
        setState(() {
          locationData = newPosition;
          locationToString();
        });
      }
    });
  }

  //geocoder
  //recuperer la longitude et la latitude de l'user afin de les convertir en la ville qui correspond
  locationToString() async {
    if (locationData != null) {
      Coordinates coordinates =
          new Coordinates(locationData.latitude, locationData.longitude);
      final cityName =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      print(cityName.first.subLocality);
    }
  }

  List<Pharmacies> searchArticle(List<Pharmacies> pharmacieTrouve) {
    List<Pharmacies> marche = pharmacieTrouve
        .where((element) => element.article[0].nomArticle
            .toLowerCase()
            .contains(articleController.text.toLowerCase()))
        .toList();
    for (int i = 0; i <= pharmacieTrouve.length; i++) {
      marche.sort((a, b) =>
          a.article[i].prixArticle.compareTo(b.article[i].prixArticle));
      for (int j = 0; j < marche.length; j++) {
        marche[j].article = marche[j]
            .article
            .where((element) => element.nomArticle
                .toLowerCase()
                .contains(articleController.text.toLowerCase()))
            .toList();
      }
      marche.forEach((element) {
        print("resultatttt: ${element.article.length}");
      });
      return marche;
    }
    return marche;
  }
}

class PharmaciesList extends StatelessWidget {
  TextEditingController articleController = TextEditingController();
  // bool rechercher = false;
  //get isSearching => rechercher;

  /* List<Pharmacies> searchArticle(List<Pharmacies> pharmacieTrouve) {
    List<Pharmacies> marche = pharmacieTrouve
        .where((element) =>
            element.article[0].nomArticle == articleController.text)
        .toList();

    marche.sort(
        (a, b) => a.article[0].prixArticle.compareTo(b.article[0].prixArticle));

    marche.forEach((element) {});
    return marche;
  } */

  // bool isSearching = false;
  List<Pharmacies> pharmacies = new List<Pharmacies>();
  PharmaciesList({Key key, this.pharmacies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 20.0, right: 10.0, left: 10.0, bottom: 10.0),
            child: ListView.builder(
                itemCount: pharmacies.length,
                itemBuilder: (context, int index) {
                  return Container(
                    width: 50.0,
                    height: 80.0,
                    child: Card(
                      elevation: 1.5,
                      child: Padding(
                        padding: const EdgeInsets.all(2.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pharmacies[index].nom_part.toString(),
                              style: TextStyle(fontSize: 20.0),
                            ),
                            Text(
                              pharmacies[index].ville_part.toString(),
                              style: TextStyle(
                                  color: Colors.lightBlueAccent.shade400),
                            ),
                            Text(
                              " vous etes a  : ${pharmacies[index].infousersuper.toString()} kilometres",
                              style: TextStyle(color: Colors.grey.shade600),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}
