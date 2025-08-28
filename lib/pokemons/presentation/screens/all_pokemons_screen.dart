import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pokemon/pokemons/bloc/gallery_view/gallery_view_cubit.dart';
import 'package:pokemon/pokemons/bloc/pokemon_bloc_util.dart';
import 'package:pokemon/pokemons/presentation/widgets/pokemons_grid.dart';
import 'package:pokemon/util/error_page.dart';
import 'package:pokemon/util/global_widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AllPokemonsScreen extends StatefulWidget {
  const AllPokemonsScreen({Key? key}) : super(key: key);

  @override
  State<AllPokemonsScreen> createState() => _AllPokemonsScreenState();
}

class _AllPokemonsScreenState extends State<AllPokemonsScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                return state == ViewType.grid
                    ? GestureDetector(
                        onTap: () {
                          context
                              .read<GalleryViewCubit>()
                              .toggleView(ViewType.list);
                        },
                        child: Icon(
                          Icons.list,
                          color: theme.colorScheme.primary,
                          size: 32,
                        ))
                    : GestureDetector(
                        onTap: () {
                          context
                              .read<GalleryViewCubit>()
                              .toggleView(ViewType.grid);
                        },
                        child: Icon(Icons.grid_view_outlined,
                            color: theme.colorScheme.primary));
              }),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: BlocBuilder<PokemonsBloc, PokemonStates>(
            builder: (context, state) {
              return SmartRefresher(
                controller: _refreshController,
                enablePullUp: true,
                header: const WaterDropHeader(),
                // footer: SpinKitRipple(
                //   key: const Key("pokemon_loading"),
                //   color: Theme.of(context).primaryColorDark,
                //   size: 60.0,
                // ),
                onRefresh: () async {
                  await Future.delayed(const Duration(milliseconds: 1000));
                  //
                  //         if (data.length == 0) {
                  //           for (int i = 0; i < 10; i++) {
                  //             data.add("Item $i");
                  //           }
                  //         }
                  if (mounted) setState(() {});
                  _refreshController.refreshCompleted();
                  //
                  //         /*
                  //   if(failed){
                  //    _refreshController.refreshFailed();
                  //   }
                  // */
                },
                onLoading: () async {
                  //monitor fetch data from network
                  await Future.delayed(const Duration(milliseconds: 1000));
                  // for (int i = 0; i < 10; i++) {
                  //   data.add("Item $i");
                  // }
                  //    pageIndex++;
                  if (mounted) setState(() {});
                  _refreshController.loadComplete();
                },
                child: state is PokemonsLoaded
                    ? allPokemonsView(
                        bloc: context.read<PokemonsBloc>(),
                        state: state,
                        context: context)
                    : state is PokemonsFailure
                        ? const CreatureCodexErrorWidget()
                        : allPokemonsLoading(),
              );
            },
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
