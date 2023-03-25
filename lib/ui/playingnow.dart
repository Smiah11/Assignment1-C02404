import 'package:flutter/material.dart';
import 'package:movieapi/Screens/description.dart';

/*
  This is the playing now UI.
  This UI shows the movies playing now.
*/
class MoviesPlaying extends StatelessWidget {
  final List playingnow;//list of movies playing now
  const MoviesPlaying({super.key, required this.playingnow});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text(
            'Movies Playing Now',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 270,
            child: ListView.builder(
              itemCount: playingnow.length,
              scrollDirection: Axis.horizontal,//horizontal listview
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(//navigate to description page
                        context,
                        MaterialPageRoute(
                            builder: (context) => Description(//pass data to description page
                                  name: playingnow[index]['title'],
                                  bannerurl:
                                      'https://image.tmdb.org/t/p/w500/' +
                                          playingnow[index]['backdrop_path'],
                                  posterurl:
                                      'https://image.tmdb.org/t/p/w500/' +
                                          playingnow[index]['poster_path'],
                                  description: playingnow[index]['overview'],
                                )));
                  },
                  child: playingnow[index][
                              'title'] /*&'https://image.tmdb.org/t/p/w500/${playingnow[index]['poster_path']}'*/ !=
                          null
                      ? Container(
                          width: 140,
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              playingnow[index]['poster_path'] == null//check if image is loaded
                                  ? Container(
                                      height: 200,
                                      child: Center(
                                        child: CircularProgressIndicator(),//show progress indicator if image is not loaded
                                      ),
                                    )
                                  : Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            'https://image.tmdb.org/t/p/w500/${playingnow[index]['poster_path']}',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                              Container(
                                padding: EdgeInsets.only(top: 2.0),
                                child: Text(
                                  '${playingnow[index]['title'] != null ? playingnow[index]['title'] : 'Loading...'}',
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
