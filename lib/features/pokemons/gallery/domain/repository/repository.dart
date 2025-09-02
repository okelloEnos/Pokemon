import '../../../../features_barrel.dart';

abstract class GalleryRepository {
  Future<List<DataEntity>> retrieveAllPokemons(
      {required int offset, required int limit});

  Future<PokemonInfoEntity> retrievePokemonsWithTheirData(
      {required String? name});
}
