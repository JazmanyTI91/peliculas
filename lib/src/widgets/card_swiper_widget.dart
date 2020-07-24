import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

//Clase para crear widget de las tarjetas y ya solo mandarlo llamar
class CardSwiper extends StatelessWidget{

  final List<Pelicula> peliculas;

  CardSwiper({@required this.peliculas});

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      //Hay que especificar las dimensiones del swiper
      child: Swiper(
        layout: SwiperLayout.STACK,
        //inicializamos los mediaquery y asignamos propiedades
        //para que tome el 70% ancho y 50% de alto
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index){
          //Hacer id unico para el Hero Animation
          peliculas[index].uniqueId = '${peliculas[index].id}-tarjeta';

          return Hero(
            tag: peliculas[index].uniqueId,
            child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'detalle', arguments: peliculas[index]),
                child: FadeInImage(
              //Cargamos las imagenes obtenidas de la api
              image: NetworkImage( peliculas[index].getPosterImg() ),
              //Asignamos una imagen por defecto para los poster inexistentes
              placeholder: AssetImage('assets/loading.gif'),
              fit: BoxFit.cover,
            ),
                ),
          ),
          );
        },
        itemCount: peliculas.length,
        //pagination: new SwiperPagination(),
        //control: new SwiperControl(),
      ),
    );
  }
}