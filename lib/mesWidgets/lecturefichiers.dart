import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class Pharmacies {
  final int id_part;
  final String nom_part;
  final String ville_part;
  final String longitude;
  final String latitude;
  final String heureO;
  final String heureF;
  final String telephone;

  Pharmacies({ this.id_part,this.nom_part, this.ville_part, this.longitude, this.latitude, this.heureO, this.heureF,  this.telephone});
  factory Pharmacies.fromJson(Map<String, dynamic> json) {
    return Pharmacies(
      id_part: json['id_part'] as int,
      nom_part: json['nom_part'] as String,
      ville_part: json['ville_part'] as String,
      longitude: json['longitude'] as String,
      latitude: json['latitude'] as String,
      heureO: json['heureO'] as String,
      heureF: json['heureF'] as String,
      telephone: json['telephone'] as String,
    );
  }
}
class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: FutureBuilder<List>(
              future: fetchPharmacies(),
              builder: (context, AsyncSnapshot<List> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return Text('Error');
                    } else {
                      return PharmaciesList(
                        pharmacies: snapshot.data,
                      );
                    }
                }
              }),
        ));
  }
}
class PharmaciesList extends StatelessWidget {
   List<Pharmacies> pharmacies = [];
  PharmaciesList({Key key, this.pharmacies}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: pharmacies.length,
        itemBuilder: (context, int index) {
          return Card(
            child: Text(pharmacies[index].nom_part),
          );
        });
  }
}
List<Pharmacies> analysePharmacies(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Pharmacies>((json) => Pharmacies.fromJson(json)).toList();
}
Future<List<Pharmacies>> fetchPharmacies() async {
  final response = await rootBundle.loadString('assets/pharmacies.json');
  return compute(analysePharmacies, response);
}