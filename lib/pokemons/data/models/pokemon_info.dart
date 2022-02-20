import 'package:equatable/equatable.dart';

class PokemonInfo extends Equatable{
  final String? pokemonName;
  final int? baseExperience;
  final int? pokemonWeight;
  final int? pokemonHeight;
  final List<Abilities>? abilities;
  // final List<Form>? forms;
  // final List<GameIndice>? gameIndices;
  final List<Moves>? moves;
  final Species? species;
  final Sprites? sprites;
  final List<Stats>? stats;
  final List<PokemonTypes>? types;

  @override
  List<Object?> get props => [pokemonName, baseExperience, pokemonWeight,
  pokemonHeight, abilities, moves, species, sprites, stats, types];

  Map<String, dynamic> toJson() {
    return {
      'name': pokemonName,
      'base_experience': baseExperience,
      'height': pokemonHeight,
      'weight': pokemonWeight,
      'abilities': List<dynamic>.from(abilities!.map((innerAbilities) => innerAbilities.toJson())),
      'moves': List<dynamic>.from(moves!.map((innerMoves) => innerMoves.toJson())),
      'stats': List<dynamic>.from(stats!.map((innerStats) => innerStats.toJson())),
      'sprites': sprites!.toJson(),
      'species': species!.toJson(),
      'types': List<dynamic>.from(types!.map((innerTypes) => innerTypes.toJson())),
    };
  }
  const PokemonInfo({this.pokemonName, this.baseExperience, this.pokemonWeight, this.pokemonHeight,
  this.abilities, this.moves, this.species, this.sprites,
  this.stats, this.types});

  // PokemonInfo.copyWith({String? pokemonName, int? baseExperience, int? pokemonWeight,
  // int? pokemonHeight,
  // }){
  //   return PokemonInfo();
// }

}

class Abilities extends Equatable{
  final bool? isHidden;
  final int? slot;
  final Ability? ability;

  const Abilities({this.isHidden, this.ability, this.slot});

  Map<String, dynamic> toJson(){
    return {
      "is_hidden": isHidden,
      "slot": slot,
      "ability": ability!.toJson()
    };
  }
  @override
  List<Object?> get props => [
    isHidden, slot, ability
  ];



}

class Ability extends Equatable{
  final String? name;
  final String? url;

  const Ability({this.name, this.url});

  Map<String, dynamic> toJson(){
    return {
      "name": name,
      "url": url
    };
  }
  @override
  List<Object?> get props => [name, url];
}

class Moves extends Equatable{
  final Move? move;

  const Moves({this.move});

  Map<String, dynamic> toJson(){
    return {
      "move" : move!.toJson()
    };
  }
  @override
  List<Object?> get props => [move];
}

class Move extends Equatable{
  final String? name;
  final String? url;

  const Move({this.name, this.url});

  Map<String, dynamic> toJson(){
    return {
      "name": name,
      "url": url
    };
  }

  @override
  List<Object?> get props => [name, url];
}


class Species extends Equatable{
  final String? name;
  final String? url;

  const Species({this.name, this.url});

  Map<String, dynamic> toJson(){
    return {
      "name": name,
      "url": url
    };
  }

  @override
  List<Object?> get props => [name, url];
}

class Sprites extends Equatable{
  final String? backDefault;
  final String? frontDefault;
  final String? dreamWorld;
  final String? home;
  final String? artWork;

  const Sprites({this.backDefault, this.frontDefault, this.dreamWorld, this.home, this.artWork});

  Map<String, dynamic> toJson(){
    return {
      "back_default": backDefault,
      "front_default": frontDefault,
      "dream_world": dreamWorld,
      "home": home,
      "official-artwork": artWork
    };
  }

  @override
  List<Object?> get props => [backDefault, frontDefault, dreamWorld, home, artWork];
}

class Stats extends Equatable{
  final int? baseStat;
  final int? effort;
  final Stat? stat;

  const Stats({this.baseStat, this.effort, this.stat});

  Map<String, dynamic> toJson(){
    return {
      "base_stat": baseStat,
      "effort": effort,
      "stat": stat!.toJson()
    };
  }

  @override
  List<Object?> get props => [baseStat, effort, stat];
}


class Stat extends Equatable{
  final String? name;
  final String? url;

  const Stat({this.name, this.url});

  Map<String, dynamic> toJson(){
    return {
      "name": name,
      "url": url
    };
  }

  @override
  List<Object?> get props => [name, url];
}

class PokemonTypes extends Equatable{
  final int? slot;
  final PokemonType? pokemonType;

  const PokemonTypes({this.slot, this.pokemonType});

  Map<String, dynamic> toJson(){
    return {
      "type": pokemonType!.toJson(),
      "slot": slot
    };
  }
  @override
  List<Object?> get props => [slot, pokemonType];
}

class PokemonType extends Equatable{
  final String? name;
  final String? url;

  const PokemonType({this.name, this.url});

  Map<String, dynamic> toJson(){
    return {
      "name": name,
      "url": url
    };
  }

  @override
  List<Object?> get props => [name, url];
}
