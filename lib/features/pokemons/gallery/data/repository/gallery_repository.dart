import '../../../../../core/core_barrel.dart';
import '../../../../features_barrel.dart';

class GalleryRepositoryImpl implements GalleryRepository {
  final GalleryRemoteDataSource _remoteDataSource;

  GalleryRepositoryImpl({required GalleryRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<DataModel>> retrieveAllPokemons(
      {required int offset, required int limit}) async {
    var data =
        await _remoteDataSource.retrievePokemons(offset: offset, limit: limit);
    List<DataModel> pokemons = List.from(data)
        .map((mappedData) => DataModel.fromJson(mappedData))
        .toList();
    return pokemons;
  }

  @override
  Future<PokemonInfoModel> retrievePokemonsWithTheirData(
      {required String? name}) async {
    var infoData = await _remoteDataSource.retrievePokemonsData(name: name);

    PokemonInfoModel pokemonInfo = PokemonInfoModel.fromJson(infoData);

    return pokemonInfo;
  }

  @override
  Future<dynamic> retrieveFormData({required String? name}) async {
    var formData = await _remoteDataSource.retrieveFormData(name: name);
    return formData;
  }

  @override
  Future<DataModel> retrieveSpeciesData({required String? name}) async {
    var speciesData = await _remoteDataSource.retrieveSpeciesData(name: name);
    DataModel species = DataModel.fromJson(speciesData);
    return species;
  }

  @override
  Future<MovesModel> retrieveMovesData({required String? url}) async {
    var movesData = await _remoteDataSource.retrieveMovesData(url: url);
    MovesModel move = MovesModel.fromJson(movesData);
    return move;
  }

  @override
  Future<DataModel> retrieveEvolutionData({required String? name}) async {
    var evolutionData = await _remoteDataSource.retrieveEvolutionData(name: name);
    DataModel evolution = DataModel.fromJson(evolutionData);
    return evolution;
  }

}
