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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
        // actions: [
        //   IconButton(
        //     onPressed: , 
        //     icon: const Icon(Icons.favorite_border_outlined)
        //   )
        // ],
        ),
      body: FutureBuilder(
        future: apiPopular!.getAllPopular(), 
        builder: (context, AsyncSnapshot<List<PopularModel>?> snapshot){
          if(snapshot.hasData){
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: .9
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index){
                return GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                          MovieDetailScreen(movie: snapshot.data![index]),
                      ),
                    );
                  },
                  
                  child: Hero(
                    tag: 'moviePoster_${snapshot.data![index].id}',
                    child: itemMovieWidget(snapshot.data![index]),
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