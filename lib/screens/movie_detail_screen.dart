import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:pmsn20232/models/popular_model.dart';
import 'package:pmsn20232/network/api_trailer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailScreen extends StatefulWidget {

  final PopularModel movie;

  MovieDetailScreen({required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  String? trailerKey;

  @override
  void initState(){
    ApiTrailer().getTrailerVideoKey(widget.movie.id!).then((key){
      setState(() {
        trailerKey = key;
      });
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
          ],
        ),
      ],
    );
  }
}