

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


class ArticleHotel {
  int idArticle;
  String nomArticle;
  String prixArticle;

  ArticleHotel({this.idArticle, this.nomArticle, this.prixArticle});

  ArticleHotel.fromJson(Map<String, dynamic> json) {
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
    return 'ArticleHotel {idArticle: $idArticle, nomArticle: $nomArticle, prixArticle: $prixArticle}';
  }
}