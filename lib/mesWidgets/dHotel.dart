import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'recupererJson.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

class DetailHotel extends StatefulWidget {
  @override
  _DetailHotelPageState createState() => _DetailHotelPageState();
}
class _DetailHotelPageState extends State<DetailHotel> {
  Location location;
  LocationData locationData;
  Stream<LocationData> stream;
  Hotels hotels;
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
          new Text('Mon Hotel'):
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
              future: fetchHotels(),
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
                        HotelList(
                          hotels: snapshot.data,
                        );
                    }
                }
              }),
        ));
  }
  //fonction de recherche
  maRecherche() async {
    // List<Restaurants> restaurants = [];
    getFirstLocation();
    var userLatitude = locationData.latitude;
    var userLongitude = locationData.longitude;
    List restaurantRepertorie  = new List<Restaurants>();
    List restaurantTrouve = new List<Restaurants>();
    print(restaurantRepertorie);

    //parcourir ma liste de pharmacie afin de trouver les pharmacies dans un rayon de 5km
    for(int i=0; i<=restaurantRepertorie.length; i++){
      print(" latitude ${restaurantRepertorie[i].latitude} ... longitude ${restaurantRepertorie[i].longitude}");
      double distancesInMeters = Geolocator.distanceBetween(userLatitude, userLongitude, restaurantRepertorie[i].latitude, restaurantRepertorie[i].longitude);

      if(distancesInMeters <= 5000){
        restaurantTrouve[i] = restaurantRepertorie[i];
        print("listes des pharmacie trouvées: ${restaurantTrouve}");
      }
    }
    if(restaurantTrouve.length == 0){
      // aucune pharmacie dans ce rayon
      print("Aucune pharmacie n'a été trouvée");
    } else {
      //un ou plusieurs pharmacies ont été trouvées
      print("listes des pharmacie trouvées: ${restaurantTrouve}");
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

class HotelList extends StatelessWidget{
  List<Hotels> hotels = [];
  HotelList({Key key, this.hotels}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: hotels.length,
        itemBuilder: (context, int index) {
          return Card(
            child: Text(hotels[index].nom_part.toString()),
          );
        });
  }
}




