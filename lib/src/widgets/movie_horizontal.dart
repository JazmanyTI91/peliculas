import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';


class MovieHorizontal extends StatelessWidget{

  final List<Pelicula> peliculas;
  final Function siguientePagina;

  //Método constructor
  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  //Controller del page
  final _pageController = new PageController(
      initialPage: 1,
      viewportFraction: 0.3
  );

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    //Listener page controller
    _pageController.addListener( (){
      if(_pageController.position.pixels >= _pageController.position.maxScrollExtent -200)
        {
          siguientePagina();
        }
    });


    return Container(
      height: _screenSize.height * 0.25,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        //children: _tarjetas(context),
        itemCount: peliculas.length,
        itemBuilder: (context, i){
          return _tarjeta(context, peliculas[i]);
        },
      ),
    );
  }

  //Método para crear nueva tarjeta
  Widget _tarjeta(BuildContext context, Pelicula pelicula)
  {
    //Propiedad para controlar el id de Hero Animation
    pelicula.uniqueId = '${pelicula.id}-poster';

    final tarjeta =  Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage( pelicula.getPosterImg() ),
                placeholder: AssetImage('assets/loading.gif'),
                fit: BoxFit.cover,
                height: 148.0,
              )
          ),
          ),
          SizedBox(height: 5.0,),
          Text(pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption),
        ],
      ),
    );
    return GestureDetector(
      child: tarjeta,
      onTap: (){
        //mandamos los parametros a la vista pelicula_detalle
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
    );
  }



  List<Widget>_tarjetas(BuildContext context)
  {
    return peliculas.map( (pelicula) {
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage( pelicula.getPosterImg() ),
              placeholder: AssetImage('assets/loading.gif'),
              fit: BoxFit.cover,
              height: 150.0,
            )
            ),
            SizedBox(height: 5.0,),
            Text(pelicula.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption),
          ],
        ),
      );
    }).toList();
  }

}