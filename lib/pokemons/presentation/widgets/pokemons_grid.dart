import 'package:beamer/beamer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/pokemons/data/models/pokemon_model_util.dart';
import 'package:pokemon/pokemons/presentation/presentation_util.dart';
import 'package:pokemon/util/global_widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../util/extensions.dart';

Widget allPokemonsGrid(List<PokemonInfo> pokemons){

  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: GridView.builder(
      key: const Key("pokemon_grid"),
      itemCount: pokemons.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
        crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2/2.5
        ),
        itemBuilder: (BuildContext context, int index){

          // return AnimationConfiguration.staggeredGrid(
          //   position: index,
          //   duration: const Duration(seconds: 1),
          //   columnCount: 2,
          //   child: ScaleAnimation(
          //     child: FadeInAnimation(
          //       child: GestureDetector(
          //           onTap: () {
          //             Map<String, PokemonInfo> pokemonInfo = {"pokemon" : pokemons[index]};
          //             return Beamer.of(context).beamToNamed('/pokemons', data: pokemonInfo);
          //           },
          //           child: pokemonCard(context, pokemons[index], index)),
          //     ),
          //   ),
          // );
        return GestureDetector(
            onTap: () {
              Map<String, PokemonInfo> pokemonInfo = {"pokemon" : pokemons[index]};
              context.beamToNamed('/pokemons', data: pokemonInfo);
              // Navigator.push(context, MaterialPageRoute(builder: (context)
              // => SinglePokemonScreen(pokemon: pokemons[index])));
               // Beamer.of(buildContext).beamToNamed('/pokemons', data: pokemonInfo);
            },
          // child: AnimationConfiguration.staggeredGrid(
          //   position: index,
          //   duration: const Duration(seconds: 1),
          //   columnCount: 2,
          //   child: ScaleAnimation(
          //     child: FadeInAnimation(
          //       child: pokemonCard(context, pokemons[index], index),
          //     ),
          //   ),
          // ));
            child: pokemonCard(context, pokemons[index], index));
        }),
  );
}

// Widget animationKindGrid(){
//   return
// }
Widget pokemonCard(BuildContext context, PokemonInfo pokemon, int index){
final theme = Theme.of(context);
  return Hero(
    key: const Key("grid_hero"),
    tag: "pok${pokemon.pokemonName}$index",
    child: Card(
      key: const Key("grid_card"),
      child: Column(
        key: const Key("grid_column"),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CachedNetworkImage(
            key: const Key("grid_image"),
            imageUrl: pokemon.sprites!.home!,
          errorWidget: (_, __, ___){
            return imageErrorWidget;
          },
            placeholder: (_, __){
            return imagePlaceHolder(color: theme.primaryColorDark);
            },
          ),
          Padding(
            key: const Key("grid_pad"),
            padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
            child: Text(
              pokemon.pokemonName!.capitalize(), style: theme.textTheme.subtitle1,
              key: const Key("grid_text_name"),
            ),
          ),
        ],
      ),
    ),
  );
}
