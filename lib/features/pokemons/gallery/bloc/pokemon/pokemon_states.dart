part of 'pokemon_bloc.dart';

abstract class PokemonStates extends Equatable {
  @override
  List<Object?> get props => [];
}

class PokemonsInitial extends PokemonStates {}

class PokemonsFailure extends PokemonStates {
  final String errorText;

  PokemonsFailure({required this.errorText});

  @override
  List<Object> get props => [errorText];
}

class PokemonsLoaded extends PokemonStates {
  final List<PokemonInfoEntity> pokemons;
  final bool? hasReachedMax;
  final String? error;

  PokemonsLoaded({required this.pokemons, this.hasReachedMax, this.error});

  PokemonsLoaded copyWith(
      {List<PokemonInfoEntity>? pokemons, bool? hasReachedMax, String? error}) {
    return PokemonsLoaded(
        pokemons: pokemons ?? this.pokemons,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        error: error ?? this.error);
  }

  @override
  List<Object?> get props => [pokemons, hasReachedMax, error];
}

extension PokemonsStateX on PokemonStates {
  bool get isInitial => this == PokemonsInitial();

  bool get isLoaded => this == PokemonsLoaded(pokemons: const []);

  bool get isFailure => this == PokemonsFailure(errorText: "errorText");
}
