// import '../../../../features_barrel.dart';
//
// class PokemonRepository implements InterfaceRepository{
// final DataService dataService;
//
// PokemonRepository({required this.dataService});
//
//   @override
//   Future<List<PokemonModel>> retrieveAllPokemons({required int offset, required int limit}) async{
//
//     return  await dataService.retrievePokemons(offset: offset, limit: limit);
//   }
//
//   @override
//   Future<List<PokemonInfo>> retrievePokemonsWithTheirData(List<PokemonModel> pokemons) async{
//
//     return await dataService.retrievePokemonsData(pokemons);
//   }
//
// }