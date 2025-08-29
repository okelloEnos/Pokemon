import 'package:pokemon/features/pokemons/gallery/domain/entities/pokemon_entity.dart';
import 'package:pokemon/features/pokemons/gallery/domain/repository/repository.dart';

class FetchAllPokemonUseCase {
  final GalleryRepository _repository;

  FetchAllPokemonUseCase({required GalleryRepository repository}) : _repository = repository;

  Future<List<PokemonEntity>> call({required int offset, required int limit}) async {
    return await _repository.fetchAllPokemons(offset: offset, limit: limit);
  }
}