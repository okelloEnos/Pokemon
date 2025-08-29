import 'package:equatable/equatable.dart';
import 'package:pokemon/features/pokemons/gallery/data/models/pokemon_model.dart';

class PokemonEntity extends Equatable{
  final String? pokemonName;
  final String? pokemonUrl;

  const PokemonEntity({this.pokemonName, this.pokemonUrl});

  @override
  List<Object?> get props => [pokemonName, pokemonUrl];

  // copy method
  PokemonEntity copyWith({String? pokemonName, String? pokemonUrl}) {
    return PokemonEntity(
      pokemonName: pokemonName ?? this.pokemonName,
      pokemonUrl: pokemonUrl ?? this.pokemonUrl,
    );
  }

  // from model to entity
  factory PokemonEntity.fromModel(PokemonModel model) {
    return PokemonEntity(
      pokemonName: model.pokemonName,
      pokemonUrl: model.pokemonUrl,
    );
  }
}