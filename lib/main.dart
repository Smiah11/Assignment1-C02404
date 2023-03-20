import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movieapi/ui/playingnow.dart';
import 'package:movieapi/ui/tvplayingnow.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:movieapi/Screens/watchlistpage.dart';
import 'package:movieapi/Screens/searchscreen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
        ));
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
/*lists for the movies and tv shows*/
  List whatsonnow = [];
  List WhatsOnTV = [];

  String _sortBy = 'default';
/*defining the api key and read access token*/
  final String apikey = '721a00709b006f3718730986b3842949';
  final readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3MjFhMDA3MDliMDA2ZjM3MTg3MzA5ODZiMzg0Mjk0OSIsInN1YiI6IjY0MTMyMjJkZWRlMWIwMjhlODRlMGQzZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.rJEobjvyPkoDehBXyoTn5faI6c3TCbR2skraqdVaq-k';

  @override
  void initState() {
    super.initState();
    loadmovies();
  }

/*function to load the movies and tv shows*/
  void loadmovies() async {
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
  }

  List _getSortedList(List list) {
    if (_sortBy == 'name') {
      list.sort((a, b) => (a['title'] ?? '').compareTo(b['title'] ?? ''));
      list.sort(
          (a, b) => (a['original_name'] ?? '').compareTo(b['original_name'] ?? ''));
    } else if (_sortBy == 'name_desc') {
      list.sort((a, b) => (b['title'] ?? '').compareTo(a['title'] ?? ''));
      list.sort(
          (a, b) => (b['original_name'] ?? '').compareTo(a['original_name'] ?? ''));
    } else if (_sortBy == 'popularity_desc') {
      list.sort(
          (a, b) => (b['popularity'] ?? '').compareTo(a['popularity'] ?? ''));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "UCLAN Movie App",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
          DropdownButton<String>(
            value: _sortBy,
            items: [
              DropdownMenuItem(
                child: Text('Default'),
                value: 'default',
              ),
              DropdownMenuItem(
                child: Text('Name (A-Z)'),
                value: 'name',
              ),
              DropdownMenuItem(
                child: Text('Name (Z-A)'),
                value: 'name_desc',
              ),
              DropdownMenuItem(
                  child: Text('Most Popular'), value: 'popularity_desc'),
            ],
            onChanged: (value) {
              setState(() {
                _sortBy = value!;
              });
            },
          ),
        ],
      ),
      body: ListView(children: [
        MoviesPlaying(
          playingnow: _getSortedList(whatsonnow),
        ),
        TvShowsPlaying(playingnowtv: _getSortedList(WhatsOnTV)),
        Row(
          children: [
            Expanded(
                child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                ),
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
            )),
            Spacer(),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
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
      ]),
    );
  }
}
