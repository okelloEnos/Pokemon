part of 'pokemon_evolution_bloc.dart';

abstract class PokemonEvolutionEvent extends Equatable {
  const PokemonEvolutionEvent();
}

class FetchEvolutionChainEvent extends PokemonEvolutionEvent {
  final DataEntity? evolvesFrom;
  final DataEntity? evolutionChain;

  const FetchEvolutionChainEvent({required this.evolvesFrom, required this.evolutionChain});

  @override
  List<Object?> get props => [evolvesFrom, evolutionChain];
}
