import 'package:equatable/equatable.dart';

class PokemonModel extends Equatable {
  final String? pokemonName;
   final String? pokemonUrl;

  const PokemonModel({this.pokemonName, this.pokemonUrl});

  // PokemonModel.fromJson(Map<String, dynamic> json){
  //   PokemonModel(
  //     pokemonName: json["name"],
  //     pokemonUrl: json["url"]
  //   );
  // }
  @override
  List<Object> get props {
    return [pokemonName ?? "", pokemonUrl ?? ""];
  }
}
