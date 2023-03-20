import 'package:flutter/material.dart';
import 'package:movieapi/Screens/description.dart';
import 'package:tmdb_api/tmdb_api.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchTerm = '';
  List<dynamic> _searchResults = [];
  bool _isSearching = false;

  TextEditingController _searchController = TextEditingController();

  void _performSearch(String searchTerm) async {
    if (searchTerm.isEmpty) {
      setState(() {
        _searchTerm = '';
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    TMDB tmdb = TMDB(ApiKeys('721a00709b006f3718730986b3842949',
        'eyJhdWQiOiI3MjFhMDA3MDliMDA2ZjM3MTg3MzA5ODZiMzg0Mjk0OSIsInN1YiI6IjY0MTMyMjJkZWRlMWIwMjhlODRlMGQzZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ'));
    Map searchResult = await tmdb.v3.search.queryMulti(searchTerm);

    setState(() {
      _searchTerm = searchTerm;
      _searchResults = searchResult['results'];
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search for movies or TV shows',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  _performSearch(_searchController.text);
                },
              ),
            ),
            onSubmitted: (value) {
              _performSearch(value);
            },
          ),
        ),
        body: _isSearching
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _searchResults.isEmpty
                ? Center(
                    child: Text('No results found'),
                  )
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (BuildContext context, int index) {
                      var result = _searchResults[index];
                      String title = '';
                      String subtitle = '';
                      String imageUrl = '';
                      String type = result['media_type'];

                      if (type == 'movie') {
                        title = result['title'];
                        subtitle = result['release_date'];
                        imageUrl =
                            'https://image.tmdb.org/t/p/w500${result['poster_path']}';
                      } else if (type == 'tv') {
                        title = result['name'];
                        subtitle = result['first_air_date'];
                        imageUrl =
                            'https://image.tmdb.org/t/p/w500${result['poster_path']}';
                      }

                      if (title.isEmpty || imageUrl.isEmpty) {
                        return SizedBox.shrink();
                      }

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Description(
                                name: title,
                                bannerurl:
                                    'https://image.tmdb.org/t/p/w500${result['backdrop_path']}',
                                posterurl:
                                    'https://image.tmdb.org/t/p/w500${result['poster_path']}',
                                description: result['overview'],
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: Image.network(
                            imageUrl,
                            width: 60,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Container(
                                width: 60,
                                height: 80,
                                color: Colors.grey,
                              );
                            },
                          ),
                          title: Text(title),
                          subtitle: Text(subtitle),
                        ),
                      );
                    },
                  ));
  }
}
