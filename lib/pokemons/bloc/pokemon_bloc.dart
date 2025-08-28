import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/pokemons/bloc/pokemon_bloc_util.dart';
import 'package:pokemon/pokemons/data/models/pokemon_model_util.dart';
import 'package:pokemon/pokemons/data/repository/pokemon_hydrator.dart';
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
    final hydrator = PokemonHydrator();
      try{
        int currentOffset = offset;
        int currentLimit = limit;
        bool hasReachedMax = false;
        List<PokemonModel> pokemons = await pokemonRepository.retrieveAllPokemons(offset: currentOffset, limit: currentLimit);
        // for(var pokemon in pokemons){
        //   // All details (moves can be heavy; cap with maxMovesToHydrate: 50 during dev)
        //   final full = await hydrator.hydrate('pikachu');
        //
        //   print(full.pokemon['name']);           // "pikachu"
        //   print(full.englishGenus);              // e.g., "Mouse Pokémon"
        //   print(full.englishFlavor);             // Recent English flavor text
        //   print(full.typeDetails.length);        // Type resources (e.g., electric)
        //   print(full.abilityDetails.length);     // Ability resources
        //   print(full.moveDetails.length);        // All move resources (if not capped)
        //   print(full.encounters.length);         // Encounter locations
        //   print(full.evolutionChain?['id']);
        // }
        List<PokemonInfo> pokemonsWithData = await pokemonRepository.retrievePokemonsWithTheirData(pokemons);
        List<PokemonInfo> allPokemons = [...allLoadedPokemons, ...pokemonsWithData];
        allLoadedPokemons = allPokemons;

          if(pokemons.length < limit){
            offset += pokemons.length;
            hasReachedMax = true;
          } else {
            offset += limit;
          }

        emit(PokemonsLoaded(pokemons: allPokemons, hasReachedMax: hasReachedMax));
      }
      catch (e){
        emit(PokemonsFailure(errorText: e.toString()));
      }
  }
}