import 'package:flutter/material.dart';
import 'package:pmsn20232/models/popular_model.dart';
import 'package:pmsn20232/network/api_popular.dart';
import 'package:pmsn20232/screens/movie_detail_screen.dart';
import 'package:pmsn20232/widgets/item_movie_widget.dart';

class PopularScreen extends StatefulWidget {
  const PopularScreen({super.key});

  @override
  State<PopularScreen> createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen> {

  ApiPopular? apiPopular;
  bool showFavoritesOnly = false;

  @override
  void initState(){
    super.initState();
    apiPopular = ApiPopular();
  }

  void _toggleFavoritesOnly(){
    setState(() {
      showFavoritesOnly = !showFavoritesOnly;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
         actions: [
           IconButton(
             onPressed: _toggleFavoritesOnly, 
             icon: showFavoritesOnly
              ? const Icon(Icons.favorite)
              : const Icon(Icons.favorite_border_outlined)
            )
          ],
        ),
      body: FutureBuilder(
        future: apiPopular!.getAllPopular(), 
        builder: (context, AsyncSnapshot<List<PopularModel>?> snapshot){
          if(snapshot.hasData){
            final moviesToShow = showFavoritesOnly
              ? snapshot.data!.where((movie) => movie.isFavorite).toList()
              :snapshot.data!;

            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: .9
              ),
              itemCount: moviesToShow.length,
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                          MovieDetailScreen(movie: moviesToShow[index]),
                      ),
                    );
                  },
                  
                  child: Hero(
                    tag: 'moviePoster_${moviesToShow[index].id}',
                    child: itemMovieWidget(moviesToShow[index]),
                  )
                );
              },
            );
          }else{
            if(snapshot.hasError){
              return Center(child: Text('Algo salió mal :()'));
            }else{
              return CircularProgressIndicator();
            }
          }
        }),
    );
  }
}