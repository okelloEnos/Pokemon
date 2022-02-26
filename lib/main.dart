import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:pokemon/app.dart';
import 'package:pokemon/pokemons/bloc/pokemon_bloc_util.dart';
import 'package:pokemon/pokemons/data/data_service/data_service_provider.dart';
import 'package:pokemon/pokemons/data/repository/pokemon_repository.dart';

void main() {
  // final PokemonRepository repository =
  //     PokemonRepository(dataService: DataService(dio: Dio()));

  // final storage = await HydratedStorage.build(storageDirectory: );
  runApp(PokemonsApp());
  // runApp(
  //   BlocProvider<PokemonsBloc>(create: (context))
  // );
}
