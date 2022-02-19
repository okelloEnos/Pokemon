import 'package:flutter/material.dart';
import 'package:pokemon/pokemons/data/models/pokemon_model_util.dart';
import 'package:pokemon/pokemons/presentation/widgets/single_pokemon.dart';

class SinglePokemonScreen extends StatelessWidget {
  final PokemonInfo pokemon;
  const SinglePokemonScreen({Key? key, required this.pokemon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: singlePokemonWidget(pokemon: pokemon, context: context)),
    );
  }
}
