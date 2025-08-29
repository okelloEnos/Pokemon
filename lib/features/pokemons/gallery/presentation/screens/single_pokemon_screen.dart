import 'package:flutter/material.dart';
import '../../../../features_barrel.dart';

class SinglePokemonScreen extends StatelessWidget {
  final PokemonInfoEntity pokemon;
  const SinglePokemonScreen({Key? key, required this.pokemon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.cardColor,
      body: singlePokemonWidget(pokemon: pokemon, context: context),
    );
  }
}
