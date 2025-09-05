import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../features_barrel.dart';

class PokemonInfoEntity extends Equatable {
  final String? id;
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
  final DataEntity? evolutionChain;
  final DataEntity? evolvesFrom;
  final SpeciesEntity? speciesData;

  @override
  List<Object?> get props => [
    id,
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
        evolutionChain,
        evolvesFrom,
        speciesData,
      ];

  const PokemonInfoEntity(
      {
        this.id,
        this.pokemonName,
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
      this.color,
      this.evolutionChain,
      this.evolvesFrom,
      this.speciesData});

  // copyWith method
  PokemonInfoEntity copyWith({
    String? id,
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
    DataEntity? evolutionChain,
    DataEntity? evolvesFrom,
    SpeciesEntity? speciesData,
  }) {
    return PokemonInfoEntity(
      id: id ?? this.id,
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
      evolutionChain: evolutionChain ?? this.evolutionChain,
      evolvesFrom: evolvesFrom ?? this.evolvesFrom,
      speciesData: speciesData ?? this.speciesData,
    );
  }
}

class SpeciesEntity extends Equatable {
  final String? description;
  final String? genus;
  final int? baseHappiness;
  final int? captureRate;
  final int? hatchCounter;
  final int? genderSplit;
  final String? growthRate;
  final String? habitat;
  final List<DataEntity>? eggGroups;
  final Color? color;
  final DataEntity? evolutionChain;
  final DataEntity? evolvesFrom;
  final List<PokemonInfoEntity>? variantsComplete;
  final List<DataEntity>? variants;

  @override
  List<Object?> get props => [
        description,
        genus,
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
        evolutionChain,
        evolvesFrom,
      ];

  const SpeciesEntity(
      {this.description,
      this.genus,
      this.variantsComplete,
      this.variants,
      this.baseHappiness,
      this.captureRate,
      this.hatchCounter,
      this.growthRate,
      this.habitat,
      this.genderSplit,
      this.eggGroups,
      this.color,
      this.evolutionChain,
      this.evolvesFrom});

  // copyWith method
  PokemonInfoEntity copyWith({
    String? description,
    String? genus,
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
    DataEntity? evolutionChain,
    DataEntity? evolvesFrom,
  }) {
    return PokemonInfoEntity(
      description: description ?? this.description,
      genus: genus ?? this.genus,
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
      evolutionChain: evolutionChain ?? this.evolutionChain,
      evolvesFrom: evolvesFrom ?? this.evolvesFrom,
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
  final List<VersionGroupDetailsEntity>? versionGroupDetails;
  final int? accuracy;
  final contestCombos;
  final DataEntity? contestEffect;
  final DataEntity? contestType;
  final DataEntity? damageClass;
  final List<EffectEntity>? effectEntries;
  final List<MoveFlavourEntity>? flavourTextEntries;
  final DataEntity? generation;
  final List<DataEntity>? learnedByPokemon;
  final List<MachineEntity>? machines;
  final int? power;
  final int? pp;
  final int? priority;
  final String? superContestEffect;
  final DataEntity? target;
  final DataEntity? type;

  const MovesEntity(
      {this.move,
      this.versionGroupDetails,
      this.accuracy,
      this.contestCombos,
      this.contestEffect,
      this.contestType,
      this.damageClass,
      this.effectEntries,
      this.flavourTextEntries,
      this.generation,
      this.learnedByPokemon,
      this.machines,
      this.power,
      this.pp,
      this.priority,
      this.superContestEffect,
      this.target,
      this.type});

  @override
  List<Object?> get props => [
        move,
        versionGroupDetails,
        accuracy,
        contestCombos,
        contestEffect,
        contestType,
        damageClass,
        effectEntries,
        flavourTextEntries,
        generation,
        learnedByPokemon,
        machines,
        power,
        pp,
        priority,
        superContestEffect,
        target,
        type
      ];

  // copyWith method
  MovesEntity copyWith({
    DataEntity? move,
    List<VersionGroupDetailsEntity>? versionGroupDetails,
    int? accuracy,
    contestCombos,
    DataEntity? contestEffect,
    DataEntity? contestType,
    DataEntity? damageClass,
    List<EffectEntity>? effectEntries,
    List<MoveFlavourEntity>? flavourTextEntries,
    DataEntity? generation,
    List<DataEntity>? learnedByPokemon,
    List<MachineEntity>? machines,
    int? power,
    int? pp,
    int? priority,
    String? superContestEffect,
    DataEntity? target,
    DataEntity? type,
  }) {
    return MovesEntity(
      move: move ?? this.move,
      versionGroupDetails: versionGroupDetails ?? this.versionGroupDetails,
      accuracy: accuracy ?? this.accuracy,
      contestCombos: contestCombos ?? this.contestCombos,
      contestEffect: contestEffect ?? this.contestEffect,
      contestType: contestType ?? this.contestType,
      damageClass: damageClass ?? this.damageClass,
      effectEntries: effectEntries ?? this.effectEntries,
      flavourTextEntries: flavourTextEntries ?? this.flavourTextEntries,
      generation: generation ?? this.generation,
      learnedByPokemon: learnedByPokemon ?? this.learnedByPokemon,
      machines: machines ?? this.machines,
      power: power ?? this.power,
      pp: pp ?? this.pp,
      priority: priority ?? this.priority,
      superContestEffect: superContestEffect ?? this.superContestEffect,
      target: target ?? this.target,
      type: type ?? this.type,
    );
  }
}

class VersionGroupDetailsEntity extends Equatable {
  final int? levelLearnedAt;
  final DataEntity? moveLearnMethod;
  final DataEntity? versionGroup;

  const VersionGroupDetailsEntity(
      {this.levelLearnedAt, this.moveLearnMethod, this.versionGroup});

  @override
  List<Object?> get props => [levelLearnedAt, moveLearnMethod, versionGroup];
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

class EffectEntity extends Equatable {
  final String? effect;
  final String? shortEffect;

  const EffectEntity({this.effect, this.shortEffect});

  @override
  List<Object?> get props => [effect, shortEffect];
}

class MoveFlavourEntity extends Equatable {
  final String? text;
  final DataEntity? version;

  const MoveFlavourEntity({this.text, this.version});

  @override
  List<Object?> get props => [text, version];
}

class MachineEntity extends Equatable {
  final String? url;
  final DataEntity? version;

  const MachineEntity({this.url, this.version});

  @override
  List<Object?> get props => [url, version];
}

class EvolutionEntity extends Equatable {
  final DataEntity? species;
  final DataEntity? evolveSpeciesFrom;
  final List<DataEntity>? evolvesTo;
  final ChainEntity? chain;

  const EvolutionEntity(
      {this.species, this.evolvesTo, this.chain, this.evolveSpeciesFrom});

  @override
  List<Object?> get props => [species, evolvesTo, chain, evolveSpeciesFrom];

  // copyWith method
  EvolutionEntity copyWith({
    DataEntity? species,
    List<DataEntity>? evolvesTo,
    ChainEntity? chain,
    DataEntity? evolveSpeciesFrom,
  }) {
    return EvolutionEntity(
      species: species ?? this.species,
      evolvesTo: evolvesTo ?? this.evolvesTo,
      chain: chain ?? this.chain,
      evolveSpeciesFrom: evolveSpeciesFrom ?? this.evolveSpeciesFrom,
    );
  }
}

class ChainEntity extends Equatable {
  final bool? isBaby;
  final List<EvolutionDetailEntity>? evolutionDetails;
  final DataEntity? species;
  final List<ChainEntity>? evolvesTo;

  const ChainEntity(
      {this.species, this.evolvesTo, this.evolutionDetails, this.isBaby});

  @override
  List<Object?> get props => [species, evolvesTo, evolutionDetails, isBaby];
}

class EvolutionDetailEntity extends Equatable {
  final String? gender;
  final String? heldItem;
  final String? item;
  final String? knownMove;
  final String? knownMoveType;
  final String? location;
  final String? minAffection;
  final String? minBeauty;
  final String? minHappiness;
  final String? minLevel;
  final String? needsOverworldRain;
  final String? partySpecies;
  final String? partyType;
  final String? relativePhysicalStats;
  final String? timeOfDay;
  final String? tradeSpecies;
  final DataEntity? trigger;
  final String? turnUpsideDown;

  const EvolutionDetailEntity(
      {this.gender,
      this.heldItem,
      this.item,
      this.knownMove,
      this.knownMoveType,
      this.location,
      this.minAffection,
      this.minBeauty,
      this.minHappiness,
      this.minLevel,
      this.needsOverworldRain,
      this.partySpecies,
      this.partyType,
      this.relativePhysicalStats,
      this.timeOfDay,
      this.tradeSpecies,
      this.trigger,
      this.turnUpsideDown});

  @override
  List<Object?> get props => [
        gender,
        heldItem,
        item,
        knownMove,
        knownMoveType,
        location,
        minAffection,
        minBeauty,
        minHappiness,
        minLevel,
        needsOverworldRain,
        partySpecies,
        partyType,
        relativePhysicalStats,
        timeOfDay,
        tradeSpecies,
        trigger,
        turnUpsideDown
      ];
}

class EvolutionPokemonEntity extends Equatable {
  final String? name;
  final String? imageUrl;
  final bool? isBaby;
  final bool? isLast;

  const EvolutionPokemonEntity(
      {this.name, this.imageUrl, this.isBaby, this.isLast});

  @override
  List<Object?> get props => [name, imageUrl, isBaby, isLast];
}
