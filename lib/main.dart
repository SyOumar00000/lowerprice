//import 'package:bleble/services/location-service.dart';
import 'package:bleble/screen/recupererJson.dart';
import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'package:focused_menu/modals.dart';
  import 'screen/pharmacie-screen.dart';
  import 'screen/hopital-screen.dart';
  import 'screen/hotel-screen.dart';
  import 'screen/restaurant-screen.dart';
  import 'screen/supermarche-screen.dart';
  import 'screen/transport-screen.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:focused_menu/focused_menu.dart';

  void main() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    runApp(MyApp());
  }

  class MyApp extends StatelessWidget {
    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Lower Price'),
      );
    }
  }

  class MyHomePage extends StatefulWidget {
    MyHomePage({Key key, this.title, color:Colors.red}) : super(key: key);
    final String title;

    @override
    _MyHomePageState createState() => _MyHomePageState();
  }

  class _MyHomePageState extends State<MyHomePage> {


    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      getFirstLocation();
      DetailPharmacie();
      DetailSupermarche();
      DetailRestaurant();
      DetailHotel();
      DetailTransport();
      DetailHopital();
     // listenToStream();
    }

    @override
    Widget build(BuildContext context) {

      return Scaffold(
        appBar: AppBar(
          title: Center(child: Text(widget.title)),
          actions: <Widget>[
            FocusedMenuHolder(
              child: new IconButton(
                  icon: new Icon(Icons.share, color: Colors.white,),
                  onPressed: null
              ),
              menuItems: <FocusedMenuItem>[
                FocusedMenuItem(title: Text("FaceBook"), onPressed: (){}, trailingIcon: Icon(Icons.zoom_in_sharp)),
                FocusedMenuItem(title: Text("WhatsApp"), onPressed: (){}, trailingIcon: Icon(Icons.zoom_in_sharp)),
                FocusedMenuItem(title: Text("LinkedIn"), onPressed: (){}, trailingIcon: Icon(Icons.zoom_in_sharp)),
                FocusedMenuItem(title: Text("Messenger"), onPressed: (){}, trailingIcon: Icon(Icons.zoom_in_sharp))
              ],
              blurSize: 4,//opacité de l'arriere plan
              blurBackgroundColor: Colors.teal,//couleur d'arriere plan
              menuWidth: MediaQuery.of(context).size.width*0.7,//largeur de l'affichage
              menuItemExtent: 60,// etendu de l'affichage
              animateMenuItems: false,
              duration: Duration(milliseconds: 100),//duree de l'animation
            ),
          ],
        ),
        body: new Container(
          padding: new EdgeInsets.only(top:10.0, left: 15.0, right: 15.0,bottom: 15.0),
          child: SingleChildScrollView(
            child: new Row(
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                     new InkWell(
                        child: new Card(
                          child: new Container(
                            padding: new EdgeInsets.only(top: 35.0,left: 30.0,right: 45.0,bottom: 35.0),
                            child: Center(
                              child: new Column(
                                children: <Widget>[
                                  new Icon(Icons.local_hospital_outlined, color: Colors.teal,size: 80),
                                  new Text("Pharmacie", style: new TextStyle(color: Colors.teal, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400),)
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: (){
                          Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                            return new DetailPharmacie();
                          }));
                        },
                       onLongPress: (){
                          return showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context){
                              return new AlertDialog(
                                title: Center(child: new Text("information!!!", textScaleFactor: 1.5, style: new TextStyle(color: Colors.teal),)),
                                content: new Text("cliquez une seule fois sur le bloc de pharmacie"
                                    " afin de faire votre recherche sur tout ce qui concerne les pharmacies!, merci",
                                  style: new TextStyle(color: Colors.orange, fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),),
                                contentPadding: EdgeInsets.all(5.0),
                                actions: <Widget>[
                                   new FlatButton(
                                       onPressed: (){Navigator.pop(context);},
                                       child: Center(child: new Text("valider", style: new TextStyle(color: Colors.blue),)))
                                ],
                              );
                            }
                          );
                       },
                      ),
                      new InkWell(
                        child: new Card(
                          child: new Container(
                            padding: new EdgeInsets.only(top: 35.0,left: 30.0,right: 45.0,bottom: 35.0),
                            child: Center(
                              child: new Column(
                                children: <Widget>[
                                  new Icon(Icons.local_hospital, color: Colors.teal,size: 80),
                                  new Text('Hopital', style: new TextStyle(color: Colors.teal, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400),)
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: (){
                            Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                              return new DetailHopital();
                            }));
                        },
                        onDoubleTap: (){
                          return showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context){
                                return new AlertDialog(
                                  title: Center(child: new Text("youpi!!!", textScaleFactor: 1.5, style: new TextStyle(color: Colors.teal),)),
                                  content: new Text("cliquez une seule fois sur le bloc de Hopital"
                                      " afin de faire votre recherche sur tout ce qui concerne les Hopitaux!, merci",
                                    style: new TextStyle(color: Colors.lightBlueAccent, fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),),
                                  contentPadding: EdgeInsets.all(5.0),
                                  actions: <Widget>[
                                    new FlatButton(
                                        onPressed: (){Navigator.pop(context);},
                                        child: Center(child: new Text("valider", style: new TextStyle(color: Colors.blue),)))
                                  ],
                                );
                              }
                          );
                        },
                      ),
                      new InkWell(
                        child: new Card(
                          child: new Container(
                            padding: new EdgeInsets.only(top: 35.0,left: 30.0,right: 45.0,bottom: 35.0),
                            child: Center(
                              child: new Column(
                                children: <Widget>[
                                  new Icon(Icons.apartment, color: Colors.teal,size: 80),
                                  new Text('Restaurant', style: new TextStyle(color: Colors.teal, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400),)
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: (){
                          Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                            return new DetailRestaurant();
                          }));
                        },
                        onDoubleTap: (){
                          return showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context){
                                return new AlertDialog(
                                  title: Center(child: new Text("youpi!!!", textScaleFactor: 1.5, style: new TextStyle(color: Colors.teal),)),
                                  content: new Text("cliquez une seule fois sur le bloc de Restaurant"
                                      " afin de faire votre recherche sur tout ce qui concerne les Restaurants!, merci",
                                    style: new TextStyle(color: Colors.lightBlueAccent, fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),),
                                  contentPadding: EdgeInsets.all(5.0),
                                  actions: <Widget>[
                                    new FlatButton(
                                        onPressed: (){Navigator.pop(context);},
                                        child: Center(child: new Text("valider", style: new TextStyle(color: Colors.blue),)))
                                  ],
                                );
                              }
                          );
                        },
                      ),
                    ],
                  ),
                  new Column(
                    children: <Widget>[
                      new InkWell(
                        child: new Card(
                          child: new Container(
                            padding: new EdgeInsets.only(top: 35.0,left: 30.0,right: 45.0,bottom: 35.0),
                            child: Center(
                              child: new Column(
                                children: <Widget>[
                                  new Icon(Icons.home, color: Colors.teal,size: 80),
                                  new Text("Supermarché", style: new TextStyle(color: Colors.teal, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400),)
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: (){
                          Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                            return new DetailSupermarche();
                          }));
                        },
                        onDoubleTap: (){
                          return showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context){
                                return new AlertDialog(
                                  title: Center(child: new Text("youpi!!!", textScaleFactor: 1.5, style: new TextStyle(color: Colors.teal),)),
                                  content: new Text("cliquez une seule fois sur le bloc de Supermarché"
                                      " afin de faire votre recherche sur tout ce qui concerne les Supermarchés!, merci",
                                    style: new TextStyle(color: Colors.lightBlueAccent, fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),),
                                  contentPadding: EdgeInsets.all(5.0),
                                  actions: <Widget>[
                                    new FlatButton(
                                        onPressed: (){Navigator.pop(context);},
                                        child: Center(child: new Text("valider", style: new TextStyle(color: Colors.blue),)))
                                  ],
                                );
                              }
                          );
                        },

                      ),
                      new InkWell(
                        child: new Card(
                          child: new Container(
                            padding: new EdgeInsets.only(top: 35.0,left: 30.0,right: 45.0,bottom: 35.0),
                            child: Center(
                              child: new Column(
                                children: <Widget>[
                                  new Icon(Icons.directions_car, color: Colors.teal,size: 80),
                                  new Text('Transport', style: new TextStyle(color: Colors.teal,fontStyle: FontStyle.italic, fontWeight: FontWeight.w400),)
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: (){
                          Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                            return new DetailTransport();
                          }));
                        },
                        onDoubleTap: (){
                          return showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context){
                                return new AlertDialog(
                                  title: Center(child: new Text("Halte!!!", textScaleFactor: 1.5, style: new TextStyle(color: Colors.teal),)),
                                  content: new Text("cliquez une seule fois sur le bloc de Transport"
                                      " afin de faire votre recherche sur tout ce qui concerne les Transports!, merci",
                                    style: new TextStyle(color: Colors.lightBlueAccent, fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),),
                                  contentPadding: EdgeInsets.all(5.0),
                                  actions: <Widget>[
                                    new FlatButton(
                                        onPressed: (){Navigator.pop(context);},
                                        child: Center(child: new Text("valider", style: new TextStyle(color: Colors.blue),)))
                                  ],
                                );
                              }
                          );
                        },
                      ),
                      new InkWell(
                        child: new Card(
                          child: new Container(
                            padding: new EdgeInsets.only(top: 35.0,left: 30.0,right: 45.0,bottom: 35.0),
                            child: Center(
                              child: new Column(
                                children: <Widget>[
                                  new Icon(Icons.home_work, color: Colors.teal,size: 80),
                                  new Text('Hotel', style: new TextStyle(color: Colors.teal, fontStyle: FontStyle.italic, fontWeight: FontWeight.w400),)
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: (){
                          Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                            return new DetailHotel();
                          }));
                        },
                        onDoubleTap: (){
                          return showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context){
                                return new AlertDialog(
                                  title: Center(child: new Text("youpi!!!", textScaleFactor: 1.5, style: new TextStyle(color: Colors.teal),)),
                                  content: new Text("cliquez une seule fois sur le bloc de Hotel"
                                      " afin de faire votre recherche sur tout ce qui concerne les Hotels!, merci",
                                    style: new TextStyle(color: Colors.lightBlueAccent, fontStyle: FontStyle.italic, fontWeight: FontWeight.w300),),
                                  contentPadding: EdgeInsets.all(5.0),
                                  actions: <Widget>[
                                    new FlatButton(
                                        onPressed: (){Navigator.pop(context);},
                                        child: Center(child: new Text("valider", style: new TextStyle(color: Colors.blue),)))
                                  ],
                                );
                              }
                          );
                        },
                      ),
                    ],
                  ),
                ],
            ),
          ),
        ),
        bottomNavigationBar: new BottomNavigationBar(
          elevation: 5,
          backgroundColor: Colors.teal,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(
                icon: new Icon(Icons.copyright,color: Colors.white),
                label: '@LowerPrice',
            ),
            BottomNavigationBarItem(
                icon: new Icon(Icons.mail,color: Colors.white),
                label: 'oumarsy.dev@gmail.com',
            ),
          ],
        ),
      );
    }
  }




