import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/pokemons/bloc/pokemon_bloc_util.dart';
import 'package:pokemon/pokemons/data/repository/pokemon_repository.dart';
import 'package:pokemon/pokemons/presentation/screens/all_pokemons_screen.dart';
import 'package:pokemon/util/app_colors.dart';

class PokemonsApp extends StatelessWidget {
  final PokemonRepository pokemonRepository;

  const PokemonsApp({Key? key, required this.pokemonRepository}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon App',
      debugShowCheckedModeBanner: false,
      theme: lightThemeData,
      home: BlocProvider<PokemonsBloc>(create: (context){
        return PokemonsBloc(pokemonRepository: pokemonRepository)..add(PokemonsFetched());
      },
        child: const AllPokemonsScreen(),),
    );
  }
}