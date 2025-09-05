part of 'pokemon_bloc.dart';

abstract class PokemonEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class PokemonsFetched extends PokemonEvents {
  final int? offset;
  final int? limit;

  PokemonsFetched({this.offset, this.limit});

  @override
  List<Object?> get props => [offset, limit];

}
