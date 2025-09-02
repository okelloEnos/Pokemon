import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../features_barrel.dart';

class PokemonInfoEntity extends Equatable {
  final String? pokemonName;
  final String? description;
  final String? genus;
  final int? baseExperience;
  final int? pokemonWeight;
  final int? pokemonHeight;
  final List<AbilitiesEntity>? abilities;
  final List<MovesEntity>? moves;
  final DataEntity? species;
  final SpritesEntity? sprites;
  final List<StatsEntity>? stats;
  final List<PokemonTypesEntity>? types;
  final List<PokemonInfoEntity>? variantsComplete;
  final List<DataEntity>? variants;
  final int? baseHappiness;
  final int? captureRate;
  final int? hatchCounter;
  final int? genderSplit;
  final String? growthRate;
  final String? habitat;
  final List<DataEntity>? eggGroups;
  final Color? color;

  @override
  List<Object?> get props => [
        pokemonName,
        description,
        genus,
        baseExperience,
        pokemonWeight,
        pokemonHeight,
        abilities,
        moves,
        species,
        sprites,
        stats,
        types,
        variants,
        baseHappiness,
        captureRate,
        hatchCounter,
        genderSplit,
        growthRate,
    habitat,
        eggGroups,
        variantsComplete,
        color,
      ];

  const PokemonInfoEntity(
      {this.pokemonName,
      this.description,
      this.baseExperience,
      this.pokemonWeight,
      this.pokemonHeight,
      this.abilities,
      this.moves,
      this.species,
      this.sprites,
      this.genus,
      this.variantsComplete,
      this.stats,
      this.types,
      this.variants,
      this.baseHappiness,
      this.captureRate,
      this.hatchCounter,
      this.growthRate,
      this.habitat,
      this.genderSplit,
      this.eggGroups,
      this.color});

  // copyWith method
  PokemonInfoEntity copyWith({
    String? pokemonName,
    String? description,
    String? genus,
    int? baseExperience,
    int? pokemonWeight,
    int? pokemonHeight,
    List<AbilitiesEntity>? abilities,
    List<MovesEntity>? moves,
    DataEntity? species,
    SpritesEntity? sprites,
    List<StatsEntity>? stats,
    List<PokemonTypesEntity>? types,
    List<DataEntity>? variants,
    int? baseHappiness,
    int? captureRate,
    int? hatchCounter,
    int? genderSplit,
    String? growthRate,
    String? habitat,
    List<DataEntity>? eggGroups,
    List<PokemonInfoEntity>? variantsComplete,
    Color? color,
  }) {
    return PokemonInfoEntity(
      pokemonName: pokemonName ?? this.pokemonName,
      description: description ?? this.description,
      genus: genus ?? this.genus,
      baseExperience: baseExperience ?? this.baseExperience,
      pokemonWeight: pokemonWeight ?? this.pokemonWeight,
      pokemonHeight: pokemonHeight ?? this.pokemonHeight,
      abilities: abilities ?? this.abilities,
      moves: moves ?? this.moves,
      species: species ?? this.species,
      sprites: sprites ?? this.sprites,
      stats: stats ?? this.stats,
      types: types ?? this.types,
      variants: variants ?? this.variants,
      baseHappiness: baseHappiness ?? this.baseHappiness,
      captureRate: captureRate ?? this.captureRate,
      hatchCounter: hatchCounter ?? this.hatchCounter,
      genderSplit: genderSplit ?? this.genderSplit,
      growthRate: growthRate ?? this.growthRate,
      habitat: habitat ?? this.habitat,
      eggGroups: eggGroups ?? this.eggGroups,
      variantsComplete: variantsComplete ?? this.variantsComplete,
      color: color ?? this.color,
    );
  }
}

class AbilitiesEntity extends Equatable {
  final bool? isHidden;
  final int? slot;
  final DataEntity? ability;

  const AbilitiesEntity({this.isHidden, this.ability, this.slot});

  @override
  List<Object?> get props => [isHidden, slot, ability];
}

class MovesEntity extends Equatable {
  final DataEntity? move;

  const MovesEntity({this.move});

  @override
  List<Object?> get props => [move];
}

class SpritesEntity extends Equatable {
  final String? backDefault;
  final String? frontDefault;
  final String? dreamWorld;
  final String? home;
  final String? artWork;

  const SpritesEntity(
      {this.backDefault,
      this.frontDefault,
      this.dreamWorld,
      this.home,
      this.artWork});

  @override
  List<Object?> get props =>
      [backDefault, frontDefault, dreamWorld, home, artWork];
}

class StatsEntity extends Equatable {
  final int? baseStat;
  final int? effort;
  final DataEntity? stat;

  const StatsEntity({this.baseStat, this.effort, this.stat});

  @override
  List<Object?> get props => [baseStat, effort, stat];
}

class PokemonTypesEntity extends Equatable {
  final int? slot;
  final DataEntity? pokemonType;

  const PokemonTypesEntity({this.slot, this.pokemonType});

  @override
  List<Object?> get props => [slot, pokemonType];
}
