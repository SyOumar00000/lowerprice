import 'package:flutter/material.dart';

class DetailTransport extends StatefulWidget {
  @override
  _DetailTransportPageState createState() => _DetailTransportPageState();
}
class _DetailTransportPageState extends State<DetailTransport> {
  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
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
      body: Padding(
        padding: const EdgeInsets.only(
            left: 30.0, top: 10.0, right: 30.0, bottom: 60.0
        ),
        child:  new Container(
          child: new Column(
            children: <Widget>[
              Center(
                heightFactor: 2.0,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 5.0, top: 0.0, right: 90.0, bottom: 00.0
                  ),
                  child: Text(
                    "Recherche",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20.0, color: Colors.teal, height: 1.0),
                  ),
                ),
              ),
              Card(
                elevation: 1.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: TextField(
                  // controller: searchController,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: (){},
                      child: Icon(Icons.search),
                    ),
                    contentPadding: EdgeInsets.all(5.0),
                    labelText: " Faites votre recherche ici !",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}