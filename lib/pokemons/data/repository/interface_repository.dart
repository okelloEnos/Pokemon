import 'package:pokemon/pokemons/data/models/pokemon_model.dart';

abstract class InterfaceRepository{

  /// get all pokemons
  Future<List<PokemonModel>>retrieveAllPokemons();
}