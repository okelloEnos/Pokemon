import 'package:pokemon/pokemons/data/models/pokemon_model_util.dart';

abstract class InterfaceRepository{

  /// get all pokemons
  Future<List<PokemonModel>>retrieveAllPokemons();

  Future<List<PokemonInfo>> retrievePokemonsWithTheirData(List<PokemonModel> pokemons);
}