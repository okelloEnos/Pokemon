import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:pokemon/core/core_barrel.dart';
import 'package:pokemon/features/pokemons/gallery/domain/domain_barrel.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../features_barrel.dart';
import 'package:dio/dio.dart';

part 'pokemon_events.dart';

part 'pokemon_states.dart';

int _fetchLimit = 12;
int _fetchOffset = 0;

class PokemonsBloc extends Bloc<PokemonEvents, PokemonStates> {
  // final GalleryRepository pokemonRepository;
  final FetchAllPokemonUseCase _useCase;
  final ScrollController scrollController = ScrollController();
  final RefreshController refreshController = RefreshController(initialRefresh: false);

  List<PokemonInfoEntity> allLoadedPokemons = [];
  int limit = _fetchLimit;
  int offset = _fetchOffset;

  PokemonsBloc({required FetchAllPokemonUseCase useCase})
      : _useCase = useCase,
        super(PokemonsInitial()) {
    // scrollController.addListener(() {
    //   if (scrollController.offset >=
    //           scrollController.position.maxScrollExtent &&
    //       !scrollController.position.outOfRange) {
    //     if (state is PokemonsLoaded) {
    //       // add(FetchMorePokemons());
    //     }
    //   }
    //
    //   if (scrollController.offset <=
    //           scrollController.position.minScrollExtent &&
    //       !scrollController.position.outOfRange) {
    //     // add(PokemonsRefreshed());
    //   }
    // });
    on<PokemonsFetched>(_onPokemonsFetched);
    on<PokemonsRefreshed>(_onPokemonsRefreshed);
    on<FetchMorePokemons>(_onFetchMorePokemons);
  }

  Future<void> _onPokemonsFetched(
      PokemonsFetched event, Emitter<PokemonStates> emit) async {
    emit(PokemonsLoading());
    try {
      int currentOffset = _fetchOffset;
      int currentLimit = _fetchLimit;
      bool hasReachedMax = false;

      List<DataEntity> pokemons =
          await _useCase.call(offset: currentOffset, limit: currentLimit);

      List<PokemonInfoEntity> pokemonsWithData = [];
      for (DataEntity data in pokemons) {
        PokemonInfoEntity pokemonWithData =
            await _useCase.coreDataRequest(name: data.name);
        Color? prominentColor;
        if(pokemonWithData.sprites?.artWork != null) {
          PaletteGenerator paletteGenerator = await PaletteGenerator
              .fromImageProvider(
              NetworkImage(pokemonWithData.sprites!.artWork!));
          prominentColor = paletteGenerator.dominantColor?.color ;
        }
        else{
          prominentColor = Colors.grey;
        }

        List<PokemonInfoEntity> variants = [];
        for (DataEntity variant in pokemonWithData.variants ?? []) {
          try {
            PokemonInfoEntity pokemonVariant =
                await _useCase.coreDataRequest(name: variant.name);
            variants.add(pokemonVariant);
          } catch (e) {
            debugPrint(e.toString());
          }
        }

        pokemonsWithData.add(pokemonWithData.copyWith(variantsComplete: variants, color: prominentColor));
      }
      List<PokemonInfoEntity> allPokemons = [
        ...allLoadedPokemons,
        ...pokemonsWithData
      ];
      allLoadedPokemons = allPokemons;

      if (pokemons.length < limit) {
        offset = pokemons.length;
        hasReachedMax = true;
      } else {
        offset = currentLimit;
        // offset = _fetchOffset + currentLimit;
      }


      // allPokemons = allPokemons.toSet().toList();
      allPokemons = allPokemons.where((pokemon) => pokemon.sprites?.artWork != null).toList();
      emit(PokemonsLoaded(pokemons: allPokemons, hasReachedMax: hasReachedMax));
    } on DioError catch (e, s) {

      emit(PokemonsFailure(
          errorText:
              DioExceptions.fromDioError(e).message ?? 'Something went wrong'));
    } catch (e, s) {

      emit(PokemonsFailure(errorText: e.toString()));
    }
  }

  Future<void> _onPokemonsRefreshed(
      PokemonsRefreshed event, Emitter<PokemonStates> emit) async {
    emit(PokemonsLoading());
    try {
      int currentOffset = _fetchOffset;
      int currentLimit = _fetchLimit;
      bool hasReachedMax = false;
      allLoadedPokemons.clear();

      List<DataEntity> pokemons = await _useCase.call(offset: currentOffset, limit: currentLimit);

      List<PokemonInfoEntity> pokemonsWithData = [];
      for (DataEntity data in pokemons) {
        PokemonInfoEntity pokemonWithData =
        await _useCase.coreDataRequest(name: data.name);

        Color? prominentColor;
        if(pokemonWithData.sprites?.artWork != null) {
          PaletteGenerator paletteGenerator = await PaletteGenerator
              .fromImageProvider(
              NetworkImage(pokemonWithData.sprites!.artWork!));
          prominentColor = paletteGenerator.dominantColor?.color ;
        }
        else{
          prominentColor = Colors.grey;
        }

        List<PokemonInfoEntity> variants = [];
        for (DataEntity variant in pokemonWithData.variants ?? []) {
          try {
            PokemonInfoEntity pokemonVariant =
            await _useCase.coreDataRequest(name: variant.name);
            variants.add(pokemonVariant);
          } catch (e) {
            debugPrint(e.toString());
          }
        }

        pokemonsWithData.add(pokemonWithData.copyWith(variantsComplete: variants, color: prominentColor));
        // pokemonsWithData
        //     .add(pokemonWithData.copyWith(variantsComplete: variants));
      }
      List<PokemonInfoEntity> allPokemons = [
        ...allLoadedPokemons,
        ...pokemonsWithData
      ];
      allLoadedPokemons = allPokemons;

      if (pokemons.length < limit) {
        offset = pokemons.length;
        hasReachedMax = true;
      } else {
        offset = currentLimit;
      }

      refreshController.refreshCompleted();

      allPokemons = allPokemons.where((pokemon) => pokemon.sprites?.artWork != null).toList();
      emit(PokemonsLoaded(pokemons: allPokemons, hasReachedMax: hasReachedMax));
    } on DioError catch (e, s) {
      refreshController.refreshFailed();

      emit(PokemonsFailure(
          errorText:
          DioExceptions.fromDioError(e).message ?? 'Something went wrong'));
    } catch (e, s) {
      refreshController.refreshFailed();

      emit(PokemonsFailure(errorText: e.toString()));
    }
  }

  Future<void> _onFetchMorePokemons(
      FetchMorePokemons event, Emitter<PokemonStates> emit) async {
    // emit(PokemonsLoading());
    try {
      int currentOffset = offset;
      int currentLimit = limit;
      bool hasReachedMax = false;

      List<DataEntity> pokemons =
      await _useCase.call(offset: currentOffset, limit: currentLimit);

      List<PokemonInfoEntity> pokemonsWithData = [];
      for (DataEntity data in pokemons) {
        PokemonInfoEntity pokemonWithData =
        await _useCase.coreDataRequest(name: data.name);

        Color? prominentColor;
        if(pokemonWithData.sprites?.artWork != null) {
          PaletteGenerator paletteGenerator = await PaletteGenerator
              .fromImageProvider(
              NetworkImage(pokemonWithData.sprites!.artWork!));
          prominentColor = paletteGenerator.dominantColor?.color ;
        }
        else{
          prominentColor = Colors.grey;
        }
        List<PokemonInfoEntity> variants = [];
        for (DataEntity variant in pokemonWithData.variants ?? []) {
          try {
            PokemonInfoEntity pokemonVariant =
            await _useCase.coreDataRequest(name: variant.name);
            variants.add(pokemonVariant);
          } catch (e) {
            debugPrint(e.toString());
          }
        }

        pokemonsWithData.add(pokemonWithData.copyWith(variantsComplete: variants, color: prominentColor));
      }
      List<PokemonInfoEntity> allPokemons = [
        ...allLoadedPokemons,
        ...pokemonsWithData
      ];
      allLoadedPokemons = allPokemons;

      if (pokemons.length < limit) {
        offset += pokemons.length;
        hasReachedMax = true;
      } else {
        offset += limit;
      }

      // refreshController.loadComplete();
      if(hasReachedMax){
        refreshController.loadNoData();
      }
      else{
        refreshController.loadComplete();
      }

      allPokemons = allPokemons.where((pokemon) => pokemon.sprites?.artWork != null).toList();
      emit(PokemonsLoaded(pokemons: allPokemons, hasReachedMax: hasReachedMax));
    } on DioError catch (e, s) {
      refreshController.loadFailed();

      emit(PokemonsFailure(
          errorText:
          DioExceptions.fromDioError(e).message ?? 'Something went wrong'));
    } catch (e, s) {
      refreshController.loadFailed();

      emit(PokemonsFailure(errorText: e.toString()));
    }
  }
}
