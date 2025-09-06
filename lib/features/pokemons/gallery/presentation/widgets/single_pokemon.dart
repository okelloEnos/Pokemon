import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:palette_generator/palette_generator.dart';
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

Widget pokemonImageCardLoading({required BuildContext context, double? height, Color? color}){
  final theme = Theme.of(context);

  return ShimmerWidget(
    baseColor: color?.withOpacity(0.4),
    highlightColor: color?.withOpacity(0.15),
    child: SizedBox(
      height: height ?? 150,
      child: SvgPicture.asset('assets/images/svg-logo.svg'),
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
// https://www.behance.net/gallery/155301139/Daily-UI-Pokdex
//   https://www.behance.net/gallery/158115601/Pokedex-App-Case-Study
static const List<Tab> pokemonsTabs = <Tab>[
  Tab(text: "About"),
  Tab(text: "Stats",), // https://dribbble.com/shots/25682407-App-UI-Mobile-Game-Statistics-Character-Statistics
  Tab(text: "Evolution",), // https://dribbble.com/shots/14184018-Pok-dex-App-V-2
  Tab(text: "Moves",)
];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context.read<PokemonMoveBloc>().add(FetchMovesDetailsEvent(moves: widget.pokemonInfo.moves ?? []));
    context.read<PokemonEvolutionBloc>().add(FetchEvolutionChainEvent(
        evolvesFrom: widget.pokemonInfo.evolvesFrom,
        evolutionChain: widget.pokemonInfo.evolutionChain
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TabBar(
              // indicatorPadding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
              indicatorColor: widget.pokemonInfo.color,
              indicatorWeight: 2.0,
              controller: _tabController,
              labelColor: widget.pokemonInfo.color,
              unselectedLabelColor: Colors.grey.shade400,
              dividerColor: Colors.grey.shade100,
              splashFactory: NoSplash.splashFactory,
              // dividerHeight: 0,
              tabs: pokemonsTabs
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: pokemonsTabs.map((Tab tab){
                switch(tab.text){
                  case "Moves":
                    // context.read<PokemonMoveBloc>().add(FetchMovesDetailsEvent(moves: widget.pokemonInfo.moves ?? []));
                    return pokemonMovesWidget(pokemon: widget.pokemonInfo, context: context);
                  case "Stats":
                    return pokemonStatsWidget(pokemon: widget.pokemonInfo, context: context);
                  case "Evolution" :
                    // context.read<PokemonEvolutionBloc>().add(FetchEvolutionChainEvent(
                    //     evolvesFrom: widget.pokemonInfo.evolvesFrom,
                    //     evolutionChain: widget.pokemonInfo.evolutionChain
                    // ));
                    return pokemonEvolutionWidget(pokemon: widget.pokemonInfo, context: context);
                  case "About" :
                  default:
                    return pokemonAboutWidget(pokemon: widget.pokemonInfo, context: context);
                }
              }).toList(),
            ),
          ),
        ],
      ),
    );

    // return Padding(
    //   padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0, top: 10.0),
    //   child: Scaffold(
    //     backgroundColor: Colors.white,
    //     appBar: TabBar(
    //         indicatorPadding: const EdgeInsets.only(left: 10, right: 10, bottom: 0),
    //         indicatorColor: widget.pokemonInfo.color,
    //         indicatorWeight: 5,
    //         controller: _tabController,
    //         tabs: pokemonsTabs
    //     ),
    //     body: TabBarView(
    //       physics: const NeverScrollableScrollPhysics(),
    //       controller: _tabController,
    //       children: pokemonsTabs.map((Tab tab){
    //         switch(tab.text){
    //           case "Moves":
    //             context.read<PokemonMoveBloc>().add(FetchMovesDetailsEvent(moves: widget.pokemonInfo.moves ?? []));
    //             return pokemonMovesWidget(pokemon: widget.pokemonInfo, context: context);
    //           case "Stats":
    //             return pokemonStatsWidget(pokemon: widget.pokemonInfo, context: context);
    //           case "Evolution" :
    //             context.read<PokemonEvolutionBloc>().add(FetchEvolutionChainEvent(
    //                 evolvesFrom: widget.pokemonInfo.evolvesFrom,
    //                 evolutionChain: widget.pokemonInfo.evolutionChain
    //             ));
    //             return pokemonEvolutionWidget(pokemon: widget.pokemonInfo, context: context);
    //           case "About" :
    //           default:
    //             return pokemonAboutWidget(pokemon: widget.pokemonInfo, context: context);
    //         }
    //       }).toList(),
    //     ),
    //   ),
    // );
  }

@override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}


Widget pokemonAboutWidget({required PokemonInfoEntity pokemon, required BuildContext context}){
  final theme = Theme.of(context);

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: SingleChildScrollView(
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
                              child:  Text('${((pokemon.pokemonHeight ?? 0) / 10)} ', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 14.0),)
                          ),
                          WidgetSpan(
                              child:  Text('Meters', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 12.0),)
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
                              child:  Text('${((pokemon.pokemonWeight ?? 0) / 10)} ', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 14.0),)
                          ),
                          WidgetSpan(
                              child:  Text('Kg', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 12.0),)
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
                              child:  Text('${pokemon.baseExperience} ', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 14.0),)
                          ),
                          WidgetSpan(
                              child:  Text('XP', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 12.0),)
                          ),
                        ]
                    )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0,),
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
                              child:  Text('${pokemon.captureRate ?? 0} ', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 14.0),)
                          ),
                          WidgetSpan(
                              child:  Text("(${catchDifficultyLabel(captureRate: pokemon.captureRate ?? 0)})", style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 12.0),)
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
                              child:  Text('${pokemon.baseHappiness ?? 0} ', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 14.0),)
                          ),
                          WidgetSpan(
                              child:  Text("(${friendshipLabel(baseHappiness: pokemon.baseHappiness ?? 0)})", style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 12.0),)
                          ),
                        ]
                    )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0,),
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
                              child:  Text('${pokemon.growthRate?.capitalizeFirstOfEach() ?? " << Rate >>"} ', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 14.0),)
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
                    Text('Genderless', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 14.0),) :
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
                                      Text('${genderSplit(genderRate: pokemon.genderSplit)?['male']} %', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 14.0),),
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
                                      Text('${genderSplit(genderRate: pokemon.genderSplit)?['female']} %', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 14.0),),
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
          const SizedBox(height: 12.0,),
          const Text('Types', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for(PokemonTypesEntity type in (pokemon.types ?? [])) type.pokemonType?.name == null ? const SizedBox.shrink() : Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Chip(label: Text(type.pokemonType?.name?.capitalize() ?? "", style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 12.0),), backgroundColor: theme.primaryColorLight,),
              )
            ],
          ),
          const SizedBox(height: 12.0,),
          const Text('Abilities', style: TextStyle(fontSize: 12.0),),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for(AbilitiesEntity ability in (pokemon.abilities ?? [])) ability.ability?.name == null ? const SizedBox.shrink() : Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Chip(label: Text(ability.ability!.name!.capitalize(), style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 12.0),), backgroundColor: theme.primaryColorLight,),
              )
            ],
          ),
          (pokemon.eggGroups ?? []).isEmpty ? const SizedBox.shrink() : const SizedBox(height: 12.0,),
          (pokemon.eggGroups ?? []).isEmpty ? const SizedBox.shrink() : const Text('Egg Groups', style: TextStyle(fontSize: 12.0),),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for(DataEntity egg in (pokemon.eggGroups ?? [])) egg.name == null ? const SizedBox.shrink() : Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Chip(label: Text(egg.name?.capitalize() ?? "", style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 12.0),), backgroundColor: theme.primaryColorLight,),
              )
            ],
          ),
          disableSlider ? (pokemon.variantsComplete ?? []).isEmpty ? const SizedBox.shrink() : const SizedBox(height: 12.0,) : const SizedBox.shrink(),
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
    ),
  );
}

Widget pokemonStatsWidget({required PokemonInfoEntity pokemon, required BuildContext context}){
  // final theme = Theme.of(context);
  return Padding(
    padding: const EdgeInsets.only(top: 12, right: 8.0, left: 8.0),
    child: ListView.builder(
      padding: EdgeInsets.zero,
        itemCount: pokemon.stats!.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
      var stat = pokemon.stats![index];
      return Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 0.0),
        child: pokemonStatWidget(context: context, stat: stat, color: pokemon.color),
      );
    }),
  );
}

Widget pokemonEvolutionWidget({required PokemonInfoEntity pokemon, required BuildContext context}){
  final theme = Theme.of(context);
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: BlocBuilder<PokemonEvolutionBloc, PokemonEvolutionState>(
    builder: (context, state) {
      if(state is PokemonEvolutionLoaded){
        List<EvolutionPokemonEntity> evolutionChain = state.evolution;
        return Padding(
          padding: const EdgeInsets.only(top: 10, right: 8.0, left: 8.0, bottom: 16.0),
          child:
          evolutionChain.isEmpty ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/images/pokeball.svg", color: Colors.grey.shade100, height: 100.0, width: 100.0,),
              const SizedBox(height: 32.0),
              Text("${pokemon.pokemonName?.capitalizeFirstOfEach()} evolution is missing.", textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey, fontSize: 16.0)),
            ],
          ) :
          ListView.separated(
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Icon(Icons.arrow_circle_down, size: 40.0, color: pokemon.color?.withOpacity(0.25),)),
              ),
              padding: EdgeInsets.zero,
              itemCount: evolutionChain.length,
              shrinkWrap: true,
              itemBuilder: (context, index){
                EvolutionPokemonEntity evolution = evolutionChain[index];
                return pokemonImageCard(image: evolution.imageUrl!, type: "Art Work", context: context);
              }),
        );
      }
      else if (state is PokemonEvolutionError){
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: CreatureCodexErrorWidget(
            message: state.message,
            fontSize: 12.0,
            minimumBtnSize: const Size(80, 38.0),
            onRetry: (){
              context.read<PokemonEvolutionBloc>().add(FetchEvolutionChainEvent(
                  evolvesFrom: pokemon.evolvesFrom,
                  evolutionChain: pokemon.evolutionChain
              ));
            },
            size: 150.0,
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.only(top: 10, right: 8.0, left: 8.0, bottom: 16.0),
        child: ListView.separated(
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: ShimmerWidget(
                  baseColor: pokemon.color?.withOpacity(0.4),
                  highlightColor: pokemon.color?.withOpacity(0.15),
                  child: Icon(Icons.arrow_circle_down, size: 40.0, color: pokemon.color?.withOpacity(0.25),))),
            ),
            padding: EdgeInsets.zero,
            itemCount: 6,
            shrinkWrap: true,
            itemBuilder: (context, index){
              return pokemonImageCardLoading(context: context, color: pokemon.color, height: 150.0);
            }),
      );
    },
    ),
  );
}

Widget pokemonMovesWidget({required PokemonInfoEntity pokemon, required BuildContext context}){
  final theme = Theme.of(context);
  return BlocBuilder<PokemonMoveBloc, PokemonMoveState>(
  builder: (context, state) {
    if(state is PokemonMoveLoaded){
      List<MovesEntity> moves = state.moves;
      return Padding(
        padding: const EdgeInsets.only(top: 10, right: 8.0, left: 8.0, bottom: 16.0),
        child:
        moves.isEmpty ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/images/pokeball.svg", color: Colors.grey.shade100, height: 100.0, width: 100.0,),
            const SizedBox(height: 32.0),
            Text("${pokemon.pokemonName?.capitalizeFirstOfEach()} moves is missing.", textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey, fontSize: 16.0)),
          ],
        ) :
        ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 2.0),
          padding: EdgeInsets.zero,
            itemCount: moves.length,
            shrinkWrap: true,
            itemBuilder: (context, index){
              MovesEntity move = moves[index];
              return Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 0.0, right: 0.0, bottom: 0.0),
                child: pokemonMoveWidget(context: context, moves: move, color: pokemon.color),
              );
            }),
      );
    }
    else if (state is PokemonMoveError){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: CreatureCodexErrorWidget(
          message: state.message,
          fontSize: 12.0,
          minimumBtnSize: const Size(80, 38.0),
          onRetry: (){
            context.read<PokemonMoveBloc>().add(FetchMovesDetailsEvent(moves: pokemon.moves ?? []));
          },
          size: 150.0,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 8.0, left: 8.0, bottom: 16.0),
      child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 2.0),
          padding: EdgeInsets.zero,
          itemCount: 6,
          shrinkWrap: true,
          itemBuilder: (context, index){
            return Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 0.0, right: 0.0, bottom: 0.0),
              child: pokemonMoveWidgetLoading(context: context, color: pokemon.color),
            );
          }),
    );
  },
);
}

Widget pokemonStatWidget({required BuildContext context, required StatsEntity stat, required Color? color}){
final theme = Theme.of(context);
var statValue = (stat.baseStat ?? 0) / 100;
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: Row(
      children: [
        Expanded(
          flex: 3,
          child: Text("${statsEmonji(statName: stat.stat?.name ?? "")} ${stat.stat?.name?.capitalizeFirstOfEach() ?? ""}", style: TextStyle(
            fontSize: 12.0, color: theme.textTheme.bodyMedium?.color,
            fontFamily: theme.textTheme.bodyMedium?.fontFamily,
            fontWeight: FontWeight.bold
          ),),
        ),
        const SizedBox(width: 16.0,),
        Expanded(
          flex: 4,
          child: LinearProgressIndicator(backgroundColor: Colors.grey.shade200, minHeight: 6.0,
          borderRadius: BorderRadius.circular(4.0),
          value: statValue,
            color: color,
            // color: statValue > 0.5 ? Colors.green : Colors.red,
          ),
        ),
      ],
    ),
  );
}

Widget pokemonMoveWidget({required BuildContext context, required MovesEntity moves, required Color? color}){
  final theme = Theme.of(context);

  return Card(
    color: color?.withOpacity(0.25),
    margin: EdgeInsets.zero,
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(moves.move?.name?.capitalizeFirstOfEach() ?? "", style: theme.textTheme.labelLarge?.copyWith(
                 fontWeight: FontWeight.bold, fontSize: 18.0
              ),),
              const SizedBox(width: 4.0,),
              Chip(
                label: Text(moves.type?.name?.capitalize() ?? "",
                  style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 12.0),),
                backgroundColor: color,
              padding: EdgeInsets.zero,
                side: BorderSide.none,
                labelPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0)
              ),
            ],
          ),
           const SizedBox(height: 4.0,),
        Row(
          children: [
            Expanded(
              child: Column(
       mainAxisSize: MainAxisSize.min,
       crossAxisAlignment: CrossAxisAlignment.start,
       mainAxisAlignment: MainAxisAlignment.start,
       children: [
         Text("Power", style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14.0, color: Color(pokemonColorValues.secondaryColor)),),
         Text("${moves.power ?? 0}", style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16.0, fontWeight: FontWeight.bold),),
       ],
              ),
            ),
            Expanded(
              child: Column(
       mainAxisSize: MainAxisSize.min,
       crossAxisAlignment: CrossAxisAlignment.start,
       mainAxisAlignment: MainAxisAlignment.start,
       children: [
         Text("Accuracy", style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14.0, color: Color(pokemonColorValues.secondaryColor)),),
         Text("${moves.accuracy ?? 0}", style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16.0, fontWeight: FontWeight.bold),),
       ],
              ),
            ),
            Expanded(
              child: Column(
       mainAxisSize: MainAxisSize.min,
       crossAxisAlignment: CrossAxisAlignment.start,
       mainAxisAlignment: MainAxisAlignment.start,
       children: [
         Text("PP", style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14.0, color: Color(pokemonColorValues.secondaryColor)),),
         Text("${moves.pp ?? 0}", style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16.0, fontWeight: FontWeight.bold),),
       ],
              ),
            ),
          ],
        )
              ],),
    ),
  );

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

Widget pokemonMoveWidgetLoading({required BuildContext context, required Color? color}){
  final theme = Theme.of(context);

  return ShimmerWidget(
    baseColor: color?.withOpacity(0.4),
    highlightColor: color?.withOpacity(0.15),
    child: Card(
      color: color?.withOpacity(0.25),
      margin: EdgeInsets.zero,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShimmerContainer(
                    baseColor: color?.withOpacity(0.8),
                    highlightColor: color?.withOpacity(0.15),
                    width: 120.0, height: 16.0, borderRadius: 4.0,),
                const SizedBox(width: 8.0,),
                ShimmerContainer(
                    baseColor: color?.withOpacity(0.8),
                    highlightColor: color?.withOpacity(0.15),
                    width: 100.0, height: 28.0, borderRadius: 8.0,),
              ],
            ),
            const SizedBox(height: 8.0,),
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ShimmerContainer(
                        baseColor: color?.withOpacity(0.8),
                        highlightColor: color?.withOpacity(0.15),
                        width: 80.0, height: 16.0, borderRadius: 4.0,),
                      const SizedBox(height: 4.0,),
                      ShimmerContainer(
                        baseColor: color?.withOpacity(0.8),
                        highlightColor: color?.withOpacity(0.15),
                        width: 40.0, height: 16.0, borderRadius: 4.0,),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ShimmerContainer(
                        baseColor: color?.withOpacity(0.8),
                        highlightColor: color?.withOpacity(0.15),
                        width: 80.0, height: 16.0, borderRadius: 4.0,),
                      const SizedBox(height: 4.0,),
                      ShimmerContainer(
                        baseColor: color?.withOpacity(0.8),
                        highlightColor: color?.withOpacity(0.15),
                        width: 40.0, height: 16.0, borderRadius: 4.0,),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ShimmerContainer(
                        baseColor: color?.withOpacity(0.8),
                        highlightColor: color?.withOpacity(0.15),
                        width: 80.0, height: 16.0, borderRadius: 4.0,),
                      const SizedBox(height: 4.0,),
                      ShimmerContainer(
                        baseColor: color?.withOpacity(0.8),
                        highlightColor: color?.withOpacity(0.15),
                        width: 40.0, height: 16.0, borderRadius: 4.0,),
                    ],
                  ),
                ),
              ],
            )
          ],),
      ),
    ),
  );

  // return Card(
  //   color: Colors.white,
  //   margin: EdgeInsets.zero,
  //   elevation: 0,
  //   child: Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 5),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(moves.move!.name!.capitalize(), style: theme.textTheme.bodySmall,),
  //             Text("Level 1", style: theme.textTheme.bodyMedium,)
  //           ],),
  //         CircularProgressIndicator(
  //           value: 0.6,
  //           backgroundColor: Colors.grey[200],
  //           color: Colors.green,
  //         )
  //       ],
  //     ),
  //   ),
  // );
}

String statsEmonji({required String statName}){
  switch(statName.toLowerCase()){
    case "hp":
      return "❤️";
    case "attack":
      return "⚔️";
    case "defense":
      return "🛡️";
    case "special-attack":
      return "💥";
    case "special-defense":
      return "🔰";
    case "speed":
      return "💨";
    default:
      return "❓";
  }
}