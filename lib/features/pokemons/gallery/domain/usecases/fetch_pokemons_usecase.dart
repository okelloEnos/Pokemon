import '../../../../features_barrel.dart';

class FetchAllPokemonUseCase {
  final GalleryRepository _repository;

  FetchAllPokemonUseCase({required GalleryRepository repository}) : _repository = repository;

  Future<List<DataEntity>> call({required int offset, required int limit}) async {
    return await _repository.retrieveAllPokemons(offset: offset, limit: limit);
  }
}