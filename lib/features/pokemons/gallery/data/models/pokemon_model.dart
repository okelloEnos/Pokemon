import 'package:equatable/equatable.dart';
import 'package:pokemon/features/pokemons/gallery/domain/entities/pokemon_entity.dart';

class PokemonModel extends PokemonEntity {

  const PokemonModel({String? pokemonName, String? pokemonUrl}) : super(pokemonName: pokemonName, pokemonUrl: pokemonUrl);

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
      pokemonName: json['name'] as String?,
      pokemonUrl: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': pokemonName,
      'url': pokemonUrl,
    };
  }

  factory PokemonModel.fromEntity({required PokemonEntity entity}) {
    return PokemonModel(
      pokemonName: entity.pokemonName,
      pokemonUrl: entity.pokemonUrl,
    );
  }
}
