import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../../core/core_barrel.dart';
import '../../../../features_barrel.dart';

abstract class GalleryRemoteDataSource {
  Future<dynamic> retrievePokemons({required int offset, required int limit});

  Future<dynamic> retrievePokemonsData({required String? name});

  Future<dynamic> retrieveFormData({required String? url});

  Future<dynamic> retrieveSpeciesData({required String? url});

  Future<dynamic> retrieveMovesData({required String? url});

  Future<dynamic> retrieveEvolutionData({required String? url});
}

class GalleryRemoteDataSourceImpl implements GalleryRemoteDataSource {
  final Dio _dio;

  const GalleryRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<dynamic> retrievePokemons(
      {required int offset, required int limit}) async {
    var url = "$baseUrl/pokemon?offset=$offset&limit=$limit";

    final response = await _dio.get(url);

    if (response.statusCode == 200) {
      return response.data["results"];
    } else {
      throw Exception('Pokemons not received');
    }
  }

  // @override
  // Future<dynamic> retrievePokemonsData({required String? name}) async {
  //   if (name == null) throw (Exception("Pokemon url is null"));
  //
  //   var coreDataBaseUrl = "$baseUrl/pokemon/$name";
  //   var speciesBaseUrl = "$baseUrl/pokemon-species/$name";
  //   var formBaseUrl = "$baseUrl/pokemon-form/$name";
  //
  //   final results = await Future.wait([
  //     _dio.get(coreDataBaseUrl),
  //     _dio.get(speciesBaseUrl, options: Options(
  //       validateStatus: (s) => s != null && (s == 404 || (s >= 200 && s < 300)),
  //     )),
  //     _dio.get(formBaseUrl),
  //   ]);
  //   debugPrint("${[
  //     results[0].statusCode,
  //     results[1].statusCode,
  //     results[2].statusCode
  //   ]}");
  //
  //   if (results[0].statusCode == 200 &&
  //       (results[1].statusCode == 200 || results[1].statusCode == 404) &&
  //       results[2].statusCode == 200) {
  //     var coreData = results[0].data;
  //     Map<String, dynamic> speciesData = results[1].statusCode == 404 ? {} : results[1].data;
  //     var formData = results[2].data;
  //
  //     final description = latestEnglishDescription(speciesData);
  //     final genera = latestEnglishGenera(speciesData);
  //     coreData['description'] = description;
  //     coreData['genus'] = genera;
  //     coreData['base_happiness'] = speciesData['base_happiness'];
  //     coreData['capture_rate'] = speciesData['capture_rate'];
  //     coreData['hatch_counter'] = speciesData['hatch_counter'];
  //     coreData['gender_rate'] = speciesData['gender_rate'];
  //     coreData['habitat'] = speciesData['habitat']?['name'];
  //     coreData['growth_rate'] = speciesData['growth_rate']?['name'];
  //     coreData['egg_groups'] = speciesData['egg_groups'];
  //     coreData['evolves_from'] = speciesData['evolves_from'];
  //     coreData['evolution_chain'] = speciesData['evolution_chain'];
  //
  //     if(speciesData['varieties'] != null) {
  //       if(disableSlider){
  //         coreData['variants'] = speciesData['varieties']
  //         .where((variety) => variety['is_default'] == false)
  //             .map((variety) => variety['pokemon'])
  //             .toList();
  //       }
  //       else{
  //         coreData['variants'] = speciesData['varieties']
  //         // .where((variety) => variety['is_default'] == false)
  //             .map((variety) => variety['pokemon'])
  //             .toList();
  //       }
  //
  //     }
  //
  //     return coreData;
  //   } else {
  //     throw Exception('Pokemon data not received');
  //   }
  // }

  @override
  Future<dynamic> retrievePokemonsData({required String? name}) async {
    if (name == null) throw (Exception("Pokemon url is null"));

    var coreDataBaseUrl = "$baseUrl/pokemon/$name";
    var speciesBaseUrl = "$baseUrl/pokemon-species/$name";
    var formBaseUrl = "$baseUrl/pokemon-form/$name";

    final results = await Future.wait([
      _dio.get(coreDataBaseUrl),
      _dio.get(speciesBaseUrl,
          options: Options(
            validateStatus: (s) =>
                s != null && (s == 404 || (s >= 200 && s < 300)),
          )),
      _dio.get(formBaseUrl),
    ]);
    debugPrint("${[
      results[0].statusCode,
      results[1].statusCode,
      results[2].statusCode
    ]}");

    if (results[0].statusCode == 200 &&
        (results[1].statusCode == 200 || results[1].statusCode == 404) &&
        results[2].statusCode == 200) {
      var coreData = results[0].data;
      Map<String, dynamic> speciesData =
          results[1].statusCode == 404 ? {} : results[1].data;
      var formData = results[2].data;

      final description = latestEnglishDescription(speciesData);
      final genera = latestEnglishGenera(speciesData);
      coreData['description'] = description;
      coreData['genus'] = genera;
      coreData['base_happiness'] = speciesData['base_happiness'];
      coreData['capture_rate'] = speciesData['capture_rate'];
      coreData['hatch_counter'] = speciesData['hatch_counter'];
      coreData['gender_rate'] = speciesData['gender_rate'];
      coreData['habitat'] = speciesData['habitat']?['name'];
      coreData['growth_rate'] = speciesData['growth_rate']?['name'];
      coreData['egg_groups'] = speciesData['egg_groups'];
      coreData['evolves_from'] = speciesData['evolves_from'];
      coreData['evolution_chain'] = speciesData['evolution_chain'];

      if (speciesData['varieties'] != null) {
        if (disableSlider) {
          coreData['variants'] = speciesData['varieties']
              .where((variety) => variety['is_default'] == false)
              .map((variety) => variety['pokemon'])
              .toList();
        } else {
          coreData['variants'] = speciesData['varieties']
              // .where((variety) => variety['is_default'] == false)
              .map((variety) => variety['pokemon'])
              .toList();
        }
      }

      return coreData;
    } else {
      throw Exception('Pokemon data not received');
    }
  }

  @override
  Future<dynamic> retrieveFormData({required String? url}) async {
    if (url == null) throw (Exception("Form url is null"));

    final results = await _dio.get(url);

    if (results.statusCode == 200) {
      var formData = results.data;

      return formData;
    } else {
      throw Exception('Form data not received');
    }
  }

  @override
  Future<dynamic> retrieveSpeciesData({required String? url}) async {
    if (url == null) throw (Exception("Species url is null"));

    final results = await _dio.get(url);

    if (results.statusCode == 200) {
      var speciesData = results.data;

      return speciesData;
    } else {
      throw Exception('Species data not received');
    }
  }

  @override
  Future<dynamic> retrieveMovesData({required String? url}) async {
    if (url == null) throw (Exception("Moves url is null"));

    final results = await _dio.get(url);

    if (results.statusCode == 200) {
      var moveData = results.data;

      return moveData;
    } else {
      throw Exception('Move data not received');
    }
  }

  @override
  Future<dynamic> retrieveEvolutionData({required String? url}) async {
    if (url == null) throw (Exception("Evolution url is null"));

    final results = await _dio.get(url);

    if (results.statusCode == 200) {
      var evolutionData = results.data;

      return evolutionData;
    } else {
      throw Exception('Evolution data not received');
    }
  }
}
