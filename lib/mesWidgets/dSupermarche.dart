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
  List<Supermarches> supermarcheTrouve = new List<Supermarches>();
  TextEditingController articleController =   TextEditingController  ();
  Future<List<Supermarches>> futureSuperMarche;
bool exec = false;

  void getSupermarche()async{

  }

  @override
  void initState() {
     futureSuperMarche =  fetchSupermarches(supermarcheTrouve);
     supermarcheTrouve.sort((a, b) => a.article[0].prixArticle.compareTo(b.article[0].prixArticle));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title:
          //!isSearching?
              new Text('Mon Supermarche'),
                //:
         /* Container(
            child: TextFormField(
             controller: articleController,
              decoration: InputDecoration(
                hintText:"Que rechercher vous ?",
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
          ),*/
          /*actions: <Widget>[
            isSearching?
            Row(
              children: [
                new IconButton(
                    icon: new Icon(Icons.search, color: Colors.white,
                        size: 25.0),
                    onPressed: (){
                      setState(() {
                        print("clické");
                        searchArticle(supermarcheTrouve);
                        print("tailllle ${supermarcheTrouve.length}");
                      });
                    }),
                new IconButton(
                    icon: new Icon(Icons.cancel, color: Colors.white,
                        size: 25.0),
                    onPressed: (){
                      setState(() {
                        this.isSearching = false;
                      });
                    }),
              ],
            ):
            new IconButton(
                icon: new Icon(Icons.search, color: Colors.white,
                    size: 25.0),
                onPressed: (){
                  setState(() {
                    print("gsgsgsggsgsgsgsgsgsg");
                    this.isSearching = true;
                  });
                }),
          ],*/
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right:30.0, left:20.0),
              child: Container(
                child: TextFormField(
                  onTap: (){
                    searchArticle(supermarcheTrouve);
                  },
                  controller: articleController,
                  decoration: InputDecoration(
                    suffixIcon: (!exec) ? IconButton(
                      icon: InkWell(
                        onTap: (){
                          setState(() {
                            this.exec = !this.exec;
                           searchArticle(supermarcheTrouve);
                            supermarcheTrouve.sort((a, b) => a.article[0].prixArticle.compareTo(b.article[0].prixArticle));
                          });
                        },
                          child: Icon(Icons.search,color: Colors.black,)),
                    ):IconButton(
                      icon: InkWell(
                          onTap: (){
                            setState(() {
                              this.exec = !this.exec;
                              articleController.clear();
                              List<Supermarches> marche = supermarcheTrouve.where((element) => element.article[0].nomArticle== articleController.text).toList() ;

                              marche.sort((a, b) => a.article[0].prixArticle.compareTo(b.article[0].prixArticle));
                            });
                          },
                          child: Row(
                            children: [
                              Icon(Icons.cancel, color: Colors.black,),
                            ],
                          )),
                    ),
                    hintText:"Que rechercher vous ?",
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: (!exec)?FutureBuilder<List<Supermarches>>(
                    future:futureSuperMarche,
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
                    }):ListView.builder(
                  itemCount: supermarcheTrouve.length,
                    itemBuilder:(context, int index) {
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
                              Text(supermarcheTrouve[index].nom_part.toString(),
                                style: TextStyle(fontSize: 20.0),
                              ),
                              Text("Article : ${supermarcheTrouve[index].article[0].nomArticle.toString()} = ${supermarcheTrouve[index].article[0].prixArticle.toString()} Frcfa",
                                style: TextStyle(color: Colors.lightBlueAccent.shade400),),
                              Text(" vous etes a  : ${supermarcheTrouve[index].infousersuper.toString()} kilometres",
                                style: TextStyle(color: Colors.grey.shade600),)
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
        ));
  }
  //fonction de recherche
  maRecherche() async {
    getFirstLocation();
    var userLatitude = locationData.latitude;
    var userLongitude = locationData.longitude;
    List supermarcheRepertorie  = new List<Supermarches>();


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

  List<Supermarches> searchArticle(List<Supermarches> supermarcheTrouve) {
    List<Supermarches> marche = supermarcheTrouve.where((element) => element.article[0].nomArticle== articleController.text).toList() ;

    marche.sort((a, b) => a.article[0].prixArticle.compareTo(b.article[0].prixArticle));

    marche.forEach((element) {print("resultatttt ${element.nom_part}");});
    return marche ;
  }


}

class SupermarcheList extends StatelessWidget{


  TextEditingController articleController =   TextEditingController  ();
bool rechercher = false;
  get isSearching => rechercher;

  List<Supermarches> searchArticle(List<Supermarches> supermarcheTrouve) {
    List<Supermarches> marche = supermarcheTrouve.where((element) => element.article[0].nomArticle == articleController.text).toList() ;

    marche.sort((a, b) => a.article[0].prixArticle.compareTo(b.article[0].prixArticle));

    marche.forEach((element) {
    }
      );
    return marche ;
  }

 // bool isSearching = false;
  List<Supermarches> supermarches = [];
  SupermarcheList({Key key, this.supermarches}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 10.0, left: 10.0,bottom: 10.0),
            child: ListView.builder(
                itemCount: supermarches.length,
                itemBuilder: (context, int index) {
                  return  Container(
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
                            Text(" vous etes a  : ${supermarches[index].infousersuper.toString()} kilometres",
                              style: TextStyle(color: Colors.grey.shade600),)
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