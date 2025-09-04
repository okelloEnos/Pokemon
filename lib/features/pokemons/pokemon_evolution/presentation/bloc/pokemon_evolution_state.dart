part of 'pokemon_evolution_bloc.dart';

abstract class PokemonEvolutionState extends Equatable {
  const PokemonEvolutionState();
}

class PokemonEvolutionInitial extends PokemonEvolutionState {
  @override
  List<Object> get props => [];
}

class PokemonEvolutionLoading extends PokemonEvolutionState {
  @override
  List<Object> get props => [];
}

class PokemonEvolutionLoaded extends PokemonEvolutionState {
  final List<EvolutionPokemonEntity> evolution;

  const PokemonEvolutionLoaded({required this.evolution});

  @override
  List<Object?> get props => [evolution];
}

class PokemonEvolutionError extends PokemonEvolutionState {
  final String message;

  const PokemonEvolutionError({required this.message});

  @override
  List<Object?> get props => [message];
}
