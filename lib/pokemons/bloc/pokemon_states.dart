import 'package:equatable/equatable.dart';
import 'package:pokemon/pokemons/data/models/pokemon_model.dart';

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
  final List<PokemonModel> pokemons;
  final bool hasReachedMax;
  final String error;

  PokemonsLoaded({this.pokemons = const <PokemonModel> [], this.hasReachedMax = false, this.error = ''});

  PokemonsLoaded copyWith({List<PokemonModel>? pokemons, bool? hasReachedMax, String? error}){
    return PokemonsLoaded(
      pokemons: pokemons ?? this.pokemons,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      error: error ?? this.error
    );


  }

  @override
  List<Object> get props => [pokemons, hasReachedMax, error];
}