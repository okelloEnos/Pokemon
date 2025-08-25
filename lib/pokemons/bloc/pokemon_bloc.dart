import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/pokemons/bloc/pokemon_bloc_util.dart';
import 'package:pokemon/pokemons/data/models/pokemon_model_util.dart';
import 'package:pokemon/pokemons/data/repository/pokemon_repository.dart';


class PokemonsBloc extends Bloc<PokemonEvents, PokemonStates>{
  final PokemonRepository pokemonRepository;
  final ScrollController scrollController = ScrollController();

  List<PokemonInfo> allLoadedPokemons = [];
  int limit = 10;
  int offset = 0;

  PokemonsBloc({required this.pokemonRepository}) : super(PokemonsInitial()){
    scrollController.addListener(() {
      if(scrollController.offset >= scrollController.position.maxScrollExtent && !scrollController.position.outOfRange){
        if(state is PokemonsLoaded){
          add(PokemonsFetched());
        }
      }

      if(scrollController.offset <= scrollController.position.minScrollExtent && !scrollController.position.outOfRange){
        print("at the top");
      }
    });
    on<PokemonsFetched>(_onPokemonsFetched);
  }
  
  Future<void> _onPokemonsFetched(PokemonEvents event, Emitter<PokemonStates> emit) async{
      try{
        int currentOffset = offset;
        int currentLimit = limit;
        bool hasReachedMax = false;
        List<PokemonModel> pokemons = await pokemonRepository.retrieveAllPokemons(offset: currentOffset, limit: currentLimit);
        // if offset == 30 from pokemons reduce 3 pokemons
        if(offset == 30){
          pokemons = pokemons.sublist(0, pokemons.length - 3);
        }
        List<PokemonInfo> pokemonsWithData = await pokemonRepository.retrievePokemonsWithTheirData(pokemons);
        List<PokemonInfo> allPokemons = [...allLoadedPokemons, ...pokemonsWithData];
        allLoadedPokemons = allPokemons;

        // if(pokemons.isNotEmpty){
          if(pokemons.length < limit){
            offset += pokemons.length;
            hasReachedMax = true;
          } else {
            offset += limit;
          }
        // }

        emit(PokemonsLoaded(pokemons: allPokemons, hasReachedMax: hasReachedMax));
      }
      catch (e){
        emit(PokemonsFailure(errorText: e.toString()));
      }
  }
}