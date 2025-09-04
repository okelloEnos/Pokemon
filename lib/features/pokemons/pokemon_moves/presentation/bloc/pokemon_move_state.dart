part of 'pokemon_move_bloc.dart';

abstract class PokemonMoveState extends Equatable {
  const PokemonMoveState();
}

class PokemonMoveInitial extends PokemonMoveState {
  @override
  List<Object> get props => [];
}

class PokemonMoveLoading extends PokemonMoveState {
  @override
  List<Object> get props => [];
}

class PokemonMoveLoaded extends PokemonMoveState {
  final List<MovesEntity> moves;

  const PokemonMoveLoaded({required this.moves});

  @override
  List<Object?> get props => [moves];
}

class PokemonMoveError extends PokemonMoveState {
  final String message;

  const PokemonMoveError({required this.message});

  @override
  List<Object?> get props => [message];
}
