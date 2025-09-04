import '../../../../features_barrel.dart';

class FetchAllPokemonUseCase {
  final GalleryRepository _repository;

  FetchAllPokemonUseCase({required GalleryRepository repository}) : _repository = repository;

  Future<List<DataEntity>> call({required int offset, required int limit}) async {
    return await _repository.retrieveAllPokemons(offset: offset, limit: limit);
  }

  Future<List<DataEntity>> formDataRequest({required int offset, required int limit}) async {
    return await _repository.retrieveAllPokemons(offset: offset, limit: limit);
  }

  Future<List<DataEntity>> speciesDataRequest({required int offset, required int limit}) async {
    return await _repository.retrieveAllPokemons(offset: offset, limit: limit);
  }

  /// clean
  Future<MovesEntity> moveDataRequest({required String? url}) async {
    return await _repository.retrieveMovesData(url: url);
  }

  Future<EvolutionEntity> evolutionDataRequest({required String? url}) async {
    return await _repository.retrieveEvolutionData(url: url);
  }

  Future<PokemonInfoEntity> coreDataRequest({required String? name}) async {
    return await _repository.retrievePokemonsWithTheirData(name: name);
  }
}