
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/models/search_response.dart';

import '../helpers/debouncer.dart';





class MoviesProvider extends ChangeNotifier{

  final String _apiKey = '';//get your API KEY in https://developers.themoviedb.org/3/getting-started/introduction
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';

  List<Movie> nowPlayingMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500)
    );

  final StreamController<List<Movie>> _sugStreamController = StreamController.broadcast();

  Stream<List<Movie>> get sugStream => _sugStreamController.stream;


  MoviesProvider() {
    print('Movies provider inicializado');

    getNowPlayingMovies();
    getPopularMovies();
  }

  Future<String> _getJsonnData(String segment, [int page = 1]) async {
    final url = Uri.https(_baseUrl, segment, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page'
    });

    final response = await http.get(url);
    return response.body;
  }

  getNowPlayingMovies() async {
    final data = await _getJsonnData('/3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(data);

    nowPlayingMovies = nowPlayingResponse.results;

    notifyListeners();
  }

  getPopularMovies() async {

    _popularPage++;
    final data = await _getJsonnData('/3/movie/popular', _popularPage);
    final popResponse = PopularResponse.fromJson(data);

    popularMovies = [ ...popularMovies, ...popResponse.results ];

    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    //todo revisar mapa
   
    if(moviesCast.containsKey(movieId)) return moviesCast[movieId]!;
    
    print('pidiennndo info cast');
     final data = await _getJsonnData('/3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(data);

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {

    final url = Uri.https(_baseUrl, '3/search/movie', {
        'api_key': _apiKey,
        'language': _language,
        'query': query
      });

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);
    return searchResponse.results;

  }

  void getSuggestionsByQuery(String searchTeam){
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await searchMovies(value);
      _sugStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = searchTeam;
    });

    Future.delayed(const Duration(milliseconds: 301))
    .then((_) => timer.cancel());
  }
    


}