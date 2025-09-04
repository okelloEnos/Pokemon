import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokemon/features/pokemons/pokemons_barrel.dart';

import '../../../../features_barrel.dart';

part 'pokemon_evolution_event.dart';
part 'pokemon_evolution_state.dart';

class PokemonEvolutionBloc extends Bloc<PokemonEvolutionEvent, PokemonEvolutionState> {
  final FetchAllPokemonUseCase _useCase;
  PokemonEvolutionBloc({required FetchAllPokemonUseCase useCase}) : _useCase = useCase, super(PokemonEvolutionInitial()) {
    on<FetchEvolutionChainEvent>(_onFetchEvolutionChainEvent);
  }

  Future<void> _onFetchEvolutionChainEvent(FetchEvolutionChainEvent event, Emitter<PokemonEvolutionState> emit) async {
    emit(PokemonEvolutionLoading());
    try {
      List<EvolutionPokemonEntity> pokemonsEvolution = [];
      String? url = event.evolutionChain?.url;
      url = "https://pokeapi.co/api/v2/evolution-chain/10/";
      EvolutionEntity evolutionChain = await _useCase.evolutionDataRequest(url: url);
      // evolutionChain = evolutionChain.copyWith(evolveSpeciesFrom: event.evolvesFrom);
      ChainEntity? pokemonChain = evolutionChain.chain;

      while (pokemonChain != null) {
        String? name = pokemonChain.species?.name;
        bool? isBaby = pokemonChain.isBaby;
        bool? isLast = pokemonChain.evolvesTo == null || (pokemonChain.evolvesTo?.isEmpty ?? true);
        PokemonInfoEntity pokemonWithData = await _useCase.coreDataRequest(name: name);
        String image = pokemonWithData.sprites?.artWork ?? "";
        EvolutionPokemonEntity evolutionPokemon = EvolutionPokemonEntity(
          name: name,
          imageUrl: image,
          isBaby: isBaby,
          isLast: isLast,
        );
        pokemonsEvolution.add(evolutionPokemon);

        if(pokemonChain.evolvesTo != null && (pokemonChain.evolvesTo?.isNotEmpty ?? false)){
          pokemonChain = pokemonChain.evolvesTo?.first;
        }
        else{
          pokemonChain = null;
        }
      }

      emit(PokemonEvolutionLoaded(evolution: pokemonsEvolution));
    } catch (e, s) {
      emit(PokemonEvolutionError(message: e.toString()));
    }
  }
}
