part of 'pokemon_move_bloc.dart';

abstract class PokemonMoveEvent extends Equatable {
  const PokemonMoveEvent();
}

class FetchMovesDetailsEvent extends PokemonMoveEvent {
  final List<MovesEntity> moves;

  const FetchMovesDetailsEvent({required this.moves});

  @override
  List<Object?> get props => [moves];
}
