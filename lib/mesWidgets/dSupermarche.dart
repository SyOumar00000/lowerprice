import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'recupererJson.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

class DetailSupermarche extends StatefulWidget {
  @override
  _DetailSupermarchePageState createState() => _DetailSupermarchePageState();
}
class _DetailSupermarchePageState extends State<DetailSupermarche> {
  Location location;
  LocationData locationData;
  Stream<LocationData> stream;
  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: !isSearching?
          new Text('Mon Supermarche'):
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
        body: Center(
          child: FutureBuilder<List>(
              future: fetchSupermarches(),
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
                        SupermarcheList(
                          supermarches: snapshot.data,
                        );
                    }
                }
              }),
        ));
  }
  //fonction de recherche
  maRecherche() async {
    // List<Supermarches> supermarches = [];
    getFirstLocation();
    var userLatitude = locationData.latitude;
    var userLongitude = locationData.longitude;
    List supermarcheRepertorie  = new List<Supermarches>();
    List supermarcheTrouve = new List<Supermarches>();
    print(supermarcheRepertorie);

    //parcourir ma liste de pharmacie afin de trouver les pharmacies dans un rayon de 5km
    for(int i=0; i<=supermarcheRepertorie.length; i++){
      print(" latitude ${supermarcheRepertorie[i].latitude} ... longitude ${supermarcheRepertorie[i].longitude}");
      double distancesInMeters = Geolocator.distanceBetween(userLatitude, userLongitude, supermarcheRepertorie[i].latitude, supermarcheRepertorie[i].longitude);

      if(distancesInMeters <= 5000){
        supermarcheTrouve[i] = supermarcheRepertorie[i];
        print("listes des pharmacie trouvées: ${supermarcheTrouve}");
      }
    }
    if(supermarcheTrouve.length == 0){
      // aucune pharmacie dans ce rayon
      print("Aucune pharmacie n'a été trouvée");
    } else {
      //un ou plusieurs pharmacies ont été trouvées
      print("listes des pharmacie trouvées: ${supermarcheTrouve}");
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

class SupermarcheList extends StatelessWidget{
  List<Supermarches> supermarches = [];
  SupermarcheList({Key key, this.supermarches}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, right: 10.0, left: 10.0,bottom: 10.0),
      child: ListView.builder(
          itemCount: supermarches.length,
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
                          Text(supermarches[index].nom_part.toString(),
                          style: TextStyle(fontSize: 20.0),
                        ),
                      Text(supermarches[index].ville_part.toString(),
                        style: TextStyle(color: Colors.lightBlueAccent.shade400),),
                      Text(supermarches[index].infouserpharma,
                        style: TextStyle(color: Colors.grey.shade600),)
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}