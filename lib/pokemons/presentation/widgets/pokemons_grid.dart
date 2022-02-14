import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/util/global_widgets.dart';

Widget AllPokemonsGrid(){

  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: GridView.builder(
      itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
        crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2/2.5
        ),
        itemBuilder: (BuildContext context, int index){
        return PokemonCard(context);
        }),
  );
}

Widget PokemonCard(BuildContext context){
final theme = Theme.of(context);
  return Card(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CachedNetworkImage(imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/1.png",
        errorWidget: (_, __, ___){
          return imageErrorWidget;
        },
          placeholder: (_, __){
          return imagePlaceHolder(color: theme.primaryColorDark);
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
          child: Text('Okello', style: theme.textTheme.subtitle1,),
        ),
      ],
    ),
  );
}
