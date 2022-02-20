import 'package:beamer/beamer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/pokemons/data/models/pokemon_model_util.dart';
import 'package:pokemon/util/global_widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

Widget allPokemonsGrid(List<PokemonInfo> pokemons){

  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: GridView.builder(
      itemCount: pokemons.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
        crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2/2.5
        ),
        itemBuilder: (BuildContext context, int index){

          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(seconds: 1),
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: pokemonCard(context, pokemons[index]),
              ),
            ),
          );
        // return pokemonCard(context, pokemons[index]);
        }),
  );
}

// Widget animationKindGrid(){
//   return
// }
Widget pokemonCard(BuildContext context, PokemonInfo pokemon){
final theme = Theme.of(context);
  return Hero(
    tag: "pok${pokemon.pokemonName}",
    child: GestureDetector(

      onTap: () {

        Map<String, PokemonInfo> pokemonInfo = {"pokemon" : pokemon};
        return Beamer.of(context).beamToNamed('/pokemons', data: pokemonInfo);
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(imageUrl: pokemon.sprites!.home!,
            errorWidget: (_, __, ___){
              return imageErrorWidget;
            },
              placeholder: (_, __){
              return imagePlaceHolder(color: theme.primaryColorDark);
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
              child: Text('${pokemon.pokemonName}', style: theme.textTheme.subtitle1,),
            ),
          ],
        ),
      ),
    ),
  );
}
