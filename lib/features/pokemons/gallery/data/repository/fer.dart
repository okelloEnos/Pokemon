// Flutter BLoC example: one screen, multiple tabs (About, Moves, Evolution, Encounters)
// Lazy-loads each tab on demand using flutter_bloc and Dio.
// Drop this into lib/pokemon_detail_bloc_example.dart and adjust imports as needed.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// ===================== Repository =====================
class PokemonRepository {
  PokemonRepository({Dio? dio, this.baseUrl = 'https://pokeapi.co/api/v2'})
      : _dio = dio ??
      Dio(BaseOptions(
        baseUrl: 'https://pokeapi.co/api/v2',
        connectTimeout: 15000,
        receiveTimeout: 30000,
        headers: {
          'Accept': 'application/json',
          'User-Agent': 'PokemonApp/1.0 (Flutter)'
        },
      ));

  final Dio _dio;
  final String baseUrl;

  // Minimal in-memory cache keyed by full URL to dedupe fetches.
  final Map<String, Future<dynamic>> _cache = {};

  Future<T> _getCached<T>(String url) {
    return _cache.putIfAbsent(url, () async {
      final r = await _dio.getUri(Uri.parse(url));
      return r.data as T;
    }) as Future<T>;
  }

  Future<Map<String, dynamic>> fetchCore(String nameOrId) async {
    final r = await _dio.get('/pokemon/$nameOrId');
    if (r.statusCode == 200 && r.data is Map) {
      return (r.data as Map).cast<String, dynamic>();
    }
    throw Exception('Failed to fetch /pokemon/$nameOrId');
  }

  Future<Map<String, dynamic>> fetchSpecies(String nameOrId) async {
    final r = await _dio.get('/pokemon-species/$nameOrId');
    if (r.statusCode == 200 && r.data is Map) {
      return (r.data as Map).cast<String, dynamic>();
    }
    throw Exception('Failed to fetch /pokemon-species/$nameOrId');
  }

  Future<List<Map<String, dynamic>>> fetchEncountersById(int id) async {
    final r = await _dio.get('/pokemon/$id/encounters');
    if (r.statusCode == 200 && r.data is List) {
      return (r.data as List)
          .whereType<Map>()
          .map((e) => e.cast<String, dynamic>())
          .toList(growable: false);
    }
    return const [];
  }

  Future<Map<String, dynamic>?> fetchEvolutionChainFromSpecies(String nameOrId) async {
    final species = await fetchSpecies(nameOrId);
    final evoUrl = species['evolution_chain']?['url'] as String?;
    if (evoUrl == null || evoUrl.isEmpty) return null;
    final data = await _getCached<Map<String, dynamic>>(evoUrl);
    return data;
  }

  Future<List<Map<String, dynamic>>> fetchTypesAbilitiesMoves({
    required Map<String, dynamic> core,
    int maxMoves = 40,
    int concurrency = 6,
  }) async {
    List<String> _urls(List list, String? Function(Map m) pick) {
      final out = <String>[];
      for (final x in list.whereType<Map>()) {
        final u = pick(x.cast<String, dynamic>());
        if (u is String && u.isNotEmpty) out.add(u);
      }
      return out;
    }

    final typeUrls = _urls(core['types'] as List? ?? const [], (m) => m['type']?['url']);
    final abilityUrls =
    _urls(core['abilities'] as List? ?? const [], (m) => m['ability']?['url']);
    final moveUrlsAll = _urls(core['moves'] as List? ?? const [], (m) => m['move']?['url']);
    final moveUrls = moveUrlsAll.take(maxMoves).toList();

    Future<Map<String, dynamic>?> _fetch(String url) async {
      try {
        final data = await _getCached<Map<String, dynamic>>(url);
        return data;
      } catch (_) {
        return null;
      }
    }

    Future<List<Map<String, dynamic>>> _fetchAll(List<String> urls) async {
      if (urls.isEmpty) return const [];
      final it = urls.iterator;
      final results = <Map<String, dynamic>>[];
      Future<void> worker() async {
        while (true) {
          if (!it.moveNext()) break;
          final data = await _fetch(it.current);
          if (data != null) results.add(data);
        }
      }
      await Future.wait(List.generate(concurrency, (_) => worker()));
      return results;
    }

    final fetched = await Future.wait([
      _fetchAll(typeUrls),
      _fetchAll(abilityUrls),
      _fetchAll(moveUrls),
    ]);

    // Return combined list but keep order: [types..., abilities..., moves...]
    return [
      ...fetched[0],
      ...fetched[1],
      ...fetched[2],
    ];
  }

  // Helper formatters (for your About map)
  String? englishGenus(List list) {
    for (final x in list.reversed.whereType<Map>()) {
      final m = x.cast<String, dynamic>();
      if (m['language']?['name'] == 'en') return m['genus'] as String?;
    }
    return null;
  }

  String? englishFlavor(List list) {
    for (final x in list.reversed.whereType<Map>()) {
      final m = x.cast<String, dynamic>();
      if (m['language']?['name'] == 'en') {
        final raw = m['flavor_text'] as String?;
        return raw?.replaceAll('\n', ' ').replaceAll('\f', ' ');
      }
    }
    return null;
  }
}

// ===================== BLoC =====================

enum LoadStatus { initial, loading, success, failure }

class PokemonDetailState extends Equatable {
  const PokemonDetailState({
    this.nameOrId,
    this.aboutStatus = LoadStatus.initial,
    this.about,
    this.core,
    this.species,
    this.movesStatus = LoadStatus.initial,
    this.movesDetails = const [],
    this.evolutionStatus = LoadStatus.initial,
    this.evolutionChain,
    this.encountersStatus = LoadStatus.initial,
    this.encounters = const [],
    this.error,
  });

  final String? nameOrId;

  final LoadStatus aboutStatus;
  final Map<String, dynamic>? about;
  final Map<String, dynamic>? core;
  final Map<String, dynamic>? species;

  final LoadStatus movesStatus;
  final List<Map<String, dynamic>> movesDetails;

  final LoadStatus evolutionStatus;
  final Map<String, dynamic>? evolutionChain;

  final LoadStatus encountersStatus;
  final List<Map<String, dynamic>> encounters;

  final String? error;

  PokemonDetailState copyWith({
    String? nameOrId,
    LoadStatus? aboutStatus,
    Map<String, dynamic>? about,
    Map<String, dynamic>? core,
    Map<String, dynamic>? species,
    LoadStatus? movesStatus,
    List<Map<String, dynamic>>? movesDetails,
    LoadStatus? evolutionStatus,
    Map<String, dynamic>? evolutionChain,
    LoadStatus? encountersStatus,
    List<Map<String, dynamic>>? encounters,
    String? error,
  }) {
    return PokemonDetailState(
      nameOrId: nameOrId ?? this.nameOrId,
      aboutStatus: aboutStatus ?? this.aboutStatus,
      about: about ?? this.about,
      core: core ?? this.core,
      species: species ?? this.species,
      movesStatus: movesStatus ?? this.movesStatus,
      movesDetails: movesDetails ?? this.movesDetails,
      evolutionStatus: evolutionStatus ?? this.evolutionStatus,
      evolutionChain: evolutionChain ?? this.evolutionChain,
      encountersStatus: encountersStatus ?? this.encountersStatus,
      encounters: encounters ?? this.encounters,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    nameOrId,
    aboutStatus,
    about,
    core,
    species,
    movesStatus,
    movesDetails,
    evolutionStatus,
    evolutionChain,
    encountersStatus,
    encounters,
    error,
  ];
}

abstract class PokemonDetailEvent extends Equatable {
  const PokemonDetailEvent();
  @override
  List<Object?> get props => [];
}

class LoadAbout extends PokemonDetailEvent {
  const LoadAbout(this.nameOrId);
  final String nameOrId;
  @override
  List<Object?> get props => [nameOrId];
}

class LoadMoves extends PokemonDetailEvent {
  const LoadMoves({this.maxMoves = 40});
  final int maxMoves;
  @override
  List<Object?> get props => [maxMoves];
}

class LoadEvolution extends PokemonDetailEvent {
  const LoadEvolution();
}

class LoadEncounters extends PokemonDetailEvent {
  const LoadEncounters();
}

class PokemonDetailBloc extends Bloc<PokemonDetailEvent, PokemonDetailState> {
  PokemonDetailBloc({required this.repo, required String nameOrId})
      : super(PokemonDetailState(nameOrId: nameOrId)) {
    on<LoadAbout>(_onLoadAbout);
    on<LoadMoves>(_onLoadMoves);
    on<LoadEvolution>(_onLoadEvolution);
    on<LoadEncounters>(_onLoadEncounters);
  }

  final PokemonRepository repo;

  Future<void> _onLoadAbout(
      LoadAbout event,
      Emitter<PokemonDetailState> emit,
      ) async {
    // Skip if already loaded/success
    if (state.aboutStatus == LoadStatus.loading ||
        state.aboutStatus == LoadStatus.success) return;

    emit(state.copyWith(aboutStatus: LoadStatus.loading, nameOrId: event.nameOrId));

    try {
      final results = await Future.wait([
        repo.fetchCore(event.nameOrId),
        repo.fetchSpecies(event.nameOrId),
      ]);

      final core = results[0];
      final species = results[1];

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

      String? _officialArtwork(Map<String, dynamic> p) =>
          p['sprites']?['other']?['official-artwork']?['front_default'] as String?;

      final about = <String, dynamic>{
        'name': core['name'],
        'types': (core['types'] as List? ?? const [])
            .whereType<Map>()
            .map((t) => t['type']?['name'])
            .whereType<String>()
            .toList(),
        'height_m': _toMeters(core['height'] as num?),
        'weight_kg': _toKg(core['weight'] as num?),
        'abilities': (core['abilities'] as List? ?? const [])
            .whereType<Map>()
            .map((a) => a['ability']?['name'])
            .whereType<String>()
            .toList(),
        'genus': repo.englishGenus((species['genera'] as List? ?? const [])),
        'description': repo.englishFlavor((species['flavor_text_entries'] as List? ?? const [])),
        'capture_rate': species['capture_rate'],
        'base_happiness': species['base_happiness'],
        'growth_rate': species['growth_rate']?['name'],
        'egg_groups': (species['egg_groups'] as List? ?? const [])
            .whereType<Map>()
            .map((e) => e['name'])
            .whereType<String>()
            .toList(),
        'gender_rate': species['gender_rate'],
        'stats': _stats(core),
        'official_artwork': _officialArtwork(core),
      };

      emit(state.copyWith(
        aboutStatus: LoadStatus.success,
        about: about,
        core: core,
        species: species,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        aboutStatus: LoadStatus.failure,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMoves(
      LoadMoves event,
      Emitter<PokemonDetailState> emit,
      ) async {
    if (state.movesStatus == LoadStatus.loading ||
        state.movesStatus == LoadStatus.success) return;
    if (state.core == null) return; // wait for about

    emit(state.copyWith(movesStatus: LoadStatus.loading));
    try {
      final details = await repo.fetchTypesAbilitiesMoves(
        core: state.core!,
        maxMoves: event.maxMoves,
      );
      emit(state.copyWith(
        movesStatus: LoadStatus.success,
        movesDetails: details,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        movesStatus: LoadStatus.failure,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadEvolution(
      LoadEvolution event,
      Emitter<PokemonDetailState> emit,
      ) async {
    if (state.evolutionStatus == LoadStatus.loading ||
        state.evolutionStatus == LoadStatus.success) return;

    emit(state.copyWith(evolutionStatus: LoadStatus.loading));
    try {
      final evo = await repo.fetchEvolutionChainFromSpecies(state.nameOrId!);
      emit(state.copyWith(
        evolutionStatus: LoadStatus.success,
        evolutionChain: evo,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        evolutionStatus: LoadStatus.failure,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLoadEncounters(
      LoadEncounters event,
      Emitter<PokemonDetailState> emit,
      ) async {
    if (state.encountersStatus == LoadStatus.loading ||
        state.encountersStatus == LoadStatus.success) return;
    if (state.core == null) return; // wait for about

    emit(state.copyWith(encountersStatus: LoadStatus.loading));
    try {
      final id = state.core!['id'] as int;
      final encounters = await repo.fetchEncountersById(id);
      emit(state.copyWith(
        encountersStatus: LoadStatus.success,
        encounters: encounters,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        encountersStatus: LoadStatus.failure,
        error: e.toString(),
      ));
    }
  }
}

// ===================== UI (One screen with tabs) =====================
class PokemonDetailPage extends StatefulWidget {
  const PokemonDetailPage({Key? key,  required this.nameOrId}) : super(key: key);
  final String nameOrId;

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
    _tabs.addListener(_onTabChanged);

    // Kick off About immediately
    context.read<PokemonDetailBloc>().add(LoadAbout(widget.nameOrId));
  }

  void _onTabChanged() {
    if (!_tabs.indexIsChanging) {
      final bloc = context.read<PokemonDetailBloc>();
      switch (_tabs.index) {
        case 1:
          bloc.add(const LoadMoves(maxMoves: 40));
          break;
        case 2:
          bloc.add(const LoadEvolution());
          break;
        case 3:
          bloc.add(const LoadEncounters());
          break;
      }
    }
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nameOrId),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'About'),
            Tab(text: 'Moves'),
            Tab(text: 'Evolution'),
            Tab(text: 'Encounters'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: const [
          _AboutTab(),
          _MovesTab(),
          _EvolutionTab(),
          _EncountersTab(),
        ],
      ),
    );
  }
}

// --- Tabs ---
class _AboutTab extends StatelessWidget {
  const _AboutTab();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonDetailBloc, PokemonDetailState>(
      buildWhen: (p, c) => p.aboutStatus != c.aboutStatus || p.about != c.about,
      builder: (context, state) {
        if (state.aboutStatus == LoadStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.aboutStatus == LoadStatus.failure) {
          return Center(child: Text('Failed to load: ${state.error}'));
        }
        final about = state.about;
        if (about == null) {
          return const Center(child: Text('No data'));
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Name: ${about['name']}', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Types: ${(about['types'] as List).join(', ')}'),
            Text('Height: ${about['height_m']} m'),
            Text('Weight: ${about['weight_kg']} kg'),
            Text('Abilities: ${(about['abilities'] as List).join(', ')}'),
            const SizedBox(height: 8),
            if (about['official_artwork'] != null)
              Image.network(about['official_artwork'] as String),
            const SizedBox(height: 12),
            Text(about['genus'] ?? ''),
            const SizedBox(height: 8),
            Text(about['description'] ?? ''),
            const SizedBox(height: 12),
            Text('Capture rate: ${about['capture_rate']}'),
            Text('Base happiness: ${about['base_happiness']}'),
            Text('Growth: ${about['growth_rate']}'),
            Text('Egg groups: ${(about['egg_groups'] as List).join(', ')}'),
            const SizedBox(height: 12),
            Text('Stats:', style: Theme.of(context).textTheme.titleMedium),
            ...(about['stats'] as Map<String, int>).entries
                .map((e) => Text('${e.key}: ${e.value}')),
          ],
        );
      },
    );
  }
}

class _MovesTab extends StatelessWidget {
  const _MovesTab();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonDetailBloc, PokemonDetailState>(
      buildWhen: (p, c) => p.movesStatus != c.movesStatus || p.movesDetails != c.movesDetails,
      builder: (context, state) {
        switch (state.movesStatus) {
          case LoadStatus.initial:
            return const Center(child: Text('Open the tab to load moves'));
          case LoadStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case LoadStatus.failure:
            return Center(child: Text('Failed: ${state.error}'));
          case LoadStatus.success:
            final list = state.movesDetails;
            return ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) => ListTile(
                title: Text(list[i]['name'] ?? 'move'),
                subtitle: Text(list[i]['type']?['name'] ?? ''),
              ),
            );
        }
      },
    );
  }
}

class _EvolutionTab extends StatelessWidget {
  const _EvolutionTab();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonDetailBloc, PokemonDetailState>(
      buildWhen: (p, c) => p.evolutionStatus != c.evolutionStatus || p.evolutionChain != c.evolutionChain,
      builder: (context, state) {
        switch (state.evolutionStatus) {
          case LoadStatus.initial:
            return const Center(child: Text('Open the tab to load evolution'));
          case LoadStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case LoadStatus.failure:
            return Center(child: Text('Failed: ${state.error}'));
          case LoadStatus.success:
            final chain = state.evolutionChain;
            if (chain == null) return const Center(child: Text('No evolution chain'));
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Evolution chain loaded (id: ${chain['id']})'),
            );
        }
      },
    );
  }
}

class _EncountersTab extends StatelessWidget {
  const _EncountersTab();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonDetailBloc, PokemonDetailState>(
      buildWhen: (p, c) => p.encountersStatus != c.encountersStatus || p.encounters != c.encounters,
      builder: (context, state) {
        switch (state.encountersStatus) {
          case LoadStatus.initial:
            return const Center(child: Text('Open the tab to load encounters'));
          case LoadStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case LoadStatus.failure:
            return Center(child: Text('Failed: ${state.error}'));
          case LoadStatus.success:
            final enc = state.encounters;
            if (enc.isEmpty) return const Center(child: Text('No encounters'));
            return ListView.separated(
              itemCount: enc.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) => ListTile(
                title: Text(enc[i]['location_area']?['name'] ?? 'area'),
                subtitle: Text(
                  (enc[i]['version_details'] as List?)?.map((e) => e['version']?['name']).whereType<String>().join(', ') ?? '',
                ),
              ),
            );
        }
      },
    );
  }
}

// ===================== Bootstrapping example =====================
// Wrap your MaterialApp with a RepositoryProvider and create the Bloc where you navigate to this page.
class PokemonAppExample extends StatelessWidget {
  const PokemonAppExample({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => PokemonRepository(),
      child: Builder(
        builder: (context) {
          return BlocProvider(
            create: (_) => PokemonDetailBloc(
              repo: context.read<PokemonRepository>(),
              nameOrId: 'pikachu',
            ),
            child: const MaterialApp(
              home: PokemonDetailPage(nameOrId: 'pikachu'),
            ),
          );
        },
      ),
    );
  }
}
