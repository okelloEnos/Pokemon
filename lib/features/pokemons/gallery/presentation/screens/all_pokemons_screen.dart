import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../../core/core_barrel.dart';
import '../../../../features_barrel.dart';

class AllPokemonsScreen extends StatefulWidget {
  const AllPokemonsScreen({Key? key}) : super(key: key);

  @override
  State<AllPokemonsScreen> createState() => _AllPokemonsScreenState();
}

class _AllPokemonsScreenState extends State<AllPokemonsScreen> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Text(
    //           'Creature Gallery',
    //           style: theme.textTheme.titleLarge,
    //         ),
    //         const SizedBox(width: 8.0),
    //         BlocBuilder<GalleryViewCubit, ViewType>(
    //             builder: (context, state) {
    //               return Container(
    //                 height: 38.0,
    //                 width: 80.0,
    //                 decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(8.0),
    //                     border: Border.all(
    //                       color:Color(pokemonColorValues.secondaryColor).withOpacity(0.2),
    //
    //                     )
    //                 ),
    //                 child: Row(
    //                   children: [
    //                     Expanded(
    //                       child: GestureDetector(
    //                           onTap: () {
    //                             context
    //                                 .read<GalleryViewCubit>()
    //                                 .toggleView(ViewType.grid);
    //                           },
    //                           child: Container(
    //                             height: double.infinity,
    //                             decoration: BoxDecoration(
    //                               color: state == ViewType.grid ?
    //                               Color(pokemonColorValues.secondaryColor).withOpacity(0.1) : Colors.transparent,
    //                               borderRadius: const BorderRadius.only(topLeft: Radius.circular(7.2), bottomLeft: Radius.circular(7.2)),
    //                             ),
    //                             child: Stack(
    //                               children: [
    //                                 Positioned(
    //                                   top: 0,
    //                                   bottom: 0,
    //                                   left: 0,
    //                                   right: 0,
    //                                   child: Icon(Icons.grid_view_outlined, size: 24.0,
    //                                       color: state == ViewType.grid ? Color(pokemonColorValues.secondaryColor) : Color(pokemonColorValues.secondaryColor).withOpacity(0.4)),
    //                                 ),
    //                                 Positioned(
    //                                     top: -20.0,
    //                                     bottom: 0,
    //                                     // left: 0,
    //                                     right: 2.0,
    //                                     child: state == ViewType.grid ? Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Color(pokemonColorValues.secondaryColor), size: 14,) : const SizedBox.shrink())
    //                               ],
    //                             ),
    //                           )),
    //                     ),
    //                     Container(
    //                       width: 1.0,
    //                       height: double.infinity,
    //                       color: Color(pokemonColorValues.secondaryColor).withOpacity(0.2),
    //                     ),
    //                     Expanded(
    //                       child: GestureDetector(
    //                           onTap: () {
    //                             context
    //                                 .read<GalleryViewCubit>()
    //                                 .toggleView(ViewType.list);
    //                           },
    //                           child: Container(
    //                             height: double.infinity,
    //                             decoration: BoxDecoration(
    //                               color: state == ViewType.list ?
    //                               Color(pokemonColorValues.secondaryColor).withOpacity(0.1) : Colors.transparent,
    //                               borderRadius: const BorderRadius.only(topRight: Radius.circular(7.2), bottomRight: Radius.circular(7.2)),
    //                             ),
    //                             child: Stack(
    //                               children: [
    //                                 Positioned(
    //                                   top: 0,
    //                                   bottom: 0,
    //                                   left: 0,
    //                                   right: 0,
    //                                   child: Icon(
    //                                     Icons.list,
    //                                     color: state == ViewType.list ? Color(pokemonColorValues.secondaryColor) : Color(pokemonColorValues.secondaryColor).withOpacity(0.4),
    //                                     size: 28.0,
    //                                   ),
    //                                 ),
    //                                 Positioned(
    //                                     top: -20.0,
    //                                     bottom: 0,
    //                                     // left: 0,
    //                                     right: 2.0,
    //                                     child: state == ViewType.list ? Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Color(pokemonColorValues.secondaryColor), size: 14,) : const SizedBox.shrink())
    //                               ],
    //                             ),
    //                           )),
    //                     )
    //                   ],
    //                 ),
    //               );
    //             }),
    //       ],
    //     ),
    //   ),
    //   body: Padding(
    //     padding: const EdgeInsets.only(left: 16.0, right: 16.0),
    //     child: BlocBuilder<PokemonsBloc, PokemonStates>(
    //       builder: (context, state) {
    //         return state is PokemonsLoaded
    //             ?
    //         AllPokemonsGrid2(pokemons: state.pokemons)
    //         // allPokemonsView(
    //         //     bloc: context.read<PokemonsBloc>(),
    //         //     state: state,
    //         //     context: context)
    //             : state is PokemonsFailure
    //             ? CreatureCodexErrorWidget(message: state.errorText,)
    //             : allPokemonsLoading();
    //         return SmartRefresher(
    //           controller: context.read<PokemonsBloc>().refreshController,
    //           enablePullUp: true,
    //           header: const WaterDropHeader(),
    //           footer: const MoreFooter(),
    //           // onRefresh: () async {
    //           //   // context.read<PokemonsBloc>().add(PokemonsFetched(offset: 0, limit: 10));
    //           // },
    //           // onLoading: () async {
    //           //   // context.read<PokemonsBloc>().add(PokemonsFetched());
    //           // },
    //           child: state is PokemonsLoaded
    //               ? allPokemonsView(
    //               bloc: context.read<PokemonsBloc>(),
    //               state: state,
    //               context: context)
    //               : state is PokemonsFailure
    //               ? CreatureCodexErrorWidget(message: state.errorText,)
    //               : allPokemonsLoading(),
    //         );
    //       },
    //       // listener: (context, state) {
    //       //   if (state is PokemonsFailure) {
    //       //     // _refreshController.refreshFailed();
    //       //     // _refreshController.loadFailed();
    //       //   }
    //       //   else
    //       //   if(state is PokemonsLoaded){
    //       //     // _refreshController.loadComplete();
    //       //     // _refreshController.refreshCompleted();
    //       //     // if(state.hasReachedMax ?? false){
    //       //     //   _refreshController.loadNoData();
    //       //     // }
    //       //   }
    //       // },
    //     ),
    //   ),
    // );
    return RefreshConfiguration.copyAncestor(
      enableLoadingWhenFailed: true,
      context: context,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Creature Gallery',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(width: 8.0),
              BlocBuilder<GalleryViewCubit, ViewType>(
                  builder: (context, state) {
                return Container(
                  height: 38.0,
                  width: 80.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color:Color(pokemonColorValues.secondaryColor).withOpacity(0.2),

                    )
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                            onTap: () {
                              context
                                  .read<GalleryViewCubit>()
                                  .toggleView(ViewType.grid);
                            },
                            child: Container(
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: state == ViewType.grid ?
                                Color(pokemonColorValues.secondaryColor).withOpacity(0.1) : Colors.transparent,
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(7.2), bottomLeft: Radius.circular(7.2)),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 0,
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Icon(Icons.grid_view_outlined, size: 24.0,
                                        color: state == ViewType.grid ? Color(pokemonColorValues.secondaryColor) : Color(pokemonColorValues.secondaryColor).withOpacity(0.4)),
                                  ),
                                  Positioned(
                                      top: -20.0,
                                      bottom: 0,
                                      // left: 0,
                                      right: 2.0,
                                      child: state == ViewType.grid ? Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Color(pokemonColorValues.secondaryColor), size: 14,) : const SizedBox.shrink())
                                ],
                              ),
                            )),
                      ),
                      Container(
                        width: 1.0,
                        height: double.infinity,
                        color: Color(pokemonColorValues.secondaryColor).withOpacity(0.2),
                      ),
                      Expanded(
                        child: GestureDetector(
                            onTap: () {
                              context
                                  .read<GalleryViewCubit>()
                                  .toggleView(ViewType.list);
                            },
                            child: Container(
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: state == ViewType.list ?
                                Color(pokemonColorValues.secondaryColor).withOpacity(0.1) : Colors.transparent,
                                borderRadius: const BorderRadius.only(topRight: Radius.circular(7.2), bottomRight: Radius.circular(7.2)),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 0,
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Icon(
                                      Icons.list,
                                      color: state == ViewType.list ? Color(pokemonColorValues.secondaryColor) : Color(pokemonColorValues.secondaryColor).withOpacity(0.4),
                                      size: 28.0,
                                    ),
                                  ),
                                  Positioned(
                                      top: -20.0,
                                      bottom: 0,
                                      // left: 0,
                                      right: 2.0,
                                      child: state == ViewType.list ? Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Color(pokemonColorValues.secondaryColor), size: 14,) : const SizedBox.shrink())
                                ],
                              ),
                            )),
                      )
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: BlocBuilder<PokemonsBloc, PokemonStates>(
            builder: (context, state) {
              // return state is PokemonsLoaded
              //     ? allPokemonsView(
              //     bloc: context.read<PokemonsBloc>(),
              //     state: state,
              //     context: context)
              //     : state is PokemonsFailure
              //     ? CreatureCodexErrorWidget(message: state.errorText,)
              //     : allPokemonsLoading();
              return SmartRefresher(
                controller: context.read<PokemonsBloc>().refreshController,
                enablePullUp: true,
                header: const WaterDropHeader(),
                footer: const MoreFooter(),
                onRefresh: () async {
                  context.read<PokemonsBloc>().add(PokemonsRefreshed());
                },
                onLoading: () async {
                  context.read<PokemonsBloc>().add(FetchMorePokemons());
                },
                child: state is PokemonsLoaded
                    ? allPokemonsView(
                        bloc: context.read<PokemonsBloc>(),
                        state: state,
                        context: context)
                    : state is PokemonsFailure
                        ? CreatureCodexErrorWidget(message: state.errorText,)
                        : allPokemonsLoading(),
              );
            },
            // listener: (context, state) {
            //   if (state is PokemonsFailure) {
            //     // _refreshController.refreshFailed();
            //     // _refreshController.loadFailed();
            //   }
            //   else
            //   if(state is PokemonsLoaded){
            //     // _refreshController.loadComplete();
            //     // _refreshController.refreshCompleted();
            //     // if(state.hasReachedMax ?? false){
            //     //   _refreshController.loadNoData();
            //     // }
            //   }
            // },
          ),
        ),
      ),
      headerBuilder: () => WaterDropMaterialHeader(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      footerTriggerDistance: 30.0,
    );
  }
}
