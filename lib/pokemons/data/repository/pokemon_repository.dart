import 'package:pokemon/pokemons/data/data_service/data_service_provider.dart';
import 'package:pokemon/pokemons/data/models/pokemon_model.dart';
import 'package:pokemon/pokemons/data/repository/interface_repository.dart';

class PokemonRepository implements InterfaceRepository{
final DataService dataService;

PokemonRepository({required this.dataService});

  @override
  Future<List<PokemonModel>> retrieveAllPokemons() async{

    return  await dataService.retrievePokemons();
  }

}