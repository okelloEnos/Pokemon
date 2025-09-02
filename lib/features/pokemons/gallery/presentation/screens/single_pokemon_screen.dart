import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/core_barrel.dart';
import '../../../../features_barrel.dart';

class SinglePokemonScreen extends StatelessWidget {
  final PokemonInfoEntity pokemon;
  const SinglePokemonScreen({Key? key, required this.pokemon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final PageStorageBucket _bucket = PageStorageBucket();
    final height = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: theme.cardColor,
      body: Column(
        children: [
          SizedBox(
            height: height,
            child: Container(
                color: Color(pokemonColorValues.cardColor)
            ),
          ),
          Hero(
            tag: "pok${pokemon.pokemonName}",
            child: Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0)
                  )
              ),
              child: PageStorage(
                bucket: _bucket,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              color: theme.primaryColorDark,
                              onPressed: () => context.pop(), icon: const Icon(CupertinoIcons.back)),
                          // const SizedBox(width: 50,),
                          Expanded(
                            child: Center(
                              child: Text(pokemon.pokemonName!.capitalize(), style: theme.textTheme.titleLarge
                                // TextStyle(color: theme.primaryColorDark,
                                //     fontWeight: FontWeight.bold, fontSize: 22),
                              ),
                            ),
                          )
                        ],),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: pokemon.sprites?.artWork != null ? pokemonImageCard(image: pokemon.sprites!.artWork!,type: "Art Work", context: context) : const SizedBox.shrink(),
                      ),
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width,
                      //   child: CarouselSlider(
                      //       items: [
                      //         pokemon.sprites?.home != null ? pokemonImageCard(image: pokemon.sprites!.home!,type: "Home Art", context: context) : const SizedBox.shrink(),
                      //         pokemon.sprites?.artWork != null ? pokemonImageCard(image: pokemon.sprites!.artWork!,type: "Art Work", context: context) : const SizedBox.shrink(),
                      //       ],
                      //       options: CarouselOptions(
                      //         // height: 200,
                      //         aspectRatio: 3.1/2,
                      //         viewportFraction: 0.8,
                      //         initialPage: 0,
                      //         enableInfiniteScroll: false,
                      //         reverse: false,
                      //         autoPlay: true,
                      //         autoPlayInterval: const Duration(seconds: 3),
                      //         autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      //         autoPlayCurve: Curves.fastOutSlowIn,
                      //         enlargeCenterPage: true,
                      //         // onPageChanged: callbackFunction,
                      //         scrollDirection: Axis.horizontal,
                      //       )
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Text("${pokemon.pokemonName}"),
          Text("${pokemon.description}"),
          Text("${pokemon.genus}"),

          for(AbilitiesEntity ability in pokemon.abilities ?? []) Text(ability.ability?.name ?? ""),
          for(PokemonTypesEntity type in pokemon.types ?? []) Text(type.pokemonType?.name ?? ""),

          Text("${pokemon.baseExperience}"),
          Text("${pokemon.pokemonHeight ?? 0 / 10} m"),
          Text("${pokemon.pokemonWeight ?? 0 / 10} kg"),

          Text("${pokemon.growthRate}"), // growth rate
          for(DataEntity egg in pokemon.eggGroups ?? []) Text(egg.name ?? ""), // egg groups
          Text("${pokemon.genderSplit}"), // gender split
          Text("${pokemon.hatchCounter}"), // hatch steps
          Text("${pokemon.captureRate}"), // capture rate
          Text("${pokemon.baseHappiness}"), // base happiness
          for(PokemonInfoEntity variant in pokemon.variantsComplete ?? []) Text(variant.pokemonName ?? ""), // pokemon varieties

          Expanded(
            child : Card(
              margin: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30), topRight: Radius.circular(30)
                  )
              ),
              color: Colors.white,
              child: PokemonsDetailsTab(pokemonInfo: pokemon,),
            ),
          )
        ],
      ),
    );
  }
}
