import 'package:equatable/equatable.dart';
import 'package:pokemon/pokemons/data/models/pokemon_model.dart';
import 'package:pokemon/pokemons/data/models/pokemon_model_util.dart';

abstract class PokemonStates extends Equatable{


  @override
  List<Object> get props => [];
}

class PokemonsInitial extends PokemonStates{}

class PokemonsFailure extends PokemonStates{
  final String errorText;

  PokemonsFailure({required this.errorText});

  @override
  List<Object> get props => [errorText];
}

class PokemonsLoaded extends PokemonStates{
  final List<PokemonInfo> pokemons;
  final bool hasReachedMax;
  final String error;

  PokemonsLoaded({this.pokemons = const <PokemonInfo> [], this.hasReachedMax = false, this.error = ''});

  PokemonsLoaded copyWith({List<PokemonInfo>? pokemons, bool? hasReachedMax, String? error}){
    return PokemonsLoaded(
      pokemons: pokemons ?? this.pokemons,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      error: error ?? this.error
    );


  }

  @override
  List<Object> get props => [pokemons, hasReachedMax, error];
}

extension PokemonsStateX on PokemonStates{
  bool get isInitial => this == PokemonsInitial();
  bool get isLoaded => this == PokemonsLoaded();
  bool get isFailure => this == PokemonsFailure(errorText: "errorText") ;
}