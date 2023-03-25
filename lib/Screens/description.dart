import 'package:flutter/material.dart';
import 'package:movieapi/Database/DatabaseHelper.dart';
import 'package:movieapi/Models/WatchlistModel.dart';

/*
  This is the description page of the movie/tvshow.
  This page shows the name, description, banner and poster of the movie/tvshow.
  This page also has a button to add the movie/tvshow to the watchlist.
*/

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
  bool isAddedToWatchlist = false;//check if movie/tvshow is in watchlist

  @override
  void initState() {
    super.initState();
    _checkIfAddedToWatchlist();
  }

  void _addToWatchlist() async {//add movie/tvshow to watchlist
    WatchlistModel watchlistModel = WatchlistModel(
      id: null,
      name: widget.name,
      description: widget.description,
      bannerurl: widget.bannerurl,
      posterurl: widget.posterurl,
    );
    int id = await DatabaseHelper.instance.insertWatchlist(watchlistModel);//insert data into database
    watchlistModel.id = id;
    setState(() {
      isAddedToWatchlist = true;
    });
    //pop up message to show that movie/tvshow is added to watchlist
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to Watchlist'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _removeFromWatchlist() async {//remove movie/tvshow from watchlist
    await DatabaseHelper.instance.deleteWatchlistByName(widget.name);//delete data from database
    setState(() {
      isAddedToWatchlist = false;
    });
    //pop up message to show that movie/tvshow is removed from watchlist
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed from Watchlist'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _checkIfAddedToWatchlist() async {//check if movie/tvshow is in watchlist
    bool isAdded =
        await DatabaseHelper.instance.isMovieInWatchlist(widget.name);
    setState(() {
      isAddedToWatchlist = isAdded;//set state to true if movie/tvshow is in watchlist
    });
  }

  @override
  Widget build(BuildContext context) {//build description page
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
                  Flexible(//description text
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
                  ElevatedButton(//add to watchlist button
                    onPressed: isAddedToWatchlist
                        ? _removeFromWatchlist
                        : _addToWatchlist,
                    child: Text(
                      isAddedToWatchlist
                          ? 'Remove from Watchlist'
                          : 'Add to Watchlist',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
