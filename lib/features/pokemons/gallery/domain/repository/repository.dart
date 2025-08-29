import 'package:pokemon/features/pokemons/gallery/domain/entities/pokemon_entity.dart';

abstract class GalleryRepository {
  Future<List<PokemonEntity>> fetchAllPokemons({required int offset, required int limit});
}