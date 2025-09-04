import '../../../../features_barrel.dart';

abstract class GalleryRepository {
  Future<List<DataEntity>> retrieveAllPokemons(
      {required int offset, required int limit});

  // Future<PokemonInfoEntity> retrievePokemonsWithTheirData(
  //     {required String? name});

  Future<PokemonInfoEntity> retrievePokemonsWithTheirData(
      {required String? name});

  Future<dynamic> retrieveFormData({required String? url});

  Future<SpeciesEntity> retrieveSpeciesData({required String? url});

  Future<MovesEntity> retrieveMovesData({required String? url});

  Future<EvolutionEntity> retrieveEvolutionData({required String? url});
}
