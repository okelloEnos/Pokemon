import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/core_barrel.dart';
import '../../../../features_barrel.dart';

Widget singlePokemonWidget({required PokemonInfoEntity pokemon, required BuildContext context}){
  final PageStorageBucket _bucket = PageStorageBucket();
  final theme = Theme.of(context);
final height = MediaQuery.of(context).padding.top;
  return Column(
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
      // const LogoAnimation()
    ],
  );
}

Widget pokemonImageCard({required String image,required String type, required BuildContext context, double? height}){
  final theme = Theme.of(context);

  return SizedBox(
    height: height ?? 150,
    child: CachedNetworkImage(imageUrl: image,
      errorWidget: (_, __, ___){
        return imageErrorWidget();
      },
      placeholder: (_, __){
        return imagePlaceHolder(color: theme.primaryColorDark);
      },
    ),
  );
  return  SingleChildScrollView(
    child: Column(
      children: [
        SizedBox(
          height: 150,
          child: CachedNetworkImage(imageUrl: image,
            errorWidget: (_, __, ___){
              return imageErrorWidget();
            },
            placeholder: (_, __){
              return imagePlaceHolder(color: theme.primaryColorDark);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(type, style: TextStyle(fontFamily: 'Lemonada', fontSize: 20, fontWeight: FontWeight.bold, color: theme.primaryColorDark),),
        )
      ],
    ),
  );
}


class PokemonsDetailsTab extends StatefulWidget {
  const PokemonsDetailsTab({Key? key, required this.pokemonInfo}) : super(key: key);

  final PokemonInfoEntity pokemonInfo;

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
          indicatorPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 0),
            indicatorColor: theme.primaryColor,
            indicatorWeight: 5,
            controller: _tabController,
            tabs: pokemonsTabs
        ),
        body: TabBarView(
          controller: _tabController,
          children: pokemonsTabs.map((Tab tab){
            switch(tab.text){
              case "Moves":
                return pokemonMovesWidget(pokemon: widget.pokemonInfo, context: context);
              case "Stats":
                return pokemonStatsWidget(pokemon: widget.pokemonInfo, context: context);
              case "Evolution" :
                return pokemonEvolutionWidget(pokemon: widget.pokemonInfo, context: context);
              case "About" :
              default:
              return pokemonAboutWidget(pokemon: widget.pokemonInfo, context: context);
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


Widget pokemonAboutWidget({required PokemonInfoEntity pokemon, required BuildContext context}){
  final theme = Theme.of(context);

  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16.0,),
        Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Height', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),),
                  const SizedBox(height: 2.0),
                  RichText(text: TextSpan(
                      children: [
                        WidgetSpan(
                            child:  Text('${((pokemon.pokemonHeight ?? 0) / 10)} ', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),)
                        ),
                        WidgetSpan(
                            child:  Text('Meters', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 10.0),)
                        ),
                      ]
                  )),
                ],
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Weight', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),),
                  const SizedBox(height: 2.0),
                  RichText(text: TextSpan(
                      children: [
                        WidgetSpan(
                            child:  Text('${((pokemon.pokemonWeight ?? 0) / 10)} ', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),)
                        ),
                        WidgetSpan(
                            child:  Text('Kg', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 10.0),)
                        ),
                      ]
                  )),
                ],
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Base Experience', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),),
                  const SizedBox(height: 2.0),
                  RichText(text: TextSpan(
                      children: [
                        WidgetSpan(
                            child:  Text('${pokemon.baseExperience} ', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),)
                        ),
                        WidgetSpan(
                            child:  Text('XP', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 10.0),)
                        ),
                      ]
                  )),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0,),
        Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Capture Rate', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),),
                  const SizedBox(height: 2.0),
                  RichText(text: TextSpan(
                      children: [
                        WidgetSpan(
                            child:  Text('${pokemon.captureRate} ', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),)
                        ),
                        WidgetSpan(
                            child:  Text("(${catchDifficultyLabel(captureRate: pokemon.captureRate ?? 0)})", style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),)
                        ),
                      ]
                  )),
                ],
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Base Happiness', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),),
                  const SizedBox(height: 2.0),
                  RichText(text: TextSpan(
                      children: [
                        WidgetSpan(
                            child:  Text('${pokemon.baseHappiness} ', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),)
                        ),
                        WidgetSpan(
                            child:  Text("(${friendshipLabel(baseHappiness: pokemon.baseHappiness ?? 0)})", style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),)
                        ),
                      ]
                  )),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0,),
        Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Growth Rate', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),),
                  const SizedBox(height: 2.0),
                  RichText(text: TextSpan(
                      children: [
                        WidgetSpan(
                            child:  Text('${pokemon.growthRate} ', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),)
                        ),
                        // WidgetSpan(
                        //     child:  Text('Meters', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 10.0),)
                        // ),
                      ]
                  )),
                ],
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Gender', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),),
                  const SizedBox(height: 2.0),
                  genderSplit(genderRate: pokemon.genderSplit) == null ?
                  Text('Genderless', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 10.0),) :
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(text: TextSpan(
                          children: [
                            WidgetSpan(
                                child:  Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.male),
                                    const SizedBox(width: 4.0),
                                    Text('${genderSplit(genderRate: pokemon.genderSplit)?['male']} %', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),),
                                  ],
                                )
                            ),
                            // WidgetSpan(
                            //     child:  Text('Kg', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 10.0),)
                            // ),
                          ]
                      )),
                      const SizedBox(width: 16.0),
                      RichText(text: TextSpan(
                          children: [
                            WidgetSpan(
                                child:  Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.female),
                                    const SizedBox(width: 4.0),
                                    Text('${genderSplit(genderRate: pokemon.genderSplit)?['female']} %', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),),
                                  ],
                                )
                            ),
                            // WidgetSpan(
                            //     child:  Text('Kg', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 10.0),)
                            // ),
                          ]
                      )),
                    ],
                  ),
                ],
              ),
            ),
            // const SizedBox(width: 8.0),
            // Expanded(
            //   flex: 2,
            //   child: Column(
            //     mainAxisSize: MainAxisSize.min,
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const Text('Gender', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),),
            //       const SizedBox(height: 2.0),
            //       RichText(text: TextSpan(
            //           children: [
            //             WidgetSpan(
            //                 child:  Text('${pokemon.baseHappiness} ', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),)
            //             ),
            //             // WidgetSpan(
            //             //     child:  Text('XP', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 10.0),)
            //             // ),
            //           ]
            //       )),
            //     ],
            //   ),
            // ),
          ],
        ),
        const SizedBox(height: 8.0,),
        const Text('Types', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for(PokemonTypesEntity type in (pokemon.types ?? [])) type.pokemonType?.name == null ? const SizedBox.shrink() : Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Chip(label: Text(type.pokemonType?.name?.capitalize() ?? "", style: theme.textTheme.bodySmall,), backgroundColor: theme.primaryColorLight,),
            )
          ],
        ),
        const SizedBox(height: 8.0,),
        const Text('Abilities', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for(AbilitiesEntity ability in (pokemon.abilities ?? [])) ability.ability?.name == null ? const SizedBox.shrink() : Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Chip(label: Text(ability.ability!.name!.capitalize(), style: theme.textTheme.bodySmall,), backgroundColor: theme.primaryColorLight,),
            )
          ],
        ),
        const SizedBox(height: 8.0,),
        const Text('Egg Groups', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for(DataEntity egg in (pokemon.eggGroups ?? [])) egg.name == null ? const SizedBox.shrink() : Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Chip(label: Text(egg.name?.capitalize() ?? "", style: theme.textTheme.bodySmall,), backgroundColor: theme.primaryColorLight,),
            )
          ],
        ),
        disableSlider ? (pokemon.variantsComplete ?? []).isEmpty ? const SizedBox.shrink() : const SizedBox(height: 8.0,) : const SizedBox.shrink(),
        disableSlider ? (pokemon.variantsComplete ?? []).isEmpty ? const SizedBox.shrink() : const Text('Variants', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),) : const SizedBox.shrink(),
        disableSlider ? (pokemon.variantsComplete ?? []).isEmpty ? const SizedBox.shrink() : Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for(PokemonInfoEntity variant in pokemon.variantsComplete ?? []) variant.sprites?.artWork == null ? const SizedBox.shrink() : Expanded(child: pokemonImageCard(image: variant.sprites!.artWork!,type: "Art Work", context: context))
          ],
        ) : const SizedBox.shrink(),
      ],
    ),
  );
}

Widget pokemonStatsWidget({required PokemonInfoEntity pokemon, required BuildContext context}){
  // final theme = Theme.of(context);
  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: ListView.builder(
        itemCount: pokemon.stats!.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
      var stat = pokemon.stats![index];
      return Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 0.0),
        child: pokemonStatWidget(context: context, stat: stat),
      );
    }),
  );
}

Widget pokemonEvolutionWidget({required PokemonInfoEntity pokemon, required BuildContext context}){
  // final theme = Theme.of(context);
  return Column(
    children: [
      Row(
        children: [
          const Text('Height'),
          Text('${pokemon.pokemonHeight}')
        ],
      )
    ],
  );
}

Widget pokemonMovesWidget({required PokemonInfoEntity pokemon, required BuildContext context}){
  // final theme = Theme.of(context);
  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: ListView.builder(
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

Widget pokemonStatWidget({required BuildContext context, required StatsEntity stat}){
final theme = Theme.of(context);
var statValue = stat.baseStat! / 100;
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 30, bottom: 10),
        child: SizedBox(
            width: 80,
            child: Text(stat.stat!.name!.capitalize(), style: TextStyle(
              fontSize: 10, color: theme.textTheme.bodyMedium?.color,
              fontFamily: theme.textTheme.bodyMedium?.fontFamily
            ),)),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 20, bottom: 10),
        child: Text("${stat.baseStat}", style: theme.textTheme.bodySmall,),
      ),
      SizedBox(
          width: 150,
          child: LinearProgressIndicator(backgroundColor: Colors.grey[200], minHeight: 4,
          value: statValue, color: statValue > 0.5 ? Colors.green : Colors.red,)),
    ],
  );
}

Widget pokemonMoveWidget({required BuildContext context, required MovesEntity moves}){
  final theme = Theme.of(context);

  return Card(
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
             Text(moves.move!.name!.capitalize(), style: theme.textTheme.bodySmall,),
  Text("Level 1", style: theme.textTheme.bodyMedium,)
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