import 'package:beamer/beamer.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon/pokemons/bloc/pokemon_bloc_util.dart';
import 'package:pokemon/pokemons/data/models/pokemon_model_util.dart';
import 'package:pokemon/pokemons/presentation/presentation_util.dart';
import 'package:pokemon/pokemons/presentation/screens/all_pokemons_screen.dart';
import 'package:pokemon/pokemons/presentation/widgets/pokemons_grid.dart';

import '../bloc/pokemon_bloc_test.dart';
import '../model/mock_pokemon_info.dart';

class MockPokemonBloc extends MockBloc<PokemonEvents, PokemonStates>
    implements PokemonsBloc {}

class PokemonsFakeEvents extends Fake implements PokemonEvents {}

class PokemonsFakeStates extends Fake implements PokemonStates {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  /// make a widget testable by providing material info
  Widget makeTestableWidget({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  /// make a widget testable by providing material info
  Widget makeTestableWidgetWithBeamer(
      {required BeamerDelegate routerDelegate}) {
    return MaterialApp.router(
      routeInformationParser: BeamerParser(),
      routerDelegate: routerDelegate,
    );
  }

  /// registerFallbackValue registers types Value to allow usage of Any where the value is expected
  // setUpAll(() {
  //   registerFallbackValue<AuthenticationState>(AuthenticationStateFake());
  //   registerFallbackValue<AuthenticationEvent>(AuthenticationEventFake());
  // });

  group("all pokemons screen widgets", () {
    testWidgets("testing AllPokemonsScreen() widgets with success",
        (WidgetTester tester) async {
      /// instantiate the mocked pokemon bloc
      final pokemonMockBloc = MockPokemonBloc();

      /// place a successful state when launching
      when(() => pokemonMockBloc.state).thenReturn(PokemonsLoaded());

      /// instantiating the Widget Screen for all Pokemons
      AllPokemonsScreen allPokemonsScreen = const AllPokemonsScreen();

      /// wrap the all screen with a bloc provider
      final allPokemonScreenWithBloc = BlocProvider<PokemonsBloc>(
        create: (context) => pokemonMockBloc,
        child: makeTestableWidget(child: allPokemonsScreen),
      );
      await tester.pumpWidget(allPokemonScreenWithBloc);
      Finder gridViewFinder = find.byKey(const Key("pokemon_grid"));
      Finder failTextFinder = find.byKey(const Key("error"));
      Finder loaderFinder = find.byKey(const Key("pokemon_loading"));

      expect(gridViewFinder, findsOneWidget);
      expect(failTextFinder, findsNothing);
      expect(loaderFinder, findsNothing);
    });

    testWidgets("testing AllPokemonsScreen() widgets with failure",
        (WidgetTester tester) async {
      /// instantiate the mocked pokemon bloc
      final pokemonMockBloc = MockPokemonBloc();

      /// place a successful state when launching
      when(() => pokemonMockBloc.state)
          .thenReturn(PokemonsFailure(errorText: 'errorText'));

      /// instantiating the Widget Screen for all Pokemons
      AllPokemonsScreen allPokemonsScreen = const AllPokemonsScreen();

      /// wrap the all screen with a bloc provider
      final allPokemonScreenWithBloc = BlocProvider<PokemonsBloc>(
        create: (context) => pokemonMockBloc,
        child: makeTestableWidget(child: allPokemonsScreen),
      );
      await tester.pumpWidget(allPokemonScreenWithBloc);
      Finder failTextFinder = find.byKey(const Key("error"));
      Finder loaderFinder = find.byKey(const Key("pokemon_loading"));
      Finder gridViewFinder = find.byKey(const Key("pokemon_grid"));

      expect(failTextFinder, findsOneWidget);
      expect(loaderFinder, findsNothing);
      expect(gridViewFinder, findsNothing);
    });

    testWidgets("All Screen Pokemons Loading..", (widgetTester) async {
      final mockPokemonBloc = MockPokemonBloc();
      when(() => mockPokemonBloc.state).thenReturn(PokemonsInitial());
      const allPokemonScreen = AllPokemonsScreen();
      final pokemonScreenWithBloc = BlocProvider<PokemonsBloc>(
        create: (context) => mockPokemonBloc,
        child: makeTestableWidget(child: allPokemonScreen),
      );

      await widgetTester.pumpWidget(pokemonScreenWithBloc);

      Finder gridFinder = find.byKey(const Key("pokemon_grid"));
      Finder failureTextFinder = find.byKey(const Key("error"));
      Finder loaderFinder = find.byKey(const Key("pokemon_loading"));

      expect(loaderFinder, findsOneWidget);
      expect(failureTextFinder, findsNothing);
      expect(gridFinder, findsNothing);
    });

    testWidgets("grids card widgets", (widgetTester) async {
      final buildContext = MockBuildContext();
      final pokemon = MockPokemonInfo();

      when(() => pokemon.pokemonName).thenReturn(pokemonName);
      when(() => pokemon.pokemonWeight).thenReturn(pokemonWeight);
      when(() => pokemon.pokemonHeight).thenReturn(pokemonHeight);
      when(() => pokemon.sprites).thenReturn(sprites);
      // when(() => pokemon.moves).thenReturn(moves);
      // when(() => pokemon.stats).thenReturn(stats);
      // when(() => pokemon.abilities).thenReturn(abilities);

      final gridCard = pokemonCard(buildContext, pokemon, 1);

      await widgetTester.pumpWidget(makeTestableWidget(child: gridCard));

      Finder heroGrid = find.byKey(const Key("grid_hero"));
      Finder cardGrid = find.byKey(const Key("grid_card"));
      Finder columnGrid = find.byKey(const Key("grid_column"));
      Finder imageGrid = find.byKey(const Key("grid_image"));
      Finder padGrid = find.byKey(const Key("grid_pad"));
      Finder textGrid = find.byKey(const Key("grid_text_name"));

      expect(heroGrid, findsOneWidget);
      expect(cardGrid, findsOneWidget);
      expect(columnGrid, findsOneWidget);
      expect(imageGrid, findsOneWidget);
      expect(padGrid, findsOneWidget);
      expect(textGrid, findsOneWidget);
    });

    group('Interactivity And Behaviour', () {
      testWidgets(
          "On Success Pokemons retrieval List the pokemons tap and go to detail Screen",
          (widgetTester) async {
        final buildContext = MockBuildContext();
        final pokemon = MockPokemonInfo();
        final pokemonMockBloc = MockPokemonBloc();
        // const actualPokemon =  PokemonInfo(
        //     pokemonName: pokemonName,
        //     baseExperience: 3,
        //     pokemonHeight: pokemonHeight,
        //     pokemonWeight: pokemonWeight,
        //     types: [],
        //     abilities: abilities,
        //     stats: stats,
        //     moves: moves,
        //     sprites: sprites,
        //     species: species);

        /// adding pokemon info on mock
        when(() => pokemon.pokemonName).thenReturn(pokemonName);
        when(() => pokemon.pokemonHeight).thenReturn(pokemonHeight);
        when(() => pokemon.pokemonWeight).thenReturn(pokemonWeight);
        when(() => pokemon.sprites).thenReturn(sprites);
        when(() => pokemon.abilities).thenReturn(abilities);
        when(() => pokemon.species).thenReturn(species);
        when(() => pokemon.stats).thenReturn(stats);
        when(() => pokemon.moves).thenReturn(moves);
        when(() => pokemonMockBloc.state).thenReturn(PokemonsLoaded(
          pokemons: List.generate(3, (index) => pokemon
              //     PokemonInfo(
              //     pokemonName: "$pokemonName$index",
              //     baseExperience: 3,
              //     pokemonHeight: pokemonHeight,
              //     pokemonWeight: pokemonWeight,
              //     types: const [],
              //     abilities: abilities,
              //     stats: stats,
              //     moves: moves,
              //     sprites: sprites,
              //     species: species
              // )
              ),
        ));

        /// instantiating the Widget Screen for all Pokemons
        AllPokemonsScreen allPokemonsScreen = const AllPokemonsScreen();

        /// wrap the all screen with a bloc provider
        final allPokemonScreenWithBloc = BlocProvider<PokemonsBloc>(
          create: (context) => pokemonMockBloc,
          child: makeTestableWidget(child: allPokemonsScreen),
        );

        /// instantiating the Single Pokemon Screen that takes in a pokemon
        final singlePokemonScreen = SinglePokemonScreen(pokemon: pokemon);

        final routerDelegate = BeamerDelegate(
            initialPath: "/",
            locationBuilder: SimpleLocationBuilder(routes: {
              // return screens
              '/': (context) => allPokemonScreenWithBloc,
              '/pokemons': (context) {
                // extract beamState which holds route information
                // final beamState = context.currentBeamLocation.state;
                // final pokemon = beamState.data["pokemon"] as PokemonInfo;
                // return SinglePokemonScreen(pokemon: pokemon);
                return singlePokemonScreen;
              }
            }));

        // await widgetTester.pumpWidget(allPokemonScreenWithBloc);
        await widgetTester.pumpWidget(makeTestableWidgetWithBeamer(routerDelegate: routerDelegate));

        Finder textGridWithKey = find.byKey(const Key("grid_text_name1"));
        Finder cardGrid = find.byKey(const Key("grid_card"));
        Finder gestureFinder = find.ancestor(
            of: textGridWithKey, matching: find.byType(GestureDetector));

        /// existence of a grid with respective cards
        expect(find.byType(GridView), findsOneWidget);
        // expect(find.byType(GridView), findsNWidgets(2));
        expect(textGridWithKey, findsOneWidget);
        expect(gestureFinder, findsOneWidget);
        // expect(find.byKey(Key('enos1')), findsOneWidget);

        await widgetTester.tap(gestureFinder);
        for (int i = 0; i < 5; i++) {
          await widgetTester.pump(const Duration(seconds: 1));
        }
        // await widgetTester.pumpAndSettle();
        // expect(find.byType(NewNotePage), findsOneWidget);
        // await widgetTester.dragUntilVisible(
        //   gestureFinder, // what you want to find
        //   find.byKey(const Key("pokemon_grid")), // widget you want to scroll
        //   const Offset(600, 400), // delta to move
        // );
        // await widgetTester.drag(find.byKey(const Key("pokemon_grid")), const Offset(0.0, -300));
        // await widgetTester.pump();
        // await widgetTester.ensureVisible(gestureFinder);
        // await widgetTester.tap(find.byKey(Key('enos1')));
        // await widgetTester.pumpAndSettle();
        // await widgetTester.pump(const Duration(milliseconds: 100));
        // final Finder buttonToTap = find.byKey(const Key('keyOfTheButton'));
        //
        // await widgetTester.dragUntilVisible(
        //   gestureFinder, // what you want to find
        //   find.byType(GridView), // widget you want to scroll
        //   const Offset(0, 50), // delta to move
        // );
        // await widgetTester.tap(gestureFinder);
        // await widgetTester.pump();
        // expect(find.text("$pokemonName${1.toString()}"), findsOneWidget);
        // await widgetTester.ensureVisible(textGridWithKey);
        // await widgetTester.ensureVisible(gestureFinder);
        // await widgetTester.pump();
        // await widgetTester.tap(find.byType(ElevatedButton));
        /// tap a particular card
        // await widgetTester.tap(gestureFinder);
        // await widgetTester.tap(find.text("$pokemonName${1.toString()}"));

        /// rebuild the frame
        // await widgetTester.pump();

        /// verify if you have moved to pokemons detail screen
        expect(cardGrid, findsNothing);
        expect(find.byKey(const Key('single_pokemon_column')), findsOneWidget);
        // expect(find.text("$pokemonName${1.toString()}"), findsOneWidget);
      });
    });
  });
}
