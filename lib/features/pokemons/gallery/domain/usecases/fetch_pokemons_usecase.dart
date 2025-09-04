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

  Future<MovesEntity> moveDataRequest({required String? url}) async {
    return await _repository.retrieveMovesData(url: url);
  }

  Future<List<DataEntity>> evolutionDataRequest({required int offset, required int limit}) async {
    return await _repository.retrieveAllPokemons(offset: offset, limit: limit);
  }
}