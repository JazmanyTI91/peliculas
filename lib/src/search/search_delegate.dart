import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';



//SEARCH DELEGATE PARA HACER FUNCIONAR BOTON SEARCH
class DataSearch extends SearchDelegate
{

  String selection = '';
  final peliculasProvider = new PeliculasProvider();
  
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: Acciones de nuestro app bar
    return [
      IconButton(
        icon: Icon( Icons.clear ),
        onPressed: (){
            query = '';
          },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: Icono a la izquierda del app bar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: Builder Crea los resultados que vamos a mostrar
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: Sugerencias que aparecen cuando la persona escribe
    if(query.isEmpty)
      {
        return Container();
      }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot){
        if(snapshot.hasData)
          {
            final peliculas = snapshot.data;
            return ListView(
              children: peliculas.map(( pelicula ){
                return ListTile(
                  leading: FadeInImage(
                    image: NetworkImage( pelicula.getPosterImg() ),
                    placeholder: AssetImage('assets/loading.gif'),
                    width: 50.0,
                    fit: BoxFit.cover,
                  ),
                  title: Text(pelicula.title),
                  subtitle: Text(pelicula.originalTitle),
                  onTap: (){
                    close(context, null);
                    pelicula.uniqueId = '';
                    Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                  },
                );
              }).toList()
            );
          }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }
  
  
  
}