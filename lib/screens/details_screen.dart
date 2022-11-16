import 'package:flutter/material.dart';
import 'package:peliculas_app/widgets/widgets.dart';
import '../models/models.dart';

class DetailsScreen extends StatelessWidget {
  //const DetailsScreen({ Key? key }) : super(key: key);
 
  @override
  Widget build(BuildContext context) {

 //todo : cambiar luego por una instancia d emovie
  final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
  print(movie.title);

    return Scaffold(
      //appBar: AppBar(),
      body:  CustomScrollView(
        slivers: [
          _CustomAppBar(title: movie.title, backDrop: movie.fullBackdropPath),
          SliverList(
            delegate: SliverChildListDelegate([
              _PosterAndTitle(title: movie.title, originaTitle: movie.originalTitle, average: movie.voteAverage.toString(), poster: movie.fullImageUrl, id: movie.heroId),
              _Overview(overview: movie.overview),
              _Overview(overview: movie.overview),
              _Overview(overview: movie.overview),
              CastingCards(movie.id)
            ]),
          )
        ],
      
      )
    );
  }
}



class _CustomAppBar extends StatelessWidget {

  final String title;
  final String backDrop;

  const _CustomAppBar({ Key? key, required this.title, required this.backDrop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(bottom: 15, left: 10, right: 10),
          color: Colors.black12,
          child: Text(
            this.title,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
            )
          ),
        background: FadeInImage(
          image:  NetworkImage(this.backDrop),
          placeholder: AssetImage('assets/loading.gif'),
          fit: BoxFit.cover
          ),
      ),
      
    );
  }
}


class _PosterAndTitle extends StatelessWidget {
  
      final String title;
      final String originaTitle;
      final String average;
      final String poster;
      final String? id;


  const _PosterAndTitle({ Key? key, required this.title, required this.originaTitle, required this.average,required this.poster, required this.id}) : super(key: key);
    @override
    Widget build(BuildContext context) {

    final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: this.id!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: AssetImage('assets/no-image.jpg'),
                image: NetworkImage(this.poster),
                height: 150
              ),
            ),
          ),

          SizedBox(width: 20),

          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
          
                Text(this.title,
                  style: textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  ),
          
                Text(this.originaTitle,
                style: textTheme.subtitle1,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                ),
          
                Row(
                  children: [
                    Icon( Icons.star_outline, size: 15, color: Colors.grey),
                    SizedBox(height: 5),
                    Text(this.average, style:  textTheme.caption)
                  ],
                )
              ]
            ),
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {

  final overview;
  const _Overview({ Key? key, required this.overview}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(this.overview,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}