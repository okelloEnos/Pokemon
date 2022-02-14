import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:pokemon/pokemons/data/models/pokemon_model.dart';

class DataService{

  final String baseUrl = "https://pokeapi.co/api/v2/pokemon?offset=0&limit=10";
  final Dio dio;

  DataService({required this.dio});

  Future<List<PokemonModel>> retrievePokemons() async{
    List<PokemonModel> pokemons = [];

    try{

      final response = await dio.get(baseUrl);

      if(response.statusCode == 200){

        print(response.data);
        print('Next Url : ${response.data["next"]}');

        pokemons = List.from(response.data["results"]).map((pokemonJson) => PokemonModel(
            pokemonName: pokemonJson["name"],
            pokemonUrl: pokemonJson["url"]
        )).toList();

      }
      else {
        throw Exception('Pokemons not received');
      }

    }
    on DioError catch (e){
      throw Exception(e);
    }

    return pokemons;
  }
}