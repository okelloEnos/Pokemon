import '../../../../features_barrel.dart';

class GalleryRepositoryImpl implements GalleryRepository {
  final GalleryRemoteDataSource _remoteDataSource;

  GalleryRepositoryImpl({required GalleryRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<DataModel>> retrieveAllPokemons(
      {required int offset, required int limit}) async {
    return await _remoteDataSource.retrievePokemons(
        offset: offset, limit: limit);
  }

  @override
  Future<PokemonInfoModel> retrievePokemonsWithTheirData(
      {required DataEntity pokemon}) async {
    var infoData = await _remoteDataSource.retrievePokemonsData(
        pokemon: DataModel.fromEntity(entity: pokemon));
    return PokemonInfoModel.fromJson(infoData);
  }
}
