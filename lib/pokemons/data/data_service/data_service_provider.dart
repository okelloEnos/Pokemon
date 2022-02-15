import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:pokemon/pokemons/data/models/pokemon_model_util.dart';


class DataService {

  final String baseUrl = "https://pokeapi.co/api/v2/pokemon?offset=0&limit=10";
  final Dio dio;

  DataService({required this.dio});

  Future<List<PokemonModel>> retrievePokemons() async {
    List<PokemonModel> pokemons = [];

    try {
      final response = await dio.get(baseUrl);

      if (response.statusCode == 200) {
        print(response.data);
        print('Next Url : ${response.data["next"]}');

        pokemons = List.from(response.data["results"]).map((pokemonJson) =>
            PokemonModel(
                pokemonName: pokemonJson["name"],
                pokemonUrl: pokemonJson["url"]
            )).toList();
      }
      else {
        throw Exception('Pokemons not received');
      }
    }
    on DioError catch (e) {
      throw Exception(e);
    }

    return pokemons;
  }

  Future<List<PokemonInfo>> retrievePokemonsData(List<PokemonModel> pokemons) async {
    List<PokemonInfo> pokemonsInfo = [];

    for (PokemonModel pokemonModel in pokemons) {
      var pokemonDataResponse = await dio.get(pokemonModel.pokemonUrl!);

      if (pokemonDataResponse.statusCode == 200) {
        var data = pokemonDataResponse.data;



        Species species = Species(name: data["species"]["name"], url: data["species"]["url"]);

        var spritesMap = data["sprites"];
        Sprites sprites = Sprites(backDefault: spritesMap["back_default"], frontDefault: spritesMap["front_default"],
        dreamWorld: spritesMap["other"]["dream_world"]["front_default"],home: spritesMap["other"]["home"]["front_default"],
            artWork: spritesMap["other"]["official-artwork"]["front_default"]);

        List<Stats> stats = List.from(data["stats"]).map((statsMap) {
          var statMap = statsMap["stat"];
          var stat = Stat(name: statMap["name"], url: statMap["url"]);
          return Stats(
              baseStat: statsMap["base_stat"], effort: statsMap["effort"], stat: stat);
        }).toList();

        List<PokemonTypes> types = List.from(data["types"]).map((pokemonTypes) {
          var type = pokemonTypes["type"];
          var pokemonType = PokemonType(name: type["name"], url: type["url"]);
          return PokemonTypes(
              slot: pokemonTypes["slot"], pokemonType: pokemonType);
        }).toList();
        var pokemonData = PokemonInfo(
            pokemonName: data["name"],
            baseExperience: data["base_experience"],
            pokemonHeight: data["height"],
            pokemonWeight: data["weight"],
            // abilities: data[],
            // forms: data[],
            // gameIndices: data[],
            // moves: data[],
            species: species,
            sprites: sprites,
            stats: stats,
            types: types
        );

        pokemonsInfo.add(pokemonData);
      }
    }

    return pokemonsInfo;
  }
}