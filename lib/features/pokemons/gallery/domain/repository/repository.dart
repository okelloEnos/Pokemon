import '../../../../features_barrel.dart';

abstract class GalleryRepository {
  Future<List<DataEntity>> retrieveAllPokemons(
      {required int offset, required int limit});

  Future<PokemonInfoEntity> retrievePokemonsWithTheirData(
      {required String? name});

  Future<dynamic> retrieveFormData({required String? name});

  Future<DataEntity> retrieveSpeciesData({required String? name});

  Future<MovesEntity> retrieveMovesData({required String? url});

  Future<DataEntity> retrieveEvolutionData({required String? name});
}
