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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    location = new Location();
    getFirstLocation();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: !isSearching?
          new Text('Ma Pharmacie'):
          TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              icon: Icon(Icons.search,color: Colors.white,),
                hintText:"Que rechercher vous ?",
               hintStyle: TextStyle(color: Colors.white),
            ),

          ),
          actions: <Widget>[
            isSearching?
            new IconButton(
                icon: new Icon(Icons.cancel, color: Colors.white,
                    size: 25.0),
                onPressed: (){
                  setState(() {
                    this.isSearching = false;
                  });
                }):
            new IconButton(
                icon: new Icon(Icons.search, color: Colors.white,
                    size: 25.0),
                onPressed: (){
                   setState(() {
                     this.isSearching = true;
                   });
                }),
          ],
        ),
        body: _lPharma(),
    );
  }
  _lPharma(){
    return Center(
      child: FutureBuilder<List>(
          future: fetchPharmacies(),
          builder: (context, AsyncSnapshot<List> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text('Error');
                } else {
                  return
                    PharmaciesList(
                      pharmacies: snapshot.data,
                    );
                }
            }
          }),
    );

  }
  //fonction de recherche
  maRecherche() async {
    // List<Pharmacies> pharmacies = [];
    getFirstLocation();
    var userLatitude = locationData.latitude;
    var userLongitude = locationData.longitude;
    List pharmacieRepertorie  = new List<Pharmacies>();
    List pharmacieTrouve = new List<Pharmacies>();
    print(pharmacieRepertorie);

    //parcourir ma liste de pharmacie afin de trouver les pharmacies dans un rayon de 5km
    for(int i=0; i<=pharmacieRepertorie.length; i++){
      print(" latitude ${pharmacieRepertorie[i].latitude} ... longitude ${pharmacieRepertorie[i].longitude}");
      double distancesInMeters = Geolocator.distanceBetween(userLatitude, userLongitude, pharmacieRepertorie[i].latitude, pharmacieRepertorie[i].longitude);

      if(distancesInMeters <= 5000){
        pharmacieTrouve[i] = pharmacieRepertorie[i];
        print("listes des pharmacie trouvées: ${pharmacieTrouve}");
      }
    }
    if(pharmacieTrouve.length == 0){
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
    try{
      locationData = await location.getLocation();
     var  maLatitude = locationData.longitude;
     var  maLongitude = locationData.latitude;
      var monRayon = 5000;
      print("nouvelle position: ${maLatitude} / ${maLongitude}");
      locationToString();
    } catch (e){
      print("nous avons une erreur: $e");
    }
  }

  //obtenir ses positions quand il se deplace
  listenToStream() {
    stream = location.onLocationChanged;
    stream.listen((newPosition) {
      if((locationData != null) ||(newPosition.latitude != locationData.latitude) && (newPosition.longitude != locationData.longitude)){
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
    if(locationData != null){
      Coordinates coordinates = new Coordinates(locationData.latitude, locationData.longitude);
      final cityName = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      print(cityName.first.subLocality);
    }
  }

}
class PharmaciesList extends StatelessWidget{
  List<Pharmacies> pharmacies = [];
  PharmaciesList({Key key, this.pharmacies}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, right: 10.0, left: 10.0,bottom: 20.0),
      child: ListView.builder(
          itemCount: pharmacies.length,
          itemBuilder: (context, int index) {
            return Container(
              width: 50.0,
              height: 60.0,
              child: Card(
                elevation: 2.5,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                           Text(pharmacies[index].nom_part.toString(),
                            style: TextStyle(fontSize: 20.0),),
                      Text(pharmacies[index].ville_part.toString(),
                        style: TextStyle(color: Colors.lightBlueAccent.shade400),)
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

