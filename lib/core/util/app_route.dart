import 'package:dio/dio.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon/features/features_barrel.dart';

import '../core_barrel.dart';

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
              return locator<PokemonsBloc>()
                ..add(PokemonsFetched());
            },
          ),
          BlocProvider<GalleryViewCubit>(
            create: (context) => GalleryViewCubit(),
          ),
        ],
        child: const AllPokemonsScreen(),
      );
    },
    routes: [creatureRoute]);

final creatureRoute = GoRoute(
    path: 'creature',
    name: 'creature',
    builder: (context, state) {
      final pokemon = state.extra as PokemonInfoEntity;
      return MultiBlocProvider(
        providers: [
          BlocProvider<PokemonMoveBloc>(
            create: (context) => locator<PokemonMoveBloc>(),
          ),
        ],
        child: SinglePokemonScreen(pokemon: pokemon),
      );
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
