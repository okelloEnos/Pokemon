import 'package:beamer/beamer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pokemon/pokemons/data/models/pokemon_model_util.dart';
import 'package:pokemon/pokemons/presentation/widgets/scrolling_images.dart';
import 'package:pokemon/util/global_widgets.dart';

Widget singlePokemonWidget({required PokemonInfo pokemon, required BuildContext context}){

  final theme = Theme.of(context);

  return Column(
    children: [
      Card(
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)
          )
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(onPressed: () => Beamer.of(context).beamBack(), icon: const Icon(CupertinoIcons.back)),
                const SizedBox(width: 50,),
                Center(
                  child: Text(pokemon.pokemonName!, style: TextStyle(color: theme.primaryColorDark,
                      fontWeight: FontWeight.bold, fontSize: 22),),
                )
              ],),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CarouselSlider(
                  items: [
                    pokemonImageCard(image: pokemon.sprites!.home!,type: "Home Art", context: context),
                    pokemonImageCard(image: pokemon.sprites!.artWork!,type: "Art Work", context: context),
                  ],
                  options: CarouselOptions(
                    // height: 200,
                    aspectRatio: 3.1/2,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    // onPageChanged: callbackFunction,
                    scrollDirection: Axis.horizontal,
                  )
              ),
            ),
          ],
        ),
      ),

    ],
  );
}


Widget pokemonImageCard({required String image,required String type, required BuildContext context}){
  final theme = Theme.of(context);

  return  SingleChildScrollView(
    child: Column(
      children: [
        SizedBox(
          height: 180,
          child: CachedNetworkImage(imageUrl: image,
            errorWidget: (_, __, ___){
              return imageErrorWidget;
            },
            placeholder: (_, __){
              return imagePlaceHolder(color: theme.primaryColorDark);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(type, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        )
      ],
    ),
  );
}