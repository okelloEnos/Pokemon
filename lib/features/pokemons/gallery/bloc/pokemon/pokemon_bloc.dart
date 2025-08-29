import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../features_barrel.dart';

part 'pokemon_events.dart';
part 'pokemon_states.dart';

class PokemonsBloc extends Bloc<PokemonEvents, PokemonStates>{
  final GalleryRepository pokemonRepository;
  final ScrollController scrollController = ScrollController();

  List<PokemonInfoEntity> allLoadedPokemons = [];
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
        debugPrint("at the top");
      }
    });
    on<PokemonsFetched>(_onPokemonsFetched);
  }
  
  Future<void> _onPokemonsFetched(PokemonEvents event, Emitter<PokemonStates> emit) async{
      try{
        int currentOffset = offset;
        int currentLimit = limit;
        bool hasReachedMax = false;
        List<DataEntity> pokemons = await pokemonRepository.retrieveAllPokemons(offset: currentOffset, limit: currentLimit);
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
        List<PokemonInfoEntity> pokemonsWithData = [];
        for(DataEntity data in pokemons){
          PokemonInfoEntity pokemonWithData = await pokemonRepository.retrievePokemonsWithTheirData(pokemon: data);
          pokemonsWithData.add(pokemonWithData);
        }
        List<PokemonInfoEntity> allPokemons = [...allLoadedPokemons, ...pokemonsWithData];
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