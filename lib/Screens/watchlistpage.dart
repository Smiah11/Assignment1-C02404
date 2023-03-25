import 'package:flutter/material.dart';
import 'package:movieapi/Database/DatabaseHelper.dart';
import 'package:movieapi/Models/WatchlistModel.dart';

/*
  This is the watchlist page.
  This page shows the list of movies/tvshows added to the watchlist.
  This page also has a button to remove the movie/tvshow from the watchlist.
*/

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({Key? key}) : super(key: key);

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  List<WatchlistModel> _watchlistItems = [];

  @override
  void initState() {
    super.initState();
    _getWatchlistItems();
  }

  void _getWatchlistItems() async {//get list of movies/tvshows from watchlist
    List<WatchlistModel> watchlistItems =
        await DatabaseHelper.instance.getWatchlist();//get data from database
    setState(() {
      _watchlistItems = watchlistItems;//set data to list
    });
  }

  @override
  Widget build(BuildContext context) {//build watchlist page
    return Scaffold(
        appBar: AppBar(
          title: Text('Watchlist'),
        ),
        body: ListView.builder(
          itemCount: _watchlistItems.length,
          itemBuilder: (BuildContext context, int index) {
            WatchlistModel item = _watchlistItems[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: Image.network(
                  item.posterurl,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                title: Text(item.name),

                //subtitle: Text(item.description),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await DatabaseHelper.instance.deleteWatchlist(item.id!);//delete data from database
                    _getWatchlistItems();
                  },
                ),
              ),
            );
          },
        ));
  }
}
