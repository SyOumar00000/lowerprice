
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

class ArticleRestaurant {
  int idArticle;
  String nomArticle;
  String prixArticle;

  ArticleRestaurant ({this.idArticle, this.nomArticle, this.prixArticle});

  ArticleRestaurant.fromJson(Map<String, dynamic> json) {
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
    return 'ArticleRestaurant {idArticle: $idArticle, nomArticle: $nomArticle, prixArticle: $prixArticle}';
  }


}