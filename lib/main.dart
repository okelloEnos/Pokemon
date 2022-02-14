import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/app.dart';
import 'package:pokemon/pokemons/data/data_service/data_service_provider.dart';
import 'package:pokemon/pokemons/data/repository/pokemon_repository.dart';
import 'package:pokemon/util/app_colors.dart';

void main() {
  final PokemonRepository repository = PokemonRepository(dataService: DataService(dio: Dio()));

  runApp(PokemonsApp(pokemonRepository: repository));
}
