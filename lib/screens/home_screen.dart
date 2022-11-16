import 'package:flutter/material.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:peliculas_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:peliculas_app/search/search_delegate.dart';

class HomeScreen extends StatelessWidget {
  //const DetailsScreen({ Key? key }) : super(key: key);


  @override
  Widget build(BuildContext context) {


    final moviesProvider = Provider.of<MoviesProvider>(context);

   // print(moviesProvider.nowPlayingMovies);

    return Scaffold(
      appBar: AppBar(
        title: Text('Peliculas en cines'),
        elevation: 0,
        actions: [
          IconButton(onPressed: ()=>showSearch(context: context, delegate: MovieSearchDelegate()),
          icon: Icon(Icons.search_outlined))
        ],

      ),
      body:  SingleChildScrollView(
        child: Column(
          children: [
            //TODO: cardSwiper
            CardSwiper( movies: moviesProvider.nowPlayingMovies ),
            //listado horizonal pelis
            MovieSlider(
              movies: moviesProvider.popularMovies,
              title: 'Populares',
              onNextPage: () => moviesProvider.getPopularMovies(),
              )
          ],
        ),
      )
    );
  }
}