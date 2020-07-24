import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/actores_model.dart';

import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider
{

  //Variables de la api
  String _apikey = '9a01ebfe40c5a03e91b26d3c4b8e1d89';
  String _url = 'api.themoviedb.org';
  String _lenguage = 'es-ES';

  //propiedades nuevas para utilizar patrón bloc
  int _popularesPage = 0;
  //variable para controlar las peticiones http y carga
  bool _cargando = false;

  List<Pelicula> _populares= new List();
  //creamos el Stream para flujo de trabajo
  //broadcast nos sirve para tener varios listener
  final _populareStreamController = StreamController<List<Pelicula>>.broadcast();

  //Nos sirve para agregar SINK
  Function(List<Pelicula>) get popularesSink => _populareStreamController.add;

  //Método para escuchar las peliculas
  Stream<List<Pelicula>> get populareStream => _populareStreamController.stream;


  //Metodo para controlar el Stream
  void disposeStreams()
  {
    _populareStreamController?.close();
  }


  Future<List<Pelicula>> _procesarRespuesta(Uri url) async
  {
    final resp = await http.get( url );
    final decodeData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodeData['results']);
    return peliculas.items;
  }


  //Metodo para obtener los posters
  Future<List<Pelicula>>getEnCines() async
  {
    //direcion general del api (imagenes)
    final url = Uri.http(_url, '3/movie/now_playing', {
      'api_key'  : _apikey,
      'language' : _lenguage
    });

    return await _procesarRespuesta(url);
  }


  Future<List<Pelicula>>getPopulares() async
  {
    if( _cargando ) return [];
    _cargando = true;

    _popularesPage ++;

    final url = Uri.http(_url, '3/movie/popular', {
      'api_key'  :  _apikey,
      'language' :  _lenguage,
      'page'     : _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);
    _populares.addAll(resp);
    popularesSink( _populares );

    _cargando = false;
    return resp;
  }


  Future <List<Actor>> getCast( String IdPeli ) async
  {
    final url = Uri.http(_url, '3/movie/$IdPeli/credits', {
      'api_key'  :  _apikey,
      'language' :  _lenguage
    });

    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodeData['cast']);

    return cast.actores;
  }


  //Servicio para buscar peliculas dentro del api

  Future<List<Pelicula>>buscarPelicula(String query) async
  {
    //direcion general del api (imagenes)
    final url = Uri.http(_url, '3/search/movie', {
      'api_key'  : _apikey,
      'language' : _lenguage,
      'query'    : query
    });

    return await _procesarRespuesta(url);
  }
}