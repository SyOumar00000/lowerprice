import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'recupererJson.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

class DetailRestaurant extends StatefulWidget {
  @override
  _DetailRestaurantPageState createState() => _DetailRestaurantPageState();
}
class _DetailRestaurantPageState extends State<DetailRestaurant> {
  Location location;
  LocationData locationData;
  Stream<LocationData> stream;
  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar:new AppBar(
          centerTitle: true,
          title: !isSearching?
          new Text('Mon Restaurant'):
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
              future: fetchRestaurants(),
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
                        RestaurantList(
                          restaurants: snapshot.data,
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
        //print("liste des restaurants trouvés: ${restaurantTrouve}");
      }
    }
    if(restaurantTrouve.length == 0){
      // aucun restaurant dans ce rayon
      print("Aucun restaurant n'a été trouvé");
    } else {
      //un ou plusieurs restaurants ont été trouvés
      print("liste des restaurants trouvés: ${restaurantTrouve}");
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

class RestaurantList extends StatelessWidget{
  List<Restaurants> restaurants = [];
  RestaurantList({Key key, this.restaurants}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, right: 10.0, left: 10.0,bottom: 20.0),
      child: ListView.builder(
          itemCount: restaurants.length,
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
                    children: <Widget>[
                       Text(restaurants[index].nom_part.toString(),
                            style: TextStyle(fontSize: 20.0),),
                      Text(restaurants[index].ville_part.toString(),
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
