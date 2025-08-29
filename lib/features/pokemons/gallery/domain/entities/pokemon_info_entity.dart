import 'package:equatable/equatable.dart';

import '../../../../features_barrel.dart';

class PokemonInfoEntity extends Equatable{
  final String? pokemonName;
  final int? baseExperience;
  final int? pokemonWeight;
  final int? pokemonHeight;
  final List<AbilitiesEntity>? abilities;
  final List<MovesEntity>? moves;
  final DataEntity? species;
  final SpritesEntity? sprites;
  final List<StatsEntity>? stats;
  final List<PokemonTypesEntity>? types;

  @override
  List<Object?> get props => [pokemonName, baseExperience, pokemonWeight,
  pokemonHeight, abilities, moves, species, sprites, stats, types];

  const PokemonInfoEntity({this.pokemonName, this.baseExperience, this.pokemonWeight, this.pokemonHeight,
  this.abilities, this.moves, this.species, this.sprites,
  this.stats, this.types});

}

class AbilitiesEntity extends Equatable{
  final bool? isHidden;
  final int? slot;
  final DataEntity? ability;

  const AbilitiesEntity({this.isHidden, this.ability, this.slot});

  @override
  List<Object?> get props => [
    isHidden, slot, ability
  ];
}

class MovesEntity extends Equatable{
  final DataEntity? move;

  const MovesEntity({this.move});

  @override
  List<Object?> get props => [move];
}

class SpritesEntity extends Equatable{
  final String? backDefault;
  final String? frontDefault;
  final String? dreamWorld;
  final String? home;
  final String? artWork;

  const SpritesEntity({this.backDefault, this.frontDefault, this.dreamWorld, this.home, this.artWork});

  @override
  List<Object?> get props => [backDefault, frontDefault, dreamWorld, home, artWork];
}

class StatsEntity extends Equatable{
  final int? baseStat;
  final int? effort;
  final DataEntity? stat;

  const StatsEntity({this.baseStat, this.effort, this.stat});

  @override
  List<Object?> get props => [baseStat, effort, stat];
}

class PokemonTypesEntity extends Equatable{
  final int? slot;
  final DataEntity? pokemonType;

  const PokemonTypesEntity({this.slot, this.pokemonType});

  @override
  List<Object?> get props => [slot, pokemonType];
}
