import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pmsn20232/models/popular_model.dart';

class MovieDetailScreen extends StatelessWidget {

  final PopularModel movie;

  MovieDetailScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: 'moviePoster_${movie.id}', 
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://image.tmdb.org/t/p/w500/${movie.posterPath}'),
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
          children: [],
        ),
        // Column(
        //   children: [
        //     Hero(
        //       tag: 'moviePoster_${movie.id}', 
        //       child: Image.network('https://image.tmdb.org/t/p/w500/${movie.posterPath}'),
        //     )
        //   ],
        // )
      ],
    );
  }
}