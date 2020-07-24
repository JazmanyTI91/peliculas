import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';


class HomePage extends StatelessWidget
{

  final peliculasProvider = new PeliculasProvider();


  @override
  Widget build(BuildContext context) {

    peliculasProvider.getPopulares();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Peliculas En Cines'),
        backgroundColor: Colors.pinkAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon( Icons.search ),
            color: Colors.white70,
            hoverColor: Colors.black54,
            onPressed: (){
              showSearch(context: context, delegate: DataSearch());
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            //lamamos el metodo swiper tarjetas
            _swiperTarjetas(),
            //llamamos metodo footer
            _footer(context)
          ],
        ),
      )
    );
  }


  //Método para crear las tarjetas
  Widget _swiperTarjetas()
  {
    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot){
        if(snapshot.hasData)
        {
          return CardSwiper(peliculas: snapshot.data);
        }else{
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }


  Widget _footer(BuildContext context)
  {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 25.0),
          child: Text('Populares', style: Theme.of(context).textTheme.subhead),
          ),
          SizedBox(height: 5.0,),

          StreamBuilder(
            stream: peliculasProvider.populareStream,
            builder: ( BuildContext context, AsyncSnapshot<List> snapshot){

              if( snapshot.hasData )
                {
                  return MovieHorizontal(
                      peliculas: snapshot.data,
                  siguientePagina: peliculasProvider.getPopulares);
                }else{
                return Center(child:CircularProgressIndicator());
              }
            },
          ),

        ],
      ),
    );
  }


}