import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pokemon/core/core_barrel.dart';
import 'package:pokemon/features/pokemons/gallery/domain/domain_barrel.dart';

import '../../../../features_barrel.dart';

part 'pokemon_move_event.dart';
part 'pokemon_move_state.dart';

class PokemonMoveBloc extends Bloc<PokemonMoveEvent, PokemonMoveState> {
  final FetchAllPokemonUseCase _useCase;
  PokemonMoveBloc({required FetchAllPokemonUseCase useCase}) : _useCase = useCase, super(PokemonMoveInitial()) {
    on<FetchMovesDetailsEvent>(_onFetchMovesDetailsEvent);
  }

  Future<void> _onFetchMovesDetailsEvent(FetchMovesDetailsEvent event, Emitter<PokemonMoveState> emit) async {
    emit(PokemonMoveLoading());
    try {
      List<MovesEntity> detailedMoves = [];
      for (MovesEntity moveEntity in event.moves) {
        debugPrint("Fetching details for move: ${moveEntity.move?.name}");
        MovesEntity detailedMove = await _useCase.moveDataRequest(url: moveEntity.move?.url);
        detailedMove = detailedMove.copyWith(move: moveEntity.move, versionGroupDetails: moveEntity.versionGroupDetails);
        detailedMoves.add(detailedMove);
      }
      emit(PokemonMoveLoaded(moves: detailedMoves));
    }
    on DioError catch (e){
      emit(PokemonMoveError(message: DioExceptions.fromDioError(e).message ?? "An error occurred while fetching move details."));
    }
    catch (e, s) {
      emit(PokemonMoveError(message: e.toString()));
    }
  }
}
