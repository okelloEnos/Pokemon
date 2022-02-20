import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pokemon/pokemons/data/models/pokemon_model_util.dart';
import 'package:pokemon/util/dio_exceptions.dart';


class DataService {

  final String baseUrl = "https://pokeapi.co/api/v2/pokemon?offset=0&limit=10";
  final Dio dio;

  DataService({required this.dio});

  Future<List<PokemonModel>> retrievePokemons() async {
    List<PokemonModel> pokemons = [];

    try {
      dio.interceptors.add(InterceptorsWrapper(
          onRequest:(options, handler){
            // Do something before request is sent
            return handler.next(options); //continue
            // If you want to resolve the request with some custom data，
            // you can resolve a `Response` object eg: `handler.resolve(response)`.
            // If you want to reject the request with a error message,
            // you can reject a `DioError` object eg: `handler.reject(dioError)`
          },
          onResponse:(response,handler) {
            // Do something with response data
            return handler.next(response); // continue
            // If you want to reject the request with a error message,
            // you can reject a `DioError` object eg: `handler.reject(dioError)`
          },
          onError: (DioError e, handler) {
            // Do something with response error
            return  handler.next(e);//continue
            // If you want to resolve the request with some custom data，
            // you can resolve a `Response` object eg: `handler.resolve(response)`.
          }
      ));
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
      throw DioExceptions.fromDioError(e);
    }
    on SocketException catch (e){
      throw Exception("Hey, Server is Down");
    }
    on FormatException catch (e){
      throw Exception("Hey, We cannot Handle the Format");
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

        List<Abilities> abilities = List.from(data["abilities"]).map((abilitiesMap) {
          var abilityMap = abilitiesMap["ability"];
          var ability = Ability(name: abilityMap["name"], url: abilityMap["url"]);
          return Abilities(
              isHidden: abilitiesMap["is_hidden"], slot: abilitiesMap["slot"], ability: ability);
        }).toList();

        List<Moves> moves = List.from(data["moves"]).map((movesMap) {
          var moveMap = movesMap["move"];
          var move = Move(name: moveMap["name"], url: moveMap["url"]);
          return Moves(
              move: move);
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
            abilities: abilities,
            // forms: data[],
            // gameIndices: data[],
            moves: moves,
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