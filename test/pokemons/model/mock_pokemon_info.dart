import 'package:mocktail/mocktail.dart';
import 'package:pokemon/pokemons/data/models/pokemon_model_util.dart';

class MockPokemonInfo extends Mock implements PokemonInfo {

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': 'pokemonName',
      'base_experience': 'baseExperience',
      'height': 'pokemonHeight',
      'weight': 'pokemonWeight',
      'abilities': 'List<dynamic>.from(abilities!.map((innerAbilities) => innerAbilities.toJson()))',
      'moves': 'List<dynamic>.from(moves!.map((innerMoves) => innerMoves.toJson()))',
      'stats': 'List<dynamic>.from(stats!.map((innerStats) => innerStats.toJson()))',
      'sprites': 'sprites!.toJson()',
      'species': 'species!.toJson()',
      'types': 'List<dynamic>.from(types!.map((innerTypes) => innerTypes.toJson()))',
    };
  }
}
