import 'package:bleble/services/supermarche-service.dart';

//je creer un modele qui va décrire la structure de mes données a recuperer dans mon fichier supermarche.json
class Supermarches {
  final int id_part;
  final String nom_part;final String ville_part;
  final String longitude;final String latitude;
  final String heureO;final String heureF;final String telephone; String infousersuper;
  List<ArticleSupermarche> article;

  Supermarches(
      {this.id_part,this.nom_part, this.ville_part,this.longitude, this.latitude, this.heureO,
        this.heureF, this.telephone, this.infousersuper,this.article});
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
        infousersuper: json['infousersuper'] as String,
        article: List<ArticleSupermarche>.from(json["article"]?.map((v)
        {
          return ArticleSupermarche.fromJson(v);
        })?? [])

    );
  }
}
class ArticleSupermarche {
  int idArticle;
  String nomArticle;
  String prixArticle;

  ArticleSupermarche({this.idArticle, this.nomArticle, this.prixArticle});

  ArticleSupermarche.fromJson(Map<String, dynamic> json) {
    idArticle = json['id_article'];
    nomArticle = json['nom_article'];
    prixArticle = json['prix_article'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_article'] = this.idArticle;
    data['nom_article'] = this.nomArticle;
    data['prix_article'] = this.prixArticle;
    return data;
  }

  @override
  String toString() {
    return 'ArticleSupermarche{idArticle: $idArticle, nomArticle: $nomArticle, prixArticle: $prixArticle}';
  }


}