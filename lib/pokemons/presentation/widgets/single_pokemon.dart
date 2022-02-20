import 'package:beamer/beamer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pokemon/pokemons/data/models/pokemon_model_util.dart';
import 'package:pokemon/util/app_colors.dart';
import 'package:pokemon/util/global_widgets.dart';

Widget singlePokemonWidget({required PokemonInfo pokemon, required BuildContext context}){

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
                  IconButton(
                      color: theme.primaryColorDark,
                      onPressed: () => Beamer.of(context).beamBack(), icon: const Icon(CupertinoIcons.back)),
                  const SizedBox(width: 50,),
                  Center(
                    child: Text(pokemon.pokemonName!, style: theme.textTheme.headline5
                    // TextStyle(color: theme.primaryColorDark,
                    //     fontWeight: FontWeight.bold, fontSize: 22),
                    ),
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
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const Text("Weight", style: TextStyle(fontFamily: 'Messiri'),),
                Text("${pokemon.pokemonWeight} KG")
              ],
            ),
            Column(
              children: [
                const Text("Base Experience"),
                Text("${pokemon.baseExperience}")
              ],
            ),
            Column(
              children: [
                const Text("Height"),
                Text("${pokemon.pokemonHeight} Meters")
              ],
            ),

          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text("Abilities"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                [
                  for(var ability in pokemon.abilities!) ... [
                    Text("${ability.ability!.name} , Hidden : ${ability.isHidden}   ")
                  ]
                ]

            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text("Moves"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children:
                  [
                    for(var move in pokemon.moves!) ... [
                      Text("${move.move!.name} ,    ")
                    ]
                  ]

              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text("Stats"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children:
                  [
                    for(var stat in pokemon.stats!) ... [
                      Text("Stat Name: ${stat.stat!.name} , Base Stat : ${stat.baseStat}, Effort : ${stat.effort} \n")
                    ]
                  ]

              ),
            )
          ],
        ),
      ),
      // const LogoAnimation()
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
          child: Text(type, style: TextStyle(fontFamily: 'Lemonada', fontSize: 20, fontWeight: FontWeight.bold, color: theme.primaryColorDark),),
        )
      ],
    ),
  );
}

class LogoAnimation extends StatefulWidget {
  const LogoAnimation({Key? key}) : super(key: key);

  @override
  _LogoAnimationState createState() => _LogoAnimationState();
}

class _LogoAnimationState extends State<LogoAnimation>  with SingleTickerProviderStateMixin{
late Animation<double> animation;
late AnimationController controller;
@override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    // animation = Tween<double>(begin: 0, end: 300).animate(controller)..addListener(() {
    //   setState(() {
    //
    //   });
    // });

    animation = Tween<double>(begin: 0, end: 300).animate(controller);
    //   ..addStatusListener((status) {
    //   if(status == AnimationStatus.completed){
    //     controller.reverse();
    //   }
    //   else if(status == AnimationStatus.dismissed){
    //     controller.forward();
    //   }
    // })..addStatusListener((status) => print(status));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GrowTransition(animation: animation, child: const LogoWidget(),);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class AnimatedLogo extends AnimatedWidget {
  const AnimatedLogo({Key? key, required Animation<double> animation}) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return SizedBox(
      height: animation.value,
      width: animation.value,
      child: const FlutterLogo(),
    );
  }
}

class LogoWidget extends StatelessWidget {
  const LogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  const SizedBox(child: FlutterLogo());
  }
}

class GrowTransition extends StatelessWidget {
  const GrowTransition({Key? key, required this.child, required this.animation}) : super(key: key);
  final Widget child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Center(child: AnimatedBuilder(
        animation: animation,
        builder: (context, child){
          return SizedBox(
            height: animation.value,
            width: animation.value,
            child: child,
          );
        },
    child: child,));
  }
}

