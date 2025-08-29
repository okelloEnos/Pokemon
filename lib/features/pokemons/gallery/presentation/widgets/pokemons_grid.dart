import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/core_barrel.dart';
import '../../../../features_barrel.dart';

class AllPokemonsGridLoading extends StatelessWidget {
  const AllPokemonsGridLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GridView.builder(
          physics: ClampingScrollPhysics(),
          key: const Key("pokemon_grid"),
          itemCount: 8,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2/2.5
          ),
          itemBuilder: (BuildContext context, int index){
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 800),
              columnCount: 2,
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: pokemonCardLoading(context),
                ),
              ),
            );

          }),
    );
  }
}
Widget allPokemonsLoading(){
  return GridView.builder(
      physics: const ClampingScrollPhysics(),
      key: const Key("pokemon_grid"),
      itemCount: 8,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2/2.5
      ),
      itemBuilder: (BuildContext context, int index){
        return AnimationConfiguration.staggeredGrid(
          position: index,
          duration: const Duration(milliseconds: 800),
          columnCount: 2,
          child: ScaleAnimation(
            child: FadeInAnimation(
              child: pokemonCardLoading(context),
            ),
          ),
        );

      });
}
Widget allPokemonsView({required var bloc, required var state, required var context}){
  return CustomScrollView(
    controller: bloc.scrollController,
    slivers: [
      SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 800),
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: pokemonCard(context, state.pokemons[index]),
              ),
            ),
          );
        }, childCount: state.pokemons.length),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2 / 2.5,
        ),
      ),

      // if (state.hasReachedMax != true)
      //   SliverToBoxAdapter(
      //     child: Center(
      //       child: Padding(
      //         padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
      //         child: SpinKitRipple(
      //           key: const Key("pokemon_loading"),
      //           color: Theme.of(context).primaryColorDark,
      //           size: 60.0,
      //         ),
      //       ),
      //     ),
      //   ),

      // if (_hasReachedMax)
      //   SliverToBoxAdapter(
      //     child: Padding(
      //       padding: const EdgeInsets.only(bottom: 16.0),
      //       child: EndOfListBanner(
      //         key: ValueKey(_endTick),
      //         message: "You’ve reached the end ✨",
      //       ),
      //     ),
      //   ),
      ///
      const SliverToBoxAdapter(child: SizedBox(height: 16.0,),)
    ],
  );
}


class AllPokemonsGrid extends StatefulWidget {
  final PokemonsLoaded state;
  const AllPokemonsGrid({required this.state, Key? key}) : super(key: key);

  @override
  State<AllPokemonsGrid> createState() => _AllPokemonsGridState();
}

class _AllPokemonsGridState extends State<AllPokemonsGrid> {

  int _endTick = 0;

  bool get _hasReachedMax => widget.state.hasReachedMax == true;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PokemonsBloc>();
    return RefreshIndicator(
      onRefresh: () async {
        bloc.add(PokemonsFetched());
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          final atBottom = n.metrics.pixels >= n.metrics.maxScrollExtent &&
              n.metrics.atEdge;

          if (atBottom && _hasReachedMax) {
            setState(() => _endTick++);
          }
          return false;
        },
        child: CustomScrollView(
          controller: bloc.scrollController,
          slivers: [
            SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 800),
                  columnCount: 2,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: pokemonCard(context, widget.state.pokemons[index]),
                    ),
                  ),
                );
              }, childCount: widget.state.pokemons.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2 / 2.5,
              ),
            ),

            if (widget.state.hasReachedMax != true)
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                    child: SpinKitRipple(
                      key: const Key("pokemon_loading"),
                      color: Theme.of(context).primaryColorDark,
                      size: 60.0,
                    ),
                  ),
                ),
              ),

            if (_hasReachedMax)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: EndOfListBanner(
                    key: ValueKey(_endTick),
                    message: "You’ve reached the end ✨",
                  ),
                ),
              ),
            ///
            const SliverToBoxAdapter(child: SizedBox(height: 16.0,),)
          ],
        ),
      ),
    );

  }
}

Widget pokemonCard(BuildContext context, PokemonInfoEntity pokemon){
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
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8.0,),
              CachedNetworkImage(
                height: 120,
                width: 120,
                key: const Key("grid_image"),
                imageUrl: pokemon.sprites?.artWork ?? "",
              errorWidget: (_, __, ___){
                return imageErrorWidget(size: 120);
              },
                placeholder: (_, __){
                return imagePlaceHolder(color: theme.primaryColorDark, size: 120);
                },
              ),
              const SizedBox(height: 8.0,),
              Padding(
                key: const Key("grid_pad"),
                padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
                child: Text(
                  pokemon.pokemonName?.capitalize() ?? "",
                  maxLines: 2,
                  textAlign: TextAlign.center,
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

Widget pokemonCardLoading(BuildContext context){

  return Card(
    key: const Key("grid_card_shimmer"),
    child: Column(
      key: const Key("grid_column_shimmer"),
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8.0,),
        ShimmerContainer(width: 120, height: 120, baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100,),
        const SizedBox(height: 8.0,),
        Padding(
          key: const Key("grid_pad_shimmer"),
          padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
          child: ShimmerContainer(width: 120, height: 12, baseColor: Colors.grey.shade300, highlightColor: Colors.grey.shade100 ),
        ),
      ],
    ),
  );
}
