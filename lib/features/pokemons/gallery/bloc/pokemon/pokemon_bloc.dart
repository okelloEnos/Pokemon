import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:pokemon/core/core_barrel.dart';
import 'package:pokemon/features/pokemons/gallery/domain/domain_barrel.dart';
import '../../../../features_barrel.dart';
import 'package:dio/dio.dart';

part 'pokemon_events.dart';

part 'pokemon_states.dart';

class PokemonsBloc extends Bloc<PokemonEvents, PokemonStates> {
  // final GalleryRepository pokemonRepository;
  final FetchAllPokemonUseCase _useCase;
  final ScrollController scrollController = ScrollController();

  List<PokemonInfoEntity> allLoadedPokemons = [];
  int limit = 10;
  int offset = 0;

  PokemonsBloc({required FetchAllPokemonUseCase useCase})
      : _useCase = useCase,
        super(PokemonsInitial()) {
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        if (state is PokemonsLoaded) {
          add(PokemonsFetched());
        }
      }

      if (scrollController.offset <=
              scrollController.position.minScrollExtent &&
          !scrollController.position.outOfRange) {
        debugPrint("at the top");
      }
    });
    on<PokemonsFetched>(_onPokemonsFetched);
  }

  Future<void> _onPokemonsFetched(
      PokemonEvents event, Emitter<PokemonStates> emit) async {
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

        // final PaletteGenerator paletteGenerator = await PaletteGenerator.fromImageProvider(NetworkImage(pokemonWithData.sprites!.artWork!));

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

        // pokemonsWithData.add(pokemonWithData.copyWith(variantsComplete: variants, color: paletteGenerator.lightVibrantColor?.color ?? Colors.grey));
        pokemonsWithData
            .add(pokemonWithData.copyWith(variantsComplete: variants));
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

      emit(PokemonsLoaded(pokemons: allPokemons, hasReachedMax: hasReachedMax));
    } on DioError catch (e) {
      emit(PokemonsFailure(
          errorText:
              DioExceptions.fromDioError(e).message ?? 'Something went wrong'));
    } catch (e, s) {
      emit(PokemonsFailure(errorText: e.toString()));
    }
  }
}
