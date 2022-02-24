import 'package:beamer/beamer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pokemon/pokemons/data/models/pokemon_model_util.dart';
import 'package:pokemon/util/app_colors.dart';
import 'package:pokemon/util/extensions.dart';
import 'package:pokemon/util/global_widgets.dart';
import 'package:pokemon/util/extensions.dart';

Widget singlePokemonWidget({required PokemonInfo pokemon, required BuildContext context}){

  final theme = Theme.of(context);
final height = MediaQuery.of(context).padding.top;
  return Column(
    key: const Key('single_pokemon_column'),
    children: [
      SizedBox(
        height: height,
        child: Container(
          color: Color(pokemonColorValues.cardColor)
        ),
      ),
      Hero(
        key: const Key('single_pokemon_hero'),
        tag: "pok${pokemon.pokemonName}",
        child: Card(
          key: const Key('single_pokemon_card_image'),
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0)
            )
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      key: const Key('single_pokemon_back_button'),
                      color: theme.primaryColorDark,
                      onPressed: () => Beamer.of(context).beamBack(), icon: const Icon(CupertinoIcons.back)),
                  const SizedBox(width: 50,),
                  Center(
                    child: Text(pokemon.pokemonName!.capitalize(), style: theme.textTheme.headline5,
                      key: const Key('single_pokemon_text_name'),
                    // TextStyle(color: theme.primaryColorDark,
                    //     fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  )
                ],),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                    key: const Key('single_pokemon_carousel'),
                    items: [
                      pokemonImageCard(image: pokemon.sprites!.home!,type: "Home Art", context: context, key: const Key('single_pokemon_carousel_image')),
                      pokemonImageCard(image: pokemon.sprites!.artWork!,type: "Art Work", context: context,  key: const Key('single_pokemon_carousel_image')),
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
      ),
      Expanded(
        child : Card(
          key: const Key('single_pokemon_tabs_card'),
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
      // const LogoAnimation()
    ],
  );
}

Widget pokemonImageCard({required String image,required String type, required BuildContext context, Key? key}){
  final theme = Theme.of(context);

  return  SingleChildScrollView(
    child: Column(
      children: [
        SizedBox(
          height: 180,
          child: CachedNetworkImage(
            key: const Key('single_pokemon_image'),
            imageUrl: image,
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
          child: Text(
            type,
            key: const Key('single_pokemon_type_text'),
            style: TextStyle(fontFamily: 'Lemonada', fontSize: 20, fontWeight: FontWeight.bold, color: theme.primaryColorDark),),
        )
      ],
    ),
  );
}


class PokemonsDetailsTab extends StatefulWidget {
  const PokemonsDetailsTab({Key? key, required this.pokemonInfo}) : super(key: key);

  final PokemonInfo pokemonInfo;

  @override
  _PokemonsDetailsTabState createState() => _PokemonsDetailsTabState();
}

class _PokemonsDetailsTabState extends State<PokemonsDetailsTab> with SingleTickerProviderStateMixin{
late TabController _tabController;
static const List<Tab> pokemonsTabs = <Tab>[
  Tab(text: "About"),
  Tab(text: "Stats",),
  Tab(text: "Evolution",),
  Tab(text: "Moves",)
];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: TabBar(
            key: const Key('single_pokemon_tab_bar'),
          indicatorPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 0),
            indicatorColor: theme.primaryColor,
            indicatorWeight: 5,
            controller: _tabController,
            tabs: pokemonsTabs
        ),
        body: TabBarView(
          key: const Key('single_pokemon_tab_view'),
          controller: _tabController,
          children: pokemonsTabs.map((Tab tab){
            switch(tab.text){
              case "Moves":
                return pokemonMovesWidget(pokemon: widget.pokemonInfo, context: context, key: const Key('single_pokemon_moves_widget'));
              case "Stats":
                return pokemonStatsWidget(pokemon: widget.pokemonInfo, context: context, key: const Key('single_pokemon_stats_widget'));
              case "Evolution" :
                return pokemonEvolutionWidget(pokemon: widget.pokemonInfo, context: context, key: const Key('single_pokemon_evolution_widget'));
              case "About" :
              default:
              return pokemonAboutWidget(pokemon: widget.pokemonInfo, context: context, key: const Key('single_pokemon_about_widget'),);
            }
        }).toList(),
      ),
      ),
    );
  }

@override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}


Widget pokemonAboutWidget({required PokemonInfo pokemon, required BuildContext context, Key? key}){
  final theme = Theme.of(context);
  String abilities = "";
  for(var ability in pokemon.abilities!) {
  abilities += ability.ability!.name!;
  if(pokemon.abilities!.last != ability){
    abilities += ", ";
  }
  }

  return SingleChildScrollView(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0, bottom: 0.0),
          child: Row(
            key: const Key('single_pokemon_species_information'),
            children: [
              Text('Species', style: theme.textTheme.bodyText1,),
              const SizedBox(width: 90, ),
              Text('${pokemon.species!.name}', style: theme.textTheme.subtitle2,)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0, bottom: 0.0),
          child: Row(
            key: const Key('single_pokemon_height_information'),
            children: [
              Text('Height', style: theme.textTheme.bodyText1,),
              const SizedBox(width: 100, ),
              Text('${pokemon.pokemonHeight} Meters', style: theme.textTheme.subtitle2,)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0, bottom: 0.0),
          child: Row(
            key: const Key('single_pokemon_weight_information'),
            children: [
              Text('Weight', style: theme.textTheme.bodyText1,),
              const SizedBox(width: 100, ),
              Text('${pokemon.pokemonWeight} Kg', style: theme.textTheme.subtitle2,)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0, bottom: 0.0),
          child: Row(
            key: const Key('single_pokemon_experience_information'),
            children: [
              Text('Base Experience', style: theme.textTheme.bodyText1,),
              const SizedBox(width: 40, ),
              Text('${pokemon.baseExperience} CAL', style: theme.textTheme.subtitle2,)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0, bottom: 0.0),
          child: Row(
            key: const Key('single_pokemon_abilities_information'),
            children: [
              Text('Abilities', style: theme.textTheme.bodyText1,),
              const SizedBox(width: 90, ),
                Flexible(child: Text('$abilities, ', style: theme.textTheme.subtitle2,))

            ],
          ),
        ),

      ],
    ),
  );
}

Widget pokemonStatsWidget({required PokemonInfo pokemon, required BuildContext context, Key? key}){
  final theme = Theme.of(context);
  return Padding(
    // key: const Key('single_pokemon_stats_information'),
    padding: const EdgeInsets.only(top: 10),
    child: ListView.builder(
        key: const Key('single_pokemon_stats_builder'),
        itemCount: pokemon.stats!.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
      var stat = pokemon.stats![index];
      return Padding(
          // key: const Key('single_pokemon_stats_information'),
        padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 0.0),
        child: pokemonStatWidget(context: context, stat: stat),
      );
    }),
  );
}

Widget pokemonEvolutionWidget({required PokemonInfo pokemon, required BuildContext context, Key? key}){
  final theme = Theme.of(context);
  return Column(
    children: [
      Row(
        key: const Key('single_pokemon_evolution_information'),
        children: [
          const Text('Height'),
          Text('${pokemon.pokemonHeight}')
        ],
      )
    ],
  );
}

Widget pokemonMovesWidget({required PokemonInfo pokemon, required BuildContext context, Key? key}){
  final theme = Theme.of(context);
  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: ListView.builder(
        key: const Key('single_pokemon_moves_builder'),
        itemCount: pokemon.moves!.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
          var move = pokemon.moves![index];
          return Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 0.0),
            child: pokemonMoveWidget(context: context, moves: move),
          );
        }),
  );
}

Widget pokemonStatWidget({required BuildContext context, required Stats stat, Key? key}){
final theme = Theme.of(context);
var statValue = stat.baseStat! / 100;
  return Row(
    key: const Key('single_pokemon_stats_information'),
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 30, bottom: 10),
        child: SizedBox(
            width: 80,
            child: Text(stat.stat!.name!.capitalize(), style: TextStyle(
              fontSize: 10, color: theme.textTheme.bodyText1!.color,
              fontFamily: theme.textTheme.bodyText1!.fontFamily
            ),)),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 20, bottom: 10),
        child: Text("${stat.baseStat}", style: theme.textTheme.subtitle2,),
      ),
      SizedBox(
          width: 150,
          child: LinearProgressIndicator(backgroundColor: Colors.grey[200], minHeight: 4,
          value: statValue, color: statValue > 0.5 ? Colors.green : Colors.red,)),
    ],
  );
}

Widget pokemonMoveWidget({required BuildContext context, required Moves moves}){
  final theme = Theme.of(context);

  return Card(
    key: const Key('single_pokemon_moves_information'),
    color: Colors.white,
    margin: EdgeInsets.zero,
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(moves.move!.name!.capitalize(), style: theme.textTheme.subtitle2,),
  Text("Level 1", style: theme.textTheme.bodyText1,)
        ],),
          CircularProgressIndicator(
            value: 0.6,
            backgroundColor: Colors.grey[200],
            color: Colors.green,
          )
        ],
      ),
    ),
  );
}