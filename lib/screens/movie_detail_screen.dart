import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:pmsn20232/database/agenda_db.dart';
import 'package:pmsn20232/models/popular_model.dart';
import 'package:pmsn20232/network/api_cast.dart';
import 'package:pmsn20232/network/api_trailer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailScreen extends StatefulWidget {

  final PopularModel movie;
  final List<PopularModel> favoriteMovies;

  MovieDetailScreen({required this.movie, required this.favoriteMovies});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  String? trailerKey;
  List<Map<String, dynamic>> cast = [];
  bool isFavorite = false;

  @override
  void initState(){
    ApiTrailer().getTrailerVideoKey(widget.movie.id!).then((key){
      setState(() {
        trailerKey = key;
        isFavorite = widget.movie.isFavorite;
      });
    });

    ApiCast().getCast(widget.movie.id!).then((actors) {
      setState(() {
        cast = actors!;
      });
    });
  }

  void _toggleFavorite(){
    setState(() {
      isFavorite = !isFavorite;
      widget.movie.isFavorite = isFavorite;
      //agregar codigo para guardar en la bd
      final db = AgendaDB();
      if (isFavorite) {
      // Verifica si la película ya existe en la base de datos
      db.getFavoriteMovies().then((existingMovie) {

        bool movieExist = existingMovie.any((movie) => movie.id == widget.movie.id);

        if (!movieExist) {
          // La película no existe en la base de datos, realiza una inserción
          print('La siguiente pelicula se marco como favorita por lo que se guardará en la bd');
          db.insertFavoriteMovie(widget.movie).then((_) {
            db.getFavoriteMovies().then((favoriteMoviesList) {
              setState(() {
                widget.favoriteMovies.clear();
                widget.favoriteMovies.addAll(favoriteMoviesList);
              });
            });
          });
          print(widget.movie.id);
          print(widget.movie.originalLanguage);
          print(widget.movie.originalTitle);
          print(widget.movie.overview);
          print(widget.movie.popularity);
          print(widget.movie.posterPath);
          print(widget.movie.releaseDate);
          print(widget.movie.title);
          print(widget.movie.voteAverage);
          print(widget.movie.voteCount);
        } else {
        }
      });
    } else {
        // Si se desmarca como favorita, elimina la película de la base de datos
        db.deleteFavoriteMovie(widget.movie.id!).then((_) {
          db.getFavoriteMovies().then((favoriteMoviesList) {
            setState(() {
              widget.favoriteMovies.clear();
              widget.favoriteMovies.addAll(favoriteMoviesList);
            });
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final voteAverage = widget.movie.voteAverage;

    return Stack(
      children: [
        Hero(
          tag: 'moviePoster_${widget.movie.id}', 
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://image.tmdb.org/t/p/w500/${widget.movie.posterPath}'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withOpacity(0.3)),
            ),
          ),
        ),
        Column(
          children: [
            SizedBox(height: 25,),
            if(trailerKey != null)
              YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId: trailerKey!,
                  flags: YoutubePlayerFlags(
                    autoPlay: true,
                  ),
                ),
              ),
              if(trailerKey == null)
                Center(child: CircularProgressIndicator()),
            SizedBox(height: 20,),
            RatingStars(
              value: voteAverage!,
              starCount: 10,
              starSize: 25,
              valueLabelVisibility: true,
              valueLabelRadius: 10,
              maxValue: 10,
              starSpacing: 2,
              starColor: Colors.yellow,
              valueLabelColor: const Color(0xff9b9b9b),
              valueLabelTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                fontSize: 12.0,
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(widget.movie.overview!, style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.normal,
                fontSize: 12.0,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: 20,),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cast.length,
                itemBuilder: (context, index) {
                  final actor = cast[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage('https://image.tmdb.org/t/p/w185/${actor['profile_path']}'),
                        ),
                        SizedBox(height: 20,),
                        Text(
                          actor['name'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          actor['character'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            decoration: TextDecoration.none,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
              ),
            ), 
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonTheme(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 243, 320, 0)
                    ),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 60, 60, 60),
                      elevation: 0.0,
                      side: const BorderSide(color: Color.fromARGB(255, 243, 230, 0), width: 2),
                      minimumSize: const Size(40, 20)
                    ),
                    onPressed: _toggleFavorite,
                    child: Icon(
                      isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                      color: Color.fromARGB(255, 243, 230, 0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}