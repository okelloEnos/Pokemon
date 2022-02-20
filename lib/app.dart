import 'package:beamer/beamer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/pokemons/bloc/pokemon_bloc_util.dart';
import 'package:pokemon/pokemons/data/data_service/data_service_provider.dart';
import 'package:pokemon/pokemons/data/models/pokemon_model_util.dart';
import 'package:pokemon/pokemons/data/repository/pokemon_repository.dart';
import 'package:pokemon/pokemons/presentation/screens/all_pokemons_screen.dart';
import 'package:pokemon/pokemons/presentation/screens/single_pokemon_screen.dart';
import 'package:pokemon/util/app_colors.dart';

class PokemonsApp extends StatelessWidget {
  PokemonsApp({Key? key}) : super(key: key);

  final routerDelegate = BeamerDelegate(
      initialPath: "/",
      locationBuilder: SimpleLocationBuilder(routes: {
        // return screens
        '/': (context) => BlocProvider<PokemonsBloc>(
              create: (context) {
                return PokemonsBloc(
                    pokemonRepository:
                        PokemonRepository(dataService: DataService(dio: Dio())))
                  ..add(PokemonsFetched());
              },
              child: const AllPokemonsScreen(),
            ),
        '/pokemons': (context) {
          // extract beamState which holds route information
          final beamState = context.currentBeamLocation.state;
          final pokemon = beamState.data["pokemon"] as PokemonInfo;
          return SinglePokemonScreen(pokemon: pokemon);
        }
      }));

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
      title: 'Pokemon App',
      debugShowCheckedModeBanner: false,
      theme: lightThemeData,
      routeInformationParser: BeamerParser(),
      routerDelegate: routerDelegate,
    );
  }
}
