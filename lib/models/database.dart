import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:bleble/main.dart';

class DatabaseApp {
  Database _database;
  //fonnction pour avoir acces a ma bd car la bd est en privée
  Future<Database> get database async {
    if(_database != null){
      return _database;
    } else{
      // je cree la db en question a travers ma fonction "creation"

    }
  }

  Future creation() async {
    //je recupere le chemin menant au dossier du document et je le converti en string
    Directory directory = await getApplicationDocumentsDirectory();
    String database_directory = join(directory.path, 'database.db');
    // je cree une variable bdd qui ouvre ma bd avec le chemin , la version et la fonction oncreate
    var bdd = await openDatabase(database_directory, version: 1, onCreate: _onCreate );
    return bdd;
  }

  //creation de ladite fonction onCreate de la var bdd qui fait la requete de creation de table dans ma bd
  Future _onCreate(Database db, int version) async {
    //table categorie
    await db.execute('''
    CREATE TABLE categorie(id_cat INTEGER PRIMARY KEY, nom_cat TEXT NOT NULL, image_cat TEXT NOT NULL) 
    ''');
    //table partenaire
    await db.execute('''
    CREATE TABLE partenaire(id_part INTEGER PRIMARY KEY, nom_part TEXT NOT NULL, ville_part TEXT NOT NULL, #id_cat FOREIGN KEY, #id_art FOREIGN KEY) 
    ''');
    //table article
    await db.execute('''
    CREATE TABLE article(id_art INTEGER PRIMARY KEY, libelle_art TEXT NOT NULL, image_art TEXT NOT NULL, prix_art INTEGER NOT NULL) 
    ''');
  }

  //requete de jointure
  Future<List> selection() async {
    Database db = await _database;
    List<Map> names = await db.rawQuery(
        'SELECT * FROM partenaire INNER JOIN article on article.id_art = partenaire.id_art INNER JOIN categorie on categorie.id_cat = partenaire.id_cat WHERE ville_part= "locationToString()"');
    return names;
  }


}