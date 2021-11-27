import 'package:flutter/material.dart';
import 'album.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bienvenu dans mon APP',
      theme: ThemeData(
        fontFamily: 'Raleway',
        primarySwatch: Colors.red,
      ),
      home:  Page1(),
    );
  }
}

class Page1 extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar( title: Text("Bienvenu dans mon APP")
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
          Container(
            height: 200,
            width: 200.0,

            decoration: BoxDecoration(

            ),
            child: new Image.network(
              'https://images.pexels.com/photos/1525043/pexels-photo-1525043.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940',

             ),
            alignment: Alignment.center,

          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: (
                Text(
                    " Bienvenu sur mon app qui affiche une citation en Latin depuis l'api : https://jsonplaceholder.typicode.com/albums/1",
                    style: TextStyle(fontFamily: 'Pacifico'),
                  )
               ),
           ),
            Container(
                child:
                RaisedButton(
                  onPressed: (){
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context)=> Page2()
                    )
                    );
                  },
                  child: Text("Entrer"),
                )
            ),
        ],
        ),
      ),
    );
  }
}



class Page2 extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar( title: Text("Voir la citation du jour")
      ),
      body: Center(child: RaisedButton(
        onPressed: (){
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context)=> HomePage()
          )
          );
        },
        child: Text("Voir la citation"),
      )),
    );
  }
}

class Page3 extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar( title: Text("Un citation")
      ),
      body: Center(child: RaisedButton(
        onPressed: (){
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context)=> Page1()
          )
          );
        },
        child: Text("Retour à l'accueil"),
      )),
    );
  }
}


//_________________________ Fetch data depuis API ------

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));


  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class _HomePageState extends State<HomePage> {
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(

              title: Text("Citation du jour"),
            ),
            body: Center(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  FutureBuilder<Album>(
                    future: futureAlbum,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return
                          Text('"'+snapshot.data!.title+'"');

                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      // By default, show a loading spinner.
                      return const CircularProgressIndicator();
                    },
                  ),
                  SizedBox(
                    height: 200.0,
                  ),
                  ElevatedButton(child: Text("Retour à l'accueil"), onPressed:(){
                    Navigator.of(context)
                        .push(
                        MaterialPageRoute(builder: (context)=> Page1())
                    );
                  }),
                ],
              ),
            )
        ));

  }
}