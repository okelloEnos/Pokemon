import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon/pokemons/bloc/pokemon_bloc.dart';
import 'package:pokemon/pokemons/bloc/pokemon_bloc_util.dart';
import 'package:pokemon/pokemons/data/models/pokemon_info.dart';
import 'package:pokemon/pokemons/data/repository/pokemon_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
// import '../../helpers/hydrated_bloc.dart';

class MockPokemonRepository extends Mock implements PokemonRepository{}

class MockPokemonInfo extends Mock implements PokemonInfo {}

const pokemonName = "janda";
const pokemonUrl = "https://panda";
const pokemonWeight = 56;
const pokemonHeight = 7;
const sprites = Sprites(home: pokemonUrl);
const List<Abilities>abilities = [];
const List<Stats>stats = [];
const List<Moves>moves = [];


void main(){
  group("pokemons bloc", (){
    late PokemonRepository pokemonRepository;
    late PokemonInfo pokemonInfo;
    List<PokemonInfo> pokemons = [];

    setUp(() {
      pokemonInfo = MockPokemonInfo();
      pokemonRepository = MockPokemonRepository();

      when(() => pokemonInfo.pokemonName).thenReturn(pokemonName);
      when(() => pokemonInfo.pokemonHeight).thenReturn(pokemonHeight);
      when(() => pokemonInfo.pokemonWeight).thenReturn(pokemonWeight);
      when(() => pokemonRepository.retrievePokemonsWithTheirData(any()))
      .thenAnswer((_) async{
        pokemons.add(pokemonInfo);
        return pokemons;
      });
    });

    test("Initial State of pokemons", (){
      final pokemonBloc = PokemonsBloc(pokemonRepository: pokemonRepository);
      expect(pokemonBloc.state, PokemonsInitial());
    });

    group("fetch pokemons", () {
      blocTest<PokemonsBloc, PokemonStates>(
      "Get pokemons...", build: () => PokemonsBloc(pokemonRepository: pokemonRepository),
      act: (bloc) => bloc.pokemonRepository.retrievePokemonsWithTheirData([]),
      verify: (_){
        verify(() => pokemonRepository.retrievePokemonsWithTheirData([])).called(1);
      }
      );
    });

  });
}