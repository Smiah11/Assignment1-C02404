import 'package:flutter/material.dart';
import 'package:movieapi/Database/DatabaseHelper.dart';
import 'package:movieapi/Models/WatchlistModel.dart';
import 'package:movieapi/ui/movie.dart';

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

  void _getWatchlistItems() async {
    List<WatchlistModel> watchlistItems =
        await DatabaseHelper.instance.getWatchlist();
    setState(() {
      _watchlistItems = watchlistItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: ListView.builder(
        itemCount: _watchlistItems.length,
        itemBuilder: (BuildContext context, int index) {
          WatchlistModel item = _watchlistItems[index];
          return ListTile(
            leading: Image.network(
              item.posterurl,
              width: 100,
              fit: BoxFit.cover,
            ),
            title: Text(item.name),
            subtitle: Text(item.description),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await DatabaseHelper.instance.deleteWatchlist(item.id!);
                _getWatchlistItems();
              },
            ),
          );
        },
      ),
    );
  }
}