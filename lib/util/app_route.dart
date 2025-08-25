import 'package:dio/dio.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon/pokemons/data/data_service/data_service_provider.dart';
import 'package:pokemon/pokemons/data/models/pokemon_info.dart';
import 'package:pokemon/pokemons/data/repository/pokemon_repository.dart';
import 'package:pokemon/pokemons/presentation/screens/all_pokemons_screen.dart';
import 'package:pokemon/pokemons/presentation/screens/single_pokemon_screen.dart';
import 'package:pokemon/splash/splash_barrel.dart';
import 'package:pokemon/util/routing_error_page.dart';

import '../pokemons/bloc/gallery_view/gallery_view_cubit.dart';
import '../pokemons/bloc/pokemon_bloc_util.dart';

final splashRoute = GoRoute(
    path: '/',
    name: '/',
    builder: (context, state) {
      return const SplashScreen();
    });

final galleryRoute = GoRoute(
    path: '/gallery',
    name: 'gallery',
    builder: (context, state) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<PokemonsBloc>(
            create: (context) {
              return PokemonsBloc(
                  pokemonRepository:
                  PokemonRepository(dataService: DataService(dio: Dio())))
                ..add(PokemonsFetched());
            },
          ),
          BlocProvider<GalleryViewCubit>(
            create: (context) => GalleryViewCubit(),
          )
        ],
        child: const AllPokemonsScreen(),
      );
    },
    routes: [creatureRoute]);

final creatureRoute = GoRoute(
    path: 'creature',
    name: 'creature',
    builder: (context, state) {
      final pokemon = state.extra as PokemonInfo;
      return SinglePokemonScreen(pokemon: pokemon);
    });

/// app route configuration
final GoRouter appRouter = GoRouter(
  initialLocation: "/",
  redirect: (context, state) {
    return null;
  },
  routes: <RouteBase>[
    splashRoute,
    galleryRoute
  ],
  errorBuilder: (context, state) => RoutingErrorPage(
    goRouterState: state,
  ),
);
