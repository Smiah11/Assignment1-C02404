import 'package:flutter/material.dart';
import 'package:movieapi/Database/DatabaseHelper.dart';
import 'package:movieapi/Models/WatchlistModel.dart';


class Description extends StatefulWidget {
  final String name, description, bannerurl, posterurl;

  const Description(
      {Key? key,
      required this.name,
      required this.description,
      required this.bannerurl,
      required this.posterurl})
      : super(key: key);

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  bool isAddedToWatchlist = false;

  @override
  void initState() {
    super.initState();
    _checkIfAddedToWatchlist();
  }

 void _addToWatchlist() async {
  WatchlistModel watchlistModel = WatchlistModel(
    id: null,
    name: widget.name,
    description: widget.description,
    bannerurl: widget.bannerurl,
    posterurl: widget.posterurl,
  );
  int id = await DatabaseHelper.instance.insertWatchlist(watchlistModel);
  watchlistModel.id = id;
  setState(() {
    isAddedToWatchlist = true;
  });
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Added to Watchlist'),
      duration: Duration(seconds: 1),
    ),
  );
}

  void _removeFromWatchlist() async {
    await DatabaseHelper.instance.deleteWatchlistByName(widget.name);
    setState(() {
      isAddedToWatchlist = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed from Watchlist'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _checkIfAddedToWatchlist() async {
    bool isAdded =
        await DatabaseHelper.instance.isMovieInWatchlist(widget.name);
    setState(() {
      isAddedToWatchlist = isAdded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: ListView(
          children: [
            Container(
              height: 250,
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(
                        widget.bannerurl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                widget.name != null ? widget.name : 'Not Loaded',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  height: 150,
                  width: 100,
                  child: Image.network(widget.posterurl),
                ),
                Flexible(
                  child: Container(
                    child: Text(
                      widget.description != null
                          ? widget.description
                          : 'Not Loaded',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isAddedToWatchlist
                      ? _removeFromWatchlist
                      : _addToWatchlist,
                  child: Text(
                    isAddedToWatchlist ? 'Remove from Watchlist' : 'Add to Watchlist',
                  ),
                ),
              ],
            ),
          ],
        ),
      )
      );
      }
}