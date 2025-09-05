import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

          }),
    );
  }
}
Widget allPokemonsLoading(){
  return BlocBuilder<GalleryViewCubit, ViewType>(
  builder: (context, state) {
    return state == ViewType.grid ? GridView.builder(
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

      }) : GridView.builder(
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
  },
);
}
Widget allPokemonsView({required var bloc, required var state, required var context}){
  return CustomScrollView(
    controller: bloc.scrollController,
    slivers: [
      BlocBuilder<GalleryViewCubit, ViewType>(
  builder: (context, viewState) {
    return
      viewState == ViewType.grid ?
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
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 4 / 3, // w/h
        ),
      )
          :
      SliverList(delegate: SliverChildBuilderDelegate((context, index) {
      return SizedBox(
        height: 155,
        child: AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 800),
          // columnCount: 2,
          child: ScaleAnimation(
            child: FadeInAnimation(
              child: pokemonListCard(context, state.pokemons[index]),
            ),
          ),
        ),
      );
    }, childCount: state.pokemons.length));
  },
),
      SliverToBoxAdapter(child: pokemonCardLoading(context)),
  SliverToBoxAdapter(child: pokemonListCardLoading(context)),

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
        margin: EdgeInsets.zero,
        color: pokemon.color,
        elevation: 4.0,
        key: const Key("grid_card"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: -20,
              right: -20,
              child: Transform.rotate(
                  angle: 2.2,
                  child: SvgPicture.asset("assets/images/pokeball.svg",
                    height: 90.0, width: 90.0,
                    color: Colors.white10,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0, bottom: 0.0),
              child: Column(
                key: const Key("grid_column"),
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    pokemon.pokemonName?.capitalize() ?? "",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14.0),
                    key: const Key("grid_text_name"),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for(PokemonTypesEntity type in (pokemon.types ?? [])) type.pokemonType?.name == null ? const SizedBox.shrink() : Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Container(
                              padding: const EdgeInsets.only(
                                top: 2.0,
                                bottom: 2.0,
                                left: 8.0,
                                right: 8.0,
                              ),
                                decoration: BoxDecoration(
                                    color: Colors.white24,
                                    borderRadius: BorderRadius.circular(4.0)
                                ),
                                child: Text(type.pokemonType?.name?.capitalize() ?? "", style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 12.0, color: Colors.white),)),
                          )
                        ],
                      ),
                      CachedNetworkImage(
                        height: 90,
                        width: 90,
                        key: const Key("grid_image"),
                        imageUrl: pokemon.sprites?.artWork ?? "",
                      errorWidget: (_, __, ___){
                        return imageErrorWidget(size: 90);
                      },
                        placeholder: (_, __){
                        return imagePlaceHolder(color: theme.primaryColorDark, size: 90);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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

Widget pokemonListCard(BuildContext context, PokemonInfoEntity pokemon){
  final theme = Theme.of(context);
  return Hero(
    key: const Key("grid_hero"),
    tag: "pok${pokemon.pokemonName}",
    child: GestureDetector(
      onTap: () {
        context.push("/gallery/creature", extra: pokemon);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16.0),
        color: pokemon.color,
        elevation: 4.0,
        key: const Key("grid_card"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: -20,
              right: -20,
              child: Transform.rotate(
                  angle: 2.2,
                  child: SvgPicture.asset("assets/images/pokeball.svg",
                    height: 100.0, width: 100.0,
                    color: Colors.white10,
                  )),
            ),
            Positioned(
              bottom: -20,
              left: -10,
              child: Transform.rotate(
                  angle: 0.8,
                  child: SvgPicture.asset("assets/images/pokeball.svg",
                    height: 100.0, width: 100.0,
                    color: Colors.white10,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0, bottom: 0.0),
              child: Column(
                key: const Key("grid_column"),
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    pokemon.pokemonName?.capitalize() ?? "",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16.0),
                    key: const Key("grid_text_name"),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for(PokemonTypesEntity type in (pokemon.types ?? [])) type.pokemonType?.name == null ? const SizedBox.shrink() : Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                  padding: const EdgeInsets.only(
                                    top: 2.0,
                                    bottom: 2.0,
                                    left: 8.0,
                                    right: 8.0,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white24,
                                      borderRadius: BorderRadius.circular(4.0)
                                  ),
                                  child: Text(type.pokemonType?.name?.capitalize() ?? "", style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 12.0, color: Colors.white),)),
                            )
                          ],
                        ),
                      ),
                      CachedNetworkImage(
                        height: 100.0,
                        width: 100.0,
                        key: const Key("grid_image"),
                        imageUrl: pokemon.sprites?.artWork ?? "",
                        errorWidget: (_, __, ___){
                          return imageErrorWidget(size: 100.0);
                        },
                        placeholder: (_, __){
                          return imagePlaceHolder(color: theme.primaryColorDark, size: 100.0);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget pokemonListCardLoading(BuildContext context){

  return Card(
    key: const Key("list_card_shimmer"),
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
