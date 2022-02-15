import 'package:equatable/equatable.dart';

class PokemonInfo extends Equatable{
  final String? pokemonName;
  final int? baseExperience;
  final int? pokemonWeight;
  final int? pokemonHeight;
  final List<Abilities>? abilities;
  final List<Form>? forms;
  final List<GameIndice>? gameIndices;
  final List<Moves>? moves;
  final Species? species;
  final Sprites? sprites;
  final List<Stats>? stats;
  final List<PokemonTypes>? types;

  @override
  List<Object?> get props => [pokemonName, baseExperience, pokemonWeight,
  pokemonHeight, abilities, forms, gameIndices, moves, species, sprites, stats, types];

  const PokemonInfo({this.pokemonName, this.baseExperience, this.pokemonWeight, this.pokemonHeight,
  this.abilities, this.forms, this.gameIndices, this.moves, this.species, this.sprites,
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

  @override
  List<Object?> get props => [
    isHidden, slot, ability
  ];



}

class Ability extends Equatable{
  final String? name;
  final String? url;

  const Ability({this.name, this.url});

  @override
  List<Object?> get props => [name, url];
}

class Form extends Equatable{
  final String? name;
  final String? url;

  const Form({this.name, this.url});

  @override
  List<Object?> get props => [name, url];
}

class GameIndice extends Equatable{
  final int? gameIndex;
  final Version? version;

  const GameIndice({this.gameIndex, this.version});

  @override
  List<Object?> get props => [gameIndex, version];
}

class Version extends Equatable{
  final String? name;
  final String? url;

  const Version({this.name, this.url});

  @override
  List<Object?> get props => [name, url];
}

class Moves extends Equatable{
  final Move? move;
  final List<VersionGroupDetails>? versionGroupDetails;

  const Moves({this.move, this.versionGroupDetails});

  @override
  List<Object?> get props => [move, versionGroupDetails];
}

class Move extends Equatable{
  final String? name;
  final String? url;

  const Move({this.name, this.url});

  @override
  List<Object?> get props => [name, url];
}

class VersionGroupDetails extends Equatable{
  final int? levelLearnedAt;
  final MoveLearnMethod? moveLearnMethod;
  final VersionGroup? versionGroup;

  const VersionGroupDetails({this.levelLearnedAt, this.moveLearnMethod, this.versionGroup});

  @override
  List<Object?> get props => [levelLearnedAt, moveLearnMethod, versionGroup];
}

class MoveLearnMethod extends Equatable{
  final String? name;
  final String? url;

  const MoveLearnMethod({this.name, this.url});

  @override
  List<Object?> get props => [name, url];
}

class VersionGroup extends Equatable{
  final String? name;
  final String? url;

  const VersionGroup({this.name, this.url});

  @override
  List<Object?> get props => [name, url];
}

class Species extends Equatable{
  final String? name;
  final String? url;

  const Species({this.name, this.url});

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

  @override
  List<Object?> get props => [backDefault, frontDefault, dreamWorld, home, artWork];
}

class Other extends Equatable{
  final DreamWorld? dreamWorld;
  final Home? home;
  final OfficialArtWork? officialArtWork;

  const Other({this.dreamWorld, this.home, this.officialArtWork});

  @override
  List<Object?> get props => [dreamWorld, home, officialArtWork];
}

class DreamWorld extends Equatable{
  final String? frontDefault;

  const DreamWorld({this.frontDefault});

  @override
  List<Object?> get props => [frontDefault];
}

class Home extends Equatable{
  final String? frontDefault;

  const Home({this.frontDefault});

  @override
  List<Object?> get props => [frontDefault];
}

class OfficialArtWork extends Equatable{
  final String? frontDefault;

  const OfficialArtWork({this.frontDefault});

  @override
  List<Object?> get props => [frontDefault];
}
class Stats extends Equatable{
  final int? baseStat;
  final int? effort;
  final Stat? stat;

  const Stats({this.baseStat, this.effort, this.stat});

  @override
  List<Object?> get props => [baseStat, effort, stat];
}


class Stat extends Equatable{
  final String? name;
  final String? url;

  const Stat({this.name, this.url});

  @override
  List<Object?> get props => [name, url];
}

class PokemonTypes extends Equatable{
  final int? slot;
  final PokemonType? pokemonType;

  const PokemonTypes({this.slot, this.pokemonType});

  @override
  List<Object?> get props => [slot, pokemonType];
}

class PokemonType extends Equatable{
  final String? name;
  final String? url;

  const PokemonType({this.name, this.url});

  @override
  List<Object?> get props => [name, url];
}
