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
}
