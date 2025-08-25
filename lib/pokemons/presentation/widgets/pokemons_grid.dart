import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon/pokemons/bloc/pokemon_bloc_util.dart';
import 'package:pokemon/pokemons/data/models/pokemon_model_util.dart';
import 'package:pokemon/util/global_widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../util/extensions.dart';

// Widget allPokemonsGrid(List<PokemonInfo> pokemons){
//
//   return Padding(
//     padding: const EdgeInsets.all(10.0),
//     child: GridView.builder(
//       key: const Key("pokemon_grid"),
//       // itemCount: pokemons.length,
//       itemCount: pokemons.length + 1,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//         crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//           childAspectRatio: 2/2.5
//         ),
//         itemBuilder: (BuildContext context, int index){
//
//          if(index >= pokemons.length){
//            context.read<PokemonsBloc>().add(PokemonsFetched(pageNumber: 2));
//            return const Text("Loading...");
//          }
//           return AnimationConfiguration.staggeredGrid(
//            position: index,
//            duration: const Duration(seconds: 1),
//            columnCount: 2,
//            child: ScaleAnimation(
//              child: FadeInAnimation(
//                child: pokemonCard(context, pokemons[index]),
//              ),
//            ),
//          );
//
//         }),
//   );
// }

class AllPokemonsGrid extends StatelessWidget {
  final PokemonsLoaded state;
  const AllPokemonsGrid({required this.state, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PokemonsBloc>();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
          // controller: bloc.scrollController,
          key: const Key("pokemon_grid"),
          // itemCount: pokemons.length,
          itemCount: (state.hasReachedMax ?? false) ? state.pokemons.length : state.pokemons.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2/2.5
          ),
          itemBuilder: (BuildContext context, int index){
            if(index >= state.pokemons.length){
              context.read<PokemonsBloc>().add(PokemonsFetched());
              return const Text("Loading...");
            }
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(seconds: 1),
              columnCount: 2,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: pokemonCard(context, state.pokemons[index]),
                ),
              ),
            );

          }),
    );
  }
}


// Widget animationKindGrid(){
//   return
// }
Widget pokemonCard(BuildContext context, PokemonInfo pokemon){
final theme = Theme.of(context);
  return Hero(
    key: const Key("grid_hero"),
    tag: "pok${pokemon.pokemonName}",
    child: GestureDetector(
      onTap: () {
        context.push("/gallery/creature", extra: pokemon);
      },
      child: Card(
        key: const Key("grid_card"),
        child: SingleChildScrollView(
          child: Column(
            key: const Key("grid_column"),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CachedNetworkImage(
                height: 150,
                width: 150,
                key: const Key("grid_image"),
                imageUrl: pokemon.sprites?.artWork ?? "",
              errorWidget: (_, __, ___){
                return imageErrorWidget(size: 150);
              },
                placeholder: (_, __){
                return imagePlaceHolder(color: theme.primaryColorDark, size: 150);
                },
              ),
              const SizedBox(height: 8.0,),
              Padding(
                key: const Key("grid_pad"),
                padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                child: Text(
                  pokemon.pokemonName!.capitalize(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                  key: const Key("grid_text_name"),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
