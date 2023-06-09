import 'package:flutter/material.dart';
import 'package:movieapi/Screens/description.dart';

/*
  This is the playing now UI.
  This UI shows the movies playing now.
*/

class TvShowsPlaying extends StatelessWidget {
  final List playingnowtv;//list of movies playing now

  const TvShowsPlaying({Key? key, required this.playingnowtv})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text(
            'TV Shows Playing Now',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          Container(
            height: 270,
            child: ListView.builder(
              itemCount: playingnowtv.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {//navigate to description page
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Description(//pass data to description page
                                  name: playingnowtv[index]['original_name'],
                                  bannerurl:
                                      'https://image.tmdb.org/t/p/w500/' +
                                          playingnowtv[index]['backdrop_path'],
                                  posterurl:
                                      'https://image.tmdb.org/t/p/w500/' +
                                          playingnowtv[index]['poster_path'],
                                  description: playingnowtv[index]['overview'],
                                )));
                  },
                  child: playingnowtv[index]['poster_path'] != null//check if image is loaded
                      ? //if the image is not null then show the image
                      Container(
                          width: 140,
                          padding:
                              EdgeInsets.all(10.0), //spacing between images
                          child: Column(
                            children: [
                              playingnowtv[index]['poster_path'] == null
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
                                            'https://image.tmdb.org/t/p/w500/${playingnowtv[index]['poster_path']}',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                              Container(
                                padding: EdgeInsetsDirectional.only(
                                    top: 10.0), //spacing for text
                                child: Text(
                                  '${playingnowtv[index]['original_name'] != null ? playingnowtv[index]['original_name'] : 'Loading...'}',
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
