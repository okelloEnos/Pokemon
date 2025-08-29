// import 'dart:async';
// import 'package:dio/dio.dart';
// import 'package:pokemon/core/util/dio_exceptions.dart';
//
// /// Consolidated container for "everything" about one Pokémon.
// /// Each field is the raw JSON from PokéAPI so you never lose data.
// /// You can read typed values as needed in your app layers.
// class FullPokemon {
//   final Map<String, dynamic> pokemon;          // /pokemon/{id|name}
//   final Map<String, dynamic> species;          // /pokemon-species/{id|name}
//   final Map<String, dynamic>? evolutionChain;  // /evolution-chain/{id}
//   final List<Map<String, dynamic>> typeDetails;      // follow /type
//   final List<Map<String, dynamic>> abilityDetails;   // follow /ability
//   final List<Map<String, dynamic>> moveDetails;      // follow /move
//   final List<Map<String, dynamic>> heldItemDetails;  // follow /item
//   final List<Map<String, dynamic>> forms;            // /pokemon-form
//   final List<Map<String, dynamic>> encounters;       // /pokemon/{id}/encounters
//
//   FullPokemon({
//     required this.pokemon,
//     required this.species,
//     required this.evolutionChain,
//     required this.typeDetails,
//     required this.abilityDetails,
//     required this.moveDetails,
//     required this.heldItemDetails,
//     required this.forms,
//     required this.encounters,
//   });
//
//   /// Helpful pickers for common “About” UI bits (safe if missing).
//   String? get englishGenus {
//     final genera = species['genera'];
//     if (genera is List) {
//       for (final g in genera) {
//         if (g is Map && g['language']?['name'] == 'en') {
//           return g['genus'] as String?;
//         }
//       }
//     }
//     return null;
//   }
//
//   String? get englishFlavor {
//     final entries = species['flavor_text_entries'];
//     if (entries is List) {
//       // Prefer the last English entry (often the most recent).
//       for (final entry in entries.reversed) {
//         if (entry is Map && entry['language']?['name'] == 'en') {
//           final raw = entry['flavor_text'] as String?;
//           return raw?.replaceAll('\n', ' ').replaceAll('\f', ' ');
//         }
//       }
//     }
//     return null;
//   }
// }
//
// /// Service that fetches and aggregates everything about a Pokémon.
// ///
// /// Usage:
// /// final hydrator = PokemonHydrator();
// /// final pikachu = await hydrator.hydrate('pikachu');
// class PokemonHydrator {
//   PokemonHydrator({
//     Dio? dio,
//     this.baseUrl = 'https://pokeapi.co/api/v2',
//     this.concurrency = 6, // be nice to the API while still being snappy
//   }) : _dio = dio ??
//       Dio(BaseOptions(
//         baseUrl: 'https://pokeapi.co/api/v2',
//         // connectTimeout: const Duration(seconds: 15),
//         // receiveTimeout: const Duration(seconds: 30),
//         connectTimeout: 15000,
//         receiveTimeout: 30000,
//         headers: {
//           'Accept': 'application/json',
//           'User-Agent': 'PokeHydrator/1.0 (Dart; Flutter)',
//         },
//       ));
//
//   final Dio _dio;
//   final String baseUrl;
//   final int concurrency;
//
//   /// Hydrates "everything". By default it truly fetches *all* moves & items.
//   /// If you want to cap moves for speed in dev, pass [maxMovesToHydrate].
//   Future<FullPokemon> hydrate(
//       String nameOrId, {
//         int? maxMovesToHydrate, // null = all moves; you can set 50 for faster dev
//         bool hydrateHeldItems = true,
//         bool hydrateForms = true,
//         bool hydrateEncounters = true,
//       }) async {
//     // 1) Fetch core Pokémon + species in parallel.
//     final coreAndSpecies = await Future.wait([
//       _getJson('/pokemon/$nameOrId'),
//       _getJson('/pokemon-species/$nameOrId'),
//     ]);
//
//     final pokemon = coreAndSpecies[0]!;
//     final species = coreAndSpecies[1]!;
//
//     // 2) Evolution chain (via species)
//     Map<String, dynamic>? evolutionChain;
//     final evoUrl = species['evolution_chain']?['url'];
//     if (evoUrl is String && evoUrl.isNotEmpty) {
//       evolutionChain = await _getAbsoluteJson(evoUrl);
//     }
//
//     // 3) Collect URLs to hydrate: types, abilities, moves, items, forms.
//     final typeUrls = _extractUrls(pokemon['types'], (e) => e['type']?['url']);
//     final abilityUrls =
//     _extractUrls(pokemon['abilities'], (e) => e['ability']?['url']);
//     final moveUrls = _extractUrls(pokemon['moves'], (e) => e['move']?['url']);
//     final itemUrls = hydrateHeldItems
//         ? _extractUrls(pokemon['held_items'], (e) => e['item']?['url'])
//         : <String>[];
//     final formUrls = hydrateForms
//         ? _extractUrls(pokemon['forms'], (e) => e['url'])
//         : <String>[];
//
//     // Optional cap for moves (it can be 100+ per Pokémon).
//     final cappedMoveUrls = (maxMovesToHydrate == null)
//         ? moveUrls
//         : moveUrls.take(maxMovesToHydrate).toList();
//
//     // 4) Hydrate linked resources concurrently with a simple limiter.
//     final results = await Future.wait([
//       _fetchAllWithLimit(typeUrls, _getAbsoluteJson),
//       _fetchAllWithLimit(abilityUrls, _getAbsoluteJson),
//       _fetchAllWithLimit(cappedMoveUrls, _getAbsoluteJson),
//       _fetchAllWithLimit(itemUrls, _getAbsoluteJson),
//       _fetchAllWithLimit(formUrls, _getAbsoluteJson),
//       if (hydrateEncounters)
//         _getJson('/pokemon/${pokemon['id']}/encounters')
//       else
//         Future.value(<dynamic>[]),
//     ]);
//
//     final typeDetails =
//     (results[0]! as List).whereType<Map<String, dynamic>>().toList(growable: false);
//     final abilityDetails =
//     (results[1]! as List).whereType<Map<String, dynamic>>().toList(growable: false);
//     final moveDetails =
//     (results[2]! as List).whereType<Map<String, dynamic>>().toList(growable: false);
//     final heldItemDetails =
//     (results[3]! as List).whereType<Map<String, dynamic>>().toList(growable: false);
//     final forms =
//     (results[4]! as List).whereType<Map<String, dynamic>>().toList(growable: false);
//     final encountersListRaw = results[5];
//
//     final encounters = <Map<String, dynamic>>[];
//     if (encountersListRaw is List) {
//       for (final e in encountersListRaw) {
//         if (e is Map<String, dynamic>) encounters.add(e);
//       }
//     }
//
//     return FullPokemon(
//       pokemon: pokemon,
//       species: species,
//       evolutionChain: evolutionChain,
//       typeDetails: typeDetails,
//       abilityDetails: abilityDetails,
//       moveDetails: moveDetails,
//       heldItemDetails: heldItemDetails,
//       forms: forms,
//       encounters: encounters,
//     );
//   }
//
//   // --- Helpers ---------------------------------------------------------------
//
//   Future<Map<String, dynamic>?> _getJson(String path) async {
//     try {
//       final res = await _dio.get(path);
//       if (res.statusCode == 200 && res.data is Map<String, dynamic>) {
//         return res.data as Map<String, dynamic>;
//       }
//       // throw DioExceptions(
//       //   requestOptions: res.requestOptions,
//       //   response: res,
//       //   error: 'Unexpected response shape for $path',
//       //   type: DioExceptionType.badResponse,
//       // );
//     } on DioExceptions catch (e) {
//       // Log + propagate a trimmed error to help UI
//       throw Exception('GET $path failed: ${e.message ?? e.message}');
//     }
//   }
//
//   Future<Map<String, dynamic>?> _getAbsoluteJson(String absoluteUrl) async {
//     try {
//       final res = await _dio.getUri(Uri.parse(absoluteUrl));
//       if (res.statusCode == 200 && res.data is Map<String, dynamic>) {
//         return res.data as Map<String, dynamic>;
//       }
//       // throw DioException(
//       //   requestOptions: res.requestOptions,
//       //   response: res,
//       //   error: 'Unexpected response shape for $absoluteUrl',
//       //   type: DioExceptionType.badResponse,
//       // );
//     } on DioExceptions catch (e) {
//       // Swallow individual subresource failures to keep hydration resilient.
//       // Return null so the caller can filter it out.
//       // You can switch this to "throw" if you prefer strict failures.
//       return null;
//     }
//   }
//
//   List<String> _extractUrls(dynamic list, String? Function(Map e) pick) {
//     final urls = <String>[];
//     if (list is List) {
//       for (final raw in list) {
//         if (raw is Map) {
//           final u = pick(raw);
//           if (u != null && u is String && u.isNotEmpty) {
//             urls.add(u);
//           }
//         }
//       }
//     }
//     return urls;
//   }
//
//   Future<List<dynamic>?> _fetchAllWithLimit(
//       List<String> urls,
//       Future<Map<String, dynamic>?> Function(String url) fetcher,
//       ) async {
//     if (urls.isEmpty) return const [];
//     final controller = StreamController<String>();
//     final results = <dynamic>[];
//     final iterator = urls.iterator;
//
//     // Worker
//     Future<void> worker() async {
//       while (true) {
//         String? next;
//         // Pull next URL synchronously
//         if (iterator.moveNext()) {
//           next = iterator.current;
//         } else {
//           break;
//         }
//         try {
//           final data = await fetcher(next);
//           if (data != null) results.add(data);
//         } catch (_) {
//           // ignore individual failures
//         }
//       }
//     }
//
//     // Spin up N workers
//     final workers = List.generate(concurrency, (_) => worker());
//     await Future.wait(workers);
//     await controller.close();
//     return results;
//   }
// }
