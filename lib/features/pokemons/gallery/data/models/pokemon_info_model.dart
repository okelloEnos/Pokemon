import 'package:equatable/equatable.dart';
import 'package:pokemon/features/features_barrel.dart';
import 'package:pokemon/features/pokemons/gallery/domain/entities/pokemon_info_entity.dart';

import '../../../../../core/core_barrel.dart';

class PokemonInfoModel extends PokemonInfoEntity {
  const PokemonInfoModel({
    required String? pokemonName,
    required int? baseExperience,
    required int? pokemonWeight,
    required int? pokemonHeight,
    required List<AbilitiesModel>? abilities,
    required List<MovesModel>? moves,
    required DataModel? species,
    required SpritesModel? sprites,
    required List<StatsModel>? stats,
    required List<PokemonTypesModel>? types,
  }) : super(
            pokemonName: pokemonName,
            baseExperience: baseExperience,
            pokemonWeight: pokemonWeight,
            pokemonHeight: pokemonHeight,
            abilities: abilities,
            moves: moves,
            species: species,
            sprites: sprites,
            stats: stats,
            types: types);

  Map<String, dynamic> toJson() {
    return {
      "name": pokemonName,
      "base_experience": baseExperience,
      "weight": pokemonWeight,
      "height": pokemonHeight,
      "abilities": abilities
          ?.map((ability) => AbilitiesModel.fromEntity(ability).toJson())
          .toList(),
      "moves":
          moves?.map((move) => MovesModel.fromEntity(move).toJson()).toList(),
      "species": species != null
          ? DataModel.fromEntity(entity: species).toJson()
          : null,
      "sprites":
          sprites != null ? SpritesModel.fromEntity(sprites).toJson() : null,
      "stats":
          stats?.map((stat) => StatsModel.fromEntity(stat).toJson()).toList(),
      "types": types
          ?.map((type) => PokemonTypesModel.fromEntity(type).toJson())
          .toList(),
    };
  }

  factory PokemonInfoModel.fromJson(Map<String, dynamic> json) {
    List<AbilitiesModel> abilities = parseList<AbilitiesModel>(
        json: json['abilities'],
        fromJson: (map) => AbilitiesModel.fromJson(map));
    List<MovesModel> moves = parseList<MovesModel>(
        json: json['moves'], fromJson: (map) => MovesModel.fromJson(map));
    List<StatsModel> stats = parseList<StatsModel>(
        json: json['stats'], fromJson: (map) => StatsModel.fromJson(map));
    List<PokemonTypesModel> types = parseList<PokemonTypesModel>(
        json: json['types'],
        fromJson: (map) => PokemonTypesModel.fromJson(map));

    return PokemonInfoModel(
      pokemonName: json['name'],
      baseExperience: json['base_experience'],
      pokemonWeight: json['weight'],
      pokemonHeight: json['height'],
      abilities: abilities,
      moves: moves,
      species:
          json['species'] != null ? DataModel.fromJson(json['species']) : null,
      sprites: json['sprites'] != null
          ? SpritesModel.fromJson(json['sprites'])
          : null,
      stats: stats,
      types: types,
    );
  }

  factory PokemonInfoModel.fromEntity(PokemonInfoEntity entity) {
    return PokemonInfoModel(
      pokemonName: entity.pokemonName,
      baseExperience: entity.baseExperience,
      pokemonWeight: entity.pokemonWeight,
      pokemonHeight: entity.pokemonHeight,
      abilities: entity.abilities
          ?.map((ability) => AbilitiesModel.fromEntity(ability))
          .toList(),
      moves: entity.moves?.map((move) => MovesModel.fromEntity(move)).toList(),
      species: entity.species != null
          ? DataModel.fromEntity(entity: entity.species!)
          : null,
      sprites: entity.sprites != null
          ? SpritesModel.fromEntity(entity.sprites!)
          : null,
      stats: entity.stats?.map((stat) => StatsModel.fromEntity(stat)).toList(),
      types: entity.types
          ?.map((type) => PokemonTypesModel.fromEntity(type))
          .toList(),
    );
  }
}

class AbilitiesModel extends AbilitiesEntity {
  const AbilitiesModel({bool? isHidden, int? slot, DataModel? ability})
      : super(isHidden: isHidden, slot: slot, ability: ability);

  factory AbilitiesModel.fromJson(Map<String, dynamic> json) {
    return AbilitiesModel(
      isHidden: json['is_hidden'],
      slot: json['slot'],
      ability:
          json['ability'] != null ? DataModel.fromJson(json['ability']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "is_hidden": isHidden,
      "slot": slot,
      "ability": ability != null
          ? DataModel.fromEntity(entity: ability).toJson()
          : null,
    };
  }

  factory AbilitiesModel.fromEntity(AbilitiesEntity entity) {
    return AbilitiesModel(
      isHidden: entity.isHidden,
      slot: entity.slot,
      ability: entity.ability != null
          ? DataModel.fromEntity(entity: entity.ability)
          : null,
    );
  }
}

class MovesModel extends MovesEntity {
  const MovesModel({required DataModel? move}) : super(move: move);

  factory MovesModel.fromJson(Map<String, dynamic> json) {
    return MovesModel(
      move: json['move'] != null ? DataModel.fromJson(json['move']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "move": move != null ? DataModel.fromEntity(entity: move).toJson() : null
    };
  }

  factory MovesModel.fromEntity(MovesEntity entity) {
    return MovesModel(
      move: entity.move != null
          ? DataModel.fromEntity(entity: entity.move)
          : null,
    );
  }
}

class SpritesModel extends SpritesEntity {
  const SpritesModel(
      {required String? backDefault,
      required String? frontDefault,
      required String? dreamWorld,
      required String? home,
      required String? artWork})
      : super(
            backDefault: backDefault,
            frontDefault: frontDefault,
            dreamWorld: dreamWorld,
            home: home,
            artWork: artWork);

  factory SpritesModel.fromJson(Map<String, dynamic> json) {
    return SpritesModel(
      backDefault: json['back_default'],
      frontDefault: json['front_default'],
      dreamWorld: json['other']['dream_world'] != null
          ? json['other']['dream_world']['front_default']
          : null,
      home: json['other']['home'] != null ? json['other']['home']['front_default'] : null,
      artWork: json['other']['official-artwork'] != null
          ? json['other']['official-artwork']['front_default']
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "back_default": backDefault,
      "front_default": frontDefault,
      "dream_world": dreamWorld,
      "home": home,
      "official-artwork": artWork
    };
  }

  factory SpritesModel.fromEntity(SpritesEntity? entity) {
    return SpritesModel(
        backDefault: entity?.backDefault,
        frontDefault: entity?.frontDefault,
        dreamWorld: entity?.dreamWorld,
        home: entity?.home,
        artWork: entity?.artWork);
  }
}

class StatsModel extends StatsEntity {
  const StatsModel(
      {required int? baseStat, required int? effort, required DataModel? stat})
      : super(baseStat: baseStat, effort: effort, stat: stat);

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      baseStat: json['base_stat'],
      effort: json['effort'],
      stat: json['stat'] != null ? DataModel.fromJson(json['stat']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "base_stat": baseStat,
      "effort": effort,
      "stat": stat != null ? DataModel.fromEntity(entity: stat).toJson() : null
    };
  }

  factory StatsModel.fromEntity(StatsEntity entity) {
    return StatsModel(
      baseStat: entity.baseStat,
      effort: entity.effort,
      stat: entity.stat != null
          ? DataModel.fromEntity(entity: entity.stat)
          : null,
    );
  }
}

class PokemonTypesModel extends PokemonTypesEntity {
  const PokemonTypesModel({required DataModel? pokemonType, required int? slot})
      : super(pokemonType: pokemonType, slot: slot);

  factory PokemonTypesModel.fromJson(Map<String, dynamic> json) {
    return PokemonTypesModel(
      pokemonType:
          json['type'] != null ? DataModel.fromJson(json['type']) : null,
      slot: json['slot'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": pokemonType != null
          ? DataModel.fromEntity(entity: pokemonType).toJson()
          : null,
      "slot": slot
    };
  }

  factory PokemonTypesModel.fromEntity(PokemonTypesEntity entity) {
    return PokemonTypesModel(
      pokemonType: entity.pokemonType != null
          ? DataModel.fromEntity(entity: entity.pokemonType)
          : null,
      slot: entity.slot,
    );
  }
}
