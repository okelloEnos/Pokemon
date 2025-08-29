import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../../core/core_barrel.dart';
import '../../../../features_barrel.dart';

// ignore_for_file: unused_catch_clause
class DataService {

  // final String baseUrl = "https://pokeapi.co/api/v2/pokemon?offset=0&limit=10";
  final String baseUrl = "https://pokeapi.co/api/v2";
  final Dio dio;

  DataService({required this.dio});

  Future<List<PokemonModel>> retrievePokemons({required int offset, required int limit}) async {
    // var url = "$baseUrl/pokemon?offset=$offset&limit=$limit";
    var url = "$baseUrl/pokemon?offset=$offset&limit=$limit";
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
      final response = await dio.get(url);

      if (response.statusCode == 200) {

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

  // Future<List<PokemonInfo>> retrievePokemonsData(List<PokemonModel> pokemons) async {
  //   List<PokemonInfo> pokemonsInfo = [];
  //
  //   for (PokemonModel pokemonModel in pokemons) {
  //     var pokemonDataResponse = await dio.get(pokemonModel.pokemonUrl!);
  //
  //     if (pokemonDataResponse.statusCode == 200) {
  //       var data = pokemonDataResponse.data;
  //
  //
  //
  //       Species species = Species(name: data["species"]["name"], url: data["species"]["url"]);
  //
  //       var spritesMap = data["sprites"];
  //       Sprites sprites = Sprites(backDefault: spritesMap["back_default"], frontDefault: spritesMap["front_default"],
  //       dreamWorld: spritesMap["other"]["dream_world"]["front_default"],home: spritesMap["other"]["home"]["front_default"],
  //           artWork: spritesMap["other"]["official-artwork"]["front_default"]);
  //
  //       List<Stats> stats = List.from(data["stats"]).map((statsMap) {
  //         var statMap = statsMap["stat"];
  //         var stat = Stat(name: statMap["name"], url: statMap["url"]);
  //         return Stats(
  //             baseStat: statsMap["base_stat"], effort: statsMap["effort"], stat: stat);
  //       }).toList();
  //
  //       List<Abilities> abilities = List.from(data["abilities"]).map((abilitiesMap) {
  //         var abilityMap = abilitiesMap["ability"];
  //         var ability = Ability(name: abilityMap["name"], url: abilityMap["url"]);
  //         return Abilities(
  //             isHidden: abilitiesMap["is_hidden"], slot: abilitiesMap["slot"], ability: ability);
  //       }).toList();
  //
  //       List<Moves> moves = List.from(data["moves"]).map((movesMap) {
  //         var moveMap = movesMap["move"];
  //         var move = Move(name: moveMap["name"], url: moveMap["url"]);
  //         return Moves(
  //             move: move);
  //       }).toList();
  //
  //       List<PokemonTypes> types = List.from(data["types"]).map((pokemonTypes) {
  //         var type = pokemonTypes["type"];
  //         var pokemonType = PokemonType(name: type["name"], url: type["url"]);
  //         return PokemonTypes(
  //             slot: pokemonTypes["slot"], pokemonType: pokemonType);
  //       }).toList();
  //       var pokemonData = PokemonInfo(
  //           pokemonName: data["name"],
  //           baseExperience: data["base_experience"],
  //           pokemonHeight: data["height"],
  //           pokemonWeight: data["weight"],
  //           abilities: abilities,
  //           // forms: data[],
  //           // gameIndices: data[],
  //           moves: moves,
  //           species: species,
  //           sprites: sprites,
  //           stats: stats,
  //           types: types
  //       );
  //
  //       pokemonsInfo.add(pokemonData);
  //     }
  //   }
  //
  //   return pokemonsInfo;
  // }

  Future<List<PokemonInfo>> retrievePokemonsData(List<PokemonModel> pokemons) async {
    List<PokemonInfo> pokemonsInfo = [];

    for (PokemonModel pokemonModel in pokemons) {
      var pokemonData = await retrieveOverallData(pokemon: pokemonModel);
      pokemonsInfo.add(pokemonData);
      // var pokemonDataResponse = await dio.get(pokemonModel.pokemonUrl!);
      //
      // if (pokemonDataResponse.statusCode == 200) {
      //   var data = pokemonDataResponse.data;
      //
      //
      //
      //   Species species = Species(name: data["species"]["name"], url: data["species"]["url"]);
      //
      //   var spritesMap = data["sprites"];
      //   Sprites sprites = Sprites(backDefault: spritesMap["back_default"], frontDefault: spritesMap["front_default"],
      //       dreamWorld: spritesMap["other"]["dream_world"]["front_default"],home: spritesMap["other"]["home"]["front_default"],
      //       artWork: spritesMap["other"]["official-artwork"]["front_default"]);
      //
      //   List<Stats> stats = List.from(data["stats"]).map((statsMap) {
      //     var statMap = statsMap["stat"];
      //     var stat = Stat(name: statMap["name"], url: statMap["url"]);
      //     return Stats(
      //         baseStat: statsMap["base_stat"], effort: statsMap["effort"], stat: stat);
      //   }).toList();
      //
      //   List<Abilities> abilities = List.from(data["abilities"]).map((abilitiesMap) {
      //     var abilityMap = abilitiesMap["ability"];
      //     var ability = Ability(name: abilityMap["name"], url: abilityMap["url"]);
      //     return Abilities(
      //         isHidden: abilitiesMap["is_hidden"], slot: abilitiesMap["slot"], ability: ability);
      //   }).toList();
      //
      //   List<Moves> moves = List.from(data["moves"]).map((movesMap) {
      //     var moveMap = movesMap["move"];
      //     var move = Move(name: moveMap["name"], url: moveMap["url"]);
      //     return Moves(
      //         move: move);
      //   }).toList();
      //
      //   List<PokemonTypes> types = List.from(data["types"]).map((pokemonTypes) {
      //     var type = pokemonTypes["type"];
      //     var pokemonType = PokemonType(name: type["name"], url: type["url"]);
      //     return PokemonTypes(
      //         slot: pokemonTypes["slot"], pokemonType: pokemonType);
      //   }).toList();
      //   var pokemonData = PokemonInfo(
      //       pokemonName: data["name"],
      //       baseExperience: data["base_experience"],
      //       pokemonHeight: data["height"],
      //       pokemonWeight: data["weight"],
      //       abilities: abilities,
      //       // forms: data[],
      //       // gameIndices: data[],
      //       moves: moves,
      //       species: species,
      //       sprites: sprites,
      //       stats: stats,
      //       types: types
      //   );
      //
      //   pokemonsInfo.add(pokemonData);
      // }
    }

    return pokemonsInfo;
  }

  Future<PokemonInfo> retrieveOverallData({required PokemonModel pokemon}) async {
    PokemonInfo pokemonInfo = const PokemonInfo();

    final results = await Future.wait([
      dio.get('$baseUrl/pokemon/${pokemon.pokemonName}'),
      dio.get('$baseUrl/pokemon-species/${pokemon.pokemonName}'),
    ]);
    final pokemonData = results[0].data as Map<String, dynamic>;
    final speciesData = results[1].data as Map<String, dynamic>;

    final about = {
      'name': pokemonData['name'],
      'types': (pokemonData['types'] as List).map((t) => t['type']['name']).toList(),
      'height_m': (pokemonData['height'] as num) / 10.0,
      'weight_kg': (pokemonData['weight'] as num) / 10.0,
      'abilities': (pokemonData['abilities'] as List).map((a) => a['ability']['name']).toList(),
      'genus': (speciesData['genera'] as List)
          .firstWhere((g) => g['language']['name'] == 'en', orElse: () => null)?['genus'],
      'description': (speciesData['flavor_text_entries'] as List)
          .firstWhere((f) => f['language']['name'] == 'en', orElse: () => null)?['flavor_text']
          ?.replaceAll('\n', ' ')
          ?.replaceAll('\f', ' '),
      'capture_rate': speciesData['capture_rate'],
      'base_happiness': speciesData['base_happiness'],
      'growth_rate': speciesData['growth_rate']?['name'],
      'egg_groups': (speciesData['egg_groups'] as List).map((e) => e['name']).toList(),
      'gender_rate': speciesData['gender_rate'], // -1 genderless; else female% = *12.5
    };

    return pokemonInfo;
  }


  /// Fetches core + species, then hydrates: evolution chain, encounters,
  /// forms, types, abilities, moves (capped), and held items.
  /// Returns a consolidated map you can feed straight to your UI.
  Future<Map<String, dynamic>> fetchPokemonAboutExtended({
    required Dio dio,
    required String baseUrl,
    required String nameOrId,
    int maxMovesToHydrate = 40,     // cap to avoid 100+ move fetches
    int maxConcurrency = 6,         // be nice to the API
    bool includeEncounters = true,
    bool includeForms = true,
    bool includeLinkedDetails = true, // types, abilities, moves, items
  }) async {
    // 1) Core + Species (your original approach, but in parallel)
    final results = await Future.wait([
      dio.get('$baseUrl/pokemon/$nameOrId'),
      dio.get('$baseUrl/pokemon-species/$nameOrId'),
    ]);

    final pokemonData = (results[0].data as Map).cast<String, dynamic>();
    final speciesData = (results[1].data as Map).cast<String, dynamic>();

    // Helpers
    String? _englishGenus(List list) {
      for (final x in list.reversed.whereType<Map>()) {
        final m = x.cast<String, dynamic>();
        if (m['language']?['name'] == 'en') return m['genus'] as String?;
      }
      return null;
    }

    String? _englishFlavor(List list) {
      for (final x in list.reversed.whereType<Map>()) {
        final m = x.cast<String, dynamic>();
        if (m['language']?['name'] == 'en') {
          final raw = m['flavor_text'] as String?;
          return raw?.replaceAll('\n', ' ').replaceAll('\f', ' ');
        }
      }
      return null;
    }

    double? _toMeters(num? dm) => dm == null ? null : dm / 10.0;
    double? _toKg(num? hg) => hg == null ? null : hg / 10.0;

    Map<String, int> _stats(Map<String, dynamic> p) {
      final res = <String, int>{};
      final stats = p['stats'];
      if (stats is List) {
        for (final s in stats.whereType<Map>()) {
          final m = s.cast<String, dynamic>();
          final name = m['stat']?['name'] as String?;
          final base = m['base_stat'] as int?;
          if (name != null && base != null) res[name] = base;
        }
      }
      return res;
    }

    Map<String, double>? _genderPercent(int? genderRate) {
      if (genderRate == null) return null;
      if (genderRate == -1) return {'genderless': 100.0};
      final female = genderRate * 12.5;
      final male = 100.0 - female;
      return {'male': male, 'female': female};
    }

    String? _officialArtwork(Map<String, dynamic> p) =>
        p['sprites']?['other']?['official-artwork']?['front_default'] as String?;

    List<String> _extractUrls(dynamic list, String? Function(Map m) pick) {
      final urls = <String>[];
      if (list is List) {
        for (final raw in list.whereType<Map>()) {
          final u = pick(raw.cast<String, dynamic>());
          if (u is String && u.isNotEmpty) urls.add(u);
        }
      }
      return urls;
    }

    Future<Map<String, dynamic>?> _getAbs(String url) async {
      try {
        final r = await dio.getUri(Uri.parse(url));
        if (r.statusCode == 200 && r.data is Map) {
          return (r.data as Map).cast<String, dynamic>();
        }
      } catch (_) {/* swallow to keep resilient */}
      return null;
    }

    Future<List<Map<String, dynamic>>> _fetchAllWithLimit(
        List<String> urls, {
          int concurrency = 6,
        }) async {
      if (urls.isEmpty) return const [];
      final it = urls.iterator;
      final results = <Map<String, dynamic>>[];
      Future<void> worker() async {
        while (true) {
          String? next;
          if (it.moveNext()) {
            next = it.current;
          } else {
            break;
          }
          final data = await _getAbs(next);
          if (data != null) results.add(data);
        }
      }
      await Future.wait(List.generate(concurrency, (_) => worker()));
      return results;
    }

    // 2) Evolution Chain (via species)
    Map<String, dynamic>? evolutionChain;
    final evoUrl = speciesData['evolution_chain']?['url'] as String?;
    if (evoUrl != null && evoUrl.isNotEmpty) {
      evolutionChain = await _getAbs(evoUrl);
    }

    // 3) Optional extras (encounters, forms, linked details)
    // Encounters
    List<Map<String, dynamic>> encounters = const [];
    if (includeEncounters) {
      try {
        final r = await dio.get('$baseUrl/pokemon/${pokemonData['id']}/encounters');
        if (r.statusCode == 200 && r.data is List) {
          encounters = (r.data as List)
              .whereType<Map>()
              .map((e) => e.cast<String, dynamic>())
              .toList(growable: false);
        }
      } catch (_) {/* ignore */}
    }

    // Forms
    List<Map<String, dynamic>> forms = const [];
    if (includeForms) {
      final formUrls = _extractUrls(
        pokemonData['forms'],
            (m) => (m['url'] as String?),
      );
      forms = await _fetchAllWithLimit(formUrls, concurrency: maxConcurrency);
    }

    // Linked details: types, abilities, moves (capped), held items
    List<Map<String, dynamic>> typeDetails = const [];
    List<Map<String, dynamic>> abilityDetails = const [];
    List<Map<String, dynamic>> moveDetails = const [];
    List<Map<String, dynamic>> itemDetails = const [];

    if (includeLinkedDetails) {
      final typeUrls = _extractUrls(
        pokemonData['types'],
            (m) => (m['type']?['url'] as String?),
      );

      final abilityUrls = _extractUrls(
        pokemonData['abilities'],
            (m) => (m['ability']?['url'] as String?),
      );

      final moveUrlsAll = _extractUrls(
        pokemonData['moves'],
            (m) => (m['move']?['url'] as String?),
      );

      // Cap move detail hydration (you still have full move refs in pokemonData)
      final moveUrls = moveUrlsAll.take(maxMovesToHydrate).toList();

      final heldItemUrls = _extractUrls(
        pokemonData['held_items'],
            (m) => (m['item']?['url'] as String?),
      );

      final fetched = await Future.wait([
        _fetchAllWithLimit(typeUrls, concurrency: maxConcurrency),
        _fetchAllWithLimit(abilityUrls, concurrency: maxConcurrency),
        _fetchAllWithLimit(moveUrls, concurrency: maxConcurrency),
        _fetchAllWithLimit(heldItemUrls, concurrency: maxConcurrency),
      ]);

      typeDetails = fetched[0];
      abilityDetails = fetched[1];
      moveDetails = fetched[2];
      itemDetails = fetched[3];
    }

    // 4) Build the consolidated result (keeps your 'about' map intact)
    final about = <String, dynamic>{
      // your original fields
      'name': pokemonData['name'],
      'types': (pokemonData['types'] as List)
          .whereType<Map>()
          .map((t) => t['type']?['name'])
          .whereType<String>()
          .toList(),
      'height_m': _toMeters(pokemonData['height'] as num?),
      'weight_kg': _toKg(pokemonData['weight'] as num?),
      'abilities': (pokemonData['abilities'] as List)
          .whereType<Map>()
          .map((a) => a['ability']?['name'])
          .whereType<String>()
          .toList(),
      'genus': _englishGenus((speciesData['genera'] as List? ?? const [])),
      'description': _englishFlavor((speciesData['flavor_text_entries'] as List? ?? const [])),
      'capture_rate': speciesData['capture_rate'],
      'base_happiness': speciesData['base_happiness'],
      'growth_rate': speciesData['growth_rate']?['name'],
      'egg_groups': (speciesData['egg_groups'] as List? ?? const [])
          .whereType<Map>()
          .map((e) => e['name'])
          .whereType<String>()
          .toList(),
      'gender_rate': speciesData['gender_rate'], // -1 genderless; else *12.5 for female%
      // extra helpful derived fields
      'gender_percent': _genderPercent(speciesData['gender_rate'] as int?),
      'stats': _stats(pokemonData),
      'official_artwork': _officialArtwork(pokemonData),
      'is_legendary': speciesData['is_legendary'],
      'is_mythical': speciesData['is_mythical'],
      'is_baby': speciesData['is_baby'],
      'color': speciesData['color']?['name'],
      'shape': speciesData['shape']?['name'],
      'habitat': speciesData['habitat']?['name'],
      'generation': speciesData['generation']?['name'],
      'varieties': (speciesData['varieties'] as List? ?? const [])
          .whereType<Map>()
          .map((v) => v['pokemon']?['name'])
          .whereType<String>()
          .toList(),
    };

    return {
      'about': about,                        // human-friendly summary
      'core': pokemonData,                   // raw /pokemon
      'species': speciesData,                // raw /pokemon-species
      'evolution_chain': evolutionChain,     // raw /evolution-chain
      'encounters': encounters,              // /pokemon/{id}/encounters
      'forms': forms,                        // /pokemon-form details
      'types_details': typeDetails,          // /type details
      'abilities_details': abilityDetails,   // /ability details
      'moves_details': moveDetails,          // /move details (capped)
      'held_item_details': itemDetails,      // /item details
    };
  }

}