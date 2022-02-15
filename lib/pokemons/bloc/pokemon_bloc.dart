import 'package:bloc/bloc.dart';
import 'package:pokemon/pokemons/bloc/pokemon_bloc_util.dart';
import 'package:pokemon/pokemons/data/models/pokemon_model_util.dart';
import 'package:pokemon/pokemons/data/repository/pokemon_repository.dart';


class PokemonsBloc extends Bloc<PokemonEvents, PokemonStates>{
  final PokemonRepository pokemonRepository;

  PokemonsBloc({required this.pokemonRepository}) : super(PokemonsInitial()){
    on<PokemonsFetched>(_onPokemonsFetched);
  }
  
  Future<void> _onPokemonsFetched(PokemonEvents event, Emitter<PokemonStates> emit) async{
    if(state is PokemonsInitial){

      try{
        List<PokemonModel> pokemons = await pokemonRepository.retrieveAllPokemons();
        List<PokemonInfo> pokemonsWithData = await pokemonRepository.retrievePokemonsWithTheirData(pokemons);
        emit(PokemonsLoaded(pokemons: pokemonsWithData));
      }
      catch (e){
        emit(PokemonsFailure(errorText: 'Failed to get Pokemons'));
      }

    }
  }
}