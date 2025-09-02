import 'package:carousel_slider/carousel_slider.dart';
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
      // backgroundColor: theme.cardColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                            // Expanded(
                            //   child: Center(
                            //     child: Text(pokemon.pokemonName!.capitalize(), style: theme.textTheme.titleLarge
                            //       // TextStyle(color: theme.primaryColorDark,
                            //       //     fontWeight: FontWeight.bold, fontSize: 22),
                            //     ),
                            //   ),
                            // )
                          ],),
                        disableSlider ?
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: pokemon.sprites?.artWork != null ? pokemonImageCard(image: pokemon.sprites!.artWork!,type: "Art Work", context: context) : const SizedBox.shrink(),
                        ) :
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: CarouselSlider(
                              items: [
                                for(PokemonInfoEntity variant in pokemon.variantsComplete ?? []) variant.sprites?.artWork == null ? const SizedBox.shrink() : pokemonImageCard(image: variant.sprites!.artWork!,type: "Art Work", context: context)
                              ],
                              options: CarouselOptions(
                                // height: 200,
                                aspectRatio: 4.6/2,
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
                ),
              ),
            ),
            const SizedBox(height: 8.0,),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("${pokemon.pokemonName}".capitalize(), style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                  Text("(${pokemon.genus}, ${pokemon.habitat?.capitalize() ?? ""})", style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.grey),),
                  const SizedBox(height: 8.0,),
                  Text("${pokemon.description}", style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.grey),),
                ],
              ),
            ),
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
      ),
    );
  }
}
