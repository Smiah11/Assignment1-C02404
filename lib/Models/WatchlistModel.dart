
/* 
  This is the model class for the watchlist table in the database.
  It contains the fields of the table and the methods to convert the model to a map and vice versa.
*/

class WatchlistModel {
  int? id;
  String name;
  String description;
  String bannerurl;
  String posterurl;

  WatchlistModel({
    required this.id,
    required this.name,
    required this.description,
    required this.bannerurl,
    required this.posterurl,
  });

  Map<String, dynamic> toMap() {//convert watchlistmodel to map
    var map = <String, dynamic>{
      'name': name,
      'description': description,
      'bannerurl': bannerurl,
      'posterurl': posterurl,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  WatchlistModel.fromMap(Map<String, dynamic> map)//convert map to watchlistmodel
      : id = map['id'],
        name = map['name']!,
        description = map['description']!,
        bannerurl = map['bannerurl']!,
        posterurl = map['posterurl']!;
}
