import 'package:pokemon/pokemons/data/data_service/data_service_provider.dart';
import 'package:pokemon/pokemons/data/models/pokemon_info.dart';
import 'package:pokemon/pokemons/data/models/pokemon_model.dart';
import 'package:pokemon/pokemons/data/repository/interface_repository.dart';

class PokemonRepository implements InterfaceRepository{
final DataService dataService;

PokemonRepository({required this.dataService});

  @override
  Future<List<PokemonModel>> retrieveAllPokemons({required int offset, required int limit}) async{

    return  await dataService.retrievePokemons(offset: offset, limit: limit);
  }

  @override
  Future<List<PokemonInfo>> retrievePokemonsWithTheirData(List<PokemonModel> pokemons) async{

    return await dataService.retrievePokemonsData(pokemons);
  }

}