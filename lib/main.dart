import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movieapi/Database/DatabaseHelper.dart';
import 'package:movieapi/Models/WatchlistModel.dart';
import 'package:movieapi/ui/playingnow.dart';
import 'package:movieapi/ui/tvplayingnow.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:movieapi/ui/movie.dart';
import 'package:movieapi/watchlistpage.dart';

void main() => runApp(new MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home:HomeScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor:Colors.black,
      )
      );
  }
}



class HomeScreen extends StatefulWidget{
  @override
  _HomeScreenState createState() => _HomeScreenState();
   
}

class _HomeScreenState extends State<HomeScreen>{
/*lists for the movies and tv shows*/
List whatsonnow = [];
List WhatsOnTV = [];
/*defining the api key and read access token*/
final String apikey = '721a00709b006f3718730986b3842949';
final readaccesstoken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3MjFhMDA3MDliMDA2ZjM3MTg3MzA5ODZiMzg0Mjk0OSIsInN1YiI6IjY0MTMyMjJkZWRlMWIwMjhlODRlMGQzZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.rJEobjvyPkoDehBXyoTn5faI6c3TCbR2skraqdVaq-k';



  @override
  void initState() {
    super.initState();
    loadmovies();
  }

/*function to load the movies and tv shows*/
  void
loadmovies()async{
  TMDB tmdbwithcustomlogs = TMDB(ApiKeys(apikey, readaccesstoken),
  logConfig: ConfigLogger(
    showLogs: true,
    showErrorLogs: true,
  ));

  Map nowplayingresult = await tmdbwithcustomlogs.v3.movies.getNowPlaying();
  Map tvonairresult = await tmdbwithcustomlogs.v3.tv.getOnTheAir();
  
  setState(() {
    whatsonnow = nowplayingresult['results'];
    WhatsOnTV = tvonairresult['results'];
  });
  print(nowplayingresult);

}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("UCLAN Movie App", style: TextStyle(color: Colors.white),),
        
      ),
      
      body: ListView(
        children:[
        MoviesPlaying(playingnow:whatsonnow,),
        TvShowsPlaying(playingnowtv:WhatsOnTV),
         Row(
            children: [
              Expanded(child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
            
            
              child:ElevatedButton(
                  style: ElevatedButton.styleFrom(
                  primary:Colors.purple,),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WatchlistPage(),
                    ),
                  );
                  
                },
                child: Text("My Watchlist"),
              ),
              )
              )
         ,
          Spacer(),
          Expanded(
            child:Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child:ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                onPressed: () {
                  // This will exit the app
                  SystemNavigator.pop();
                },
                child: Text("Exit App"),
              ),
            ),

          ),
        ],
      )
        ]
        ),);
    
  }
}



