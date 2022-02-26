import 'package:beamer/beamer.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon/pokemons/bloc/pokemon_bloc_util.dart';
import 'package:pokemon/pokemons/data/models/pokemon_model_util.dart';
import 'package:pokemon/pokemons/presentation/presentation_util.dart';
import 'package:pokemon/util/extensions.dart';

import '../bloc/pokemon_bloc_test.dart';
import '../model/mock_pokemon_info.dart';

class MockPokemonBloc extends MockBloc<PokemonEvents, PokemonStates>
    implements PokemonsBloc {}

class PokemonsFakeEvents extends Fake implements PokemonEvents {}

class PokemonsFakeStates extends Fake implements PokemonStates {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
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

  group('Testing Pokemons Widgets For :', () {
    /// varaiable for pokemon bloc
    late MockPokemonBloc pokemonMockBloc;

    /// instantiating the Widget Screen for all Pokemons
    AllPokemonsScreen allPokemonsScreen = const AllPokemonsScreen();

    /// wrap the all screen with a bloc provider
    final allPokemonScreenWithBloc = BlocProvider<PokemonsBloc>(
      create: (context) => pokemonMockBloc,
      child: makeTestableWidget(child: allPokemonsScreen),
    );

    late MockBuildContext buildContext;
    final pokemon = MockPokemonInfo();


    /// adding pokemon info on mock
    when(() => pokemon.pokemonName).thenReturn(pokemonName);
    when(() => pokemon.pokemonHeight).thenReturn(pokemonHeight);
    when(() => pokemon.pokemonWeight).thenReturn(pokemonWeight);
    when(() => pokemon.sprites).thenReturn(sprites);
    when(() => pokemon.abilities).thenReturn(abilities);
    when(() => pokemon.species).thenReturn(species);
    when(() => pokemon.stats).thenReturn(stats);
    when(() => pokemon.moves).thenReturn(moves);

    /// instantiating the Single Pokemon Screen that takes in a pokemon
    final singlePokemonScreen = SinglePokemonScreen(pokemon: pokemon);
    setUp(() {
      /// instantiate the mocked pokemon bloc for every test
      pokemonMockBloc = MockPokemonBloc();
      buildContext = MockBuildContext();
    });

    /// Instantiating finders all pokemons screen
    /// general
    Finder gridViewFinder = find.byKey(const Key("pokemon_grid"));
    Finder failTextFinder = find.byKey(const Key("error"));
    Finder loaderFinder = find.byKey(const Key("pokemon_loading"));

    /// specific grid widget
    Finder heroGrid = find.byKey(const Key("grid_hero"));
    Finder cardGrid = find.byKey(const Key("grid_card"));
    Finder columnGrid = find.byKey(const Key("grid_column"));
    Finder imageGrid = find.byKey(const Key("grid_image"));
    Finder padGrid = find.byKey(const Key("grid_pad"));
    Finder textGrid = find.byKey(const Key("grid_text_name"));

    /// instantiating finders for single pokemons
    /// general
    Finder columnFinder = find.byKey(const Key('single_pokemon_column'));
    Finder heroFinder = find.byKey(const Key('single_pokemon_hero'));
    Finder upperCardFinder = find.byKey(const Key('single_pokemon_card_image'));
    Finder backButtonFinder =
        find.byKey(const Key('single_pokemon_back_button'));
    Finder nameFinder = find.byKey(const Key('single_pokemon_text_name'));
    Finder carouselFinder = find.byKey(const Key('single_pokemon_carousel'));
    // Finder imageCarouselFinder = find.byKey(const Key('single_pokemon_carousel_image'));
    Finder tabsCardFinder = find.byKey(const Key('single_pokemon_tabs_card'));

    /// individual
    /// image holder widget
    Finder imageFinder = find.byKey(const Key('single_pokemon_image'));
    Finder typeFinder = find.byKey(const Key('single_pokemon_type_text'));

    ///tabBar and tabView
    Finder tabBarFinder = find.byKey(const Key('single_pokemon_tab_bar'));
    Finder tabViewFinder = find.byKey(const Key('single_pokemon_tab_view'));
    // Finder movesWidgetFinder = find.byKey(const Key('single_pokemon_about_widget'));
    /// about widget
    Finder speciesFinder =
        find.byKey(const Key('single_pokemon_species_information'));
    Finder heightFinder =
        find.byKey(const Key('single_pokemon_height_information'));
    Finder weightFinder =
        find.byKey(const Key('single_pokemon_weight_information'));
    Finder experienceFinder =
        find.byKey(const Key('single_pokemon_experience_information'));
    Finder abilityFinder =
        find.byKey(const Key('single_pokemon_abilities_information'));

    /// stats widget
    Finder statBuilderFinder =
        find.byKey(const Key('single_pokemon_stats_builder'));
    Finder statFinder =
        find.byKey(const Key('single_pokemon_stats_information'));

    /// evolution widget
    Finder evolutionFinderGeneral =
        find.byKey(const Key('single_pokemon_evolution_information'));
    Finder cardEvolution = find.descendant(
        of: evolutionFinderGeneral, matching: find.byType(Card));

    /// moves widget
    Finder moveBuilderFinder =
        find.byKey(const Key('single_pokemon_moves_builder'));
    Finder moveFinder =
        find.byKey(const Key('single_pokemon_moves_information'));

    group("Looks and Appearance", () {
      group("Pokemons Widgets In :", () {
        group("All Pokemons Screen", () {
          testWidgets(" With success", (WidgetTester tester) async {
            /// place a successful state when launching
            when(() => pokemonMockBloc.state).thenReturn(PokemonsLoaded());

            await tester.pumpWidget(allPokemonScreenWithBloc);

            expect(gridViewFinder, findsOneWidget);
            expect(failTextFinder, findsNothing);
            expect(loaderFinder, findsNothing);
          });

          testWidgets("With failure", (WidgetTester tester) async {
            /// place a failing state when launching
            when(() => pokemonMockBloc.state)
                .thenReturn(PokemonsFailure(errorText: 'errorText'));

            await tester.pumpWidget(allPokemonScreenWithBloc);

            expect(failTextFinder, findsOneWidget);
            expect(loaderFinder, findsNothing);
            expect(gridViewFinder, findsNothing);
          });

          testWidgets("Loading..", (widgetTester) async {
            when(() => pokemonMockBloc.state).thenReturn(PokemonsInitial());

            await widgetTester.pumpWidget(allPokemonScreenWithBloc);

            expect(loaderFinder, findsOneWidget);
            expect(failTextFinder, findsNothing);
            expect(gridViewFinder, findsNothing);
          });

          testWidgets("grids card widgets", (widgetTester) async {
            final gridCard = pokemonCard(buildContext, pokemon, 1);

            await widgetTester.pumpWidget(makeTestableWidget(child: gridCard));

            expect(heroGrid, findsOneWidget);
            expect(cardGrid, findsOneWidget);
            expect(columnGrid, findsOneWidget);
            expect(imageGrid, findsOneWidget);
            expect(padGrid, findsOneWidget);
            expect(textGrid, findsOneWidget);
          });
        });

        group("Single Pokemons Screen", () {
          testWidgets("Single pokemon screen", (widgetTester) async {
            await widgetTester
                .pumpWidget(makeTestableWidget(child: singlePokemonScreen));

            expect(columnFinder, findsOneWidget);
            expect(heroFinder, findsOneWidget);
            expect(upperCardFinder, findsOneWidget);
            expect(backButtonFinder, findsOneWidget);
            expect(nameFinder, findsOneWidget);
            expect(carouselFinder, findsOneWidget);
            expect(tabsCardFinder, findsOneWidget);
            // expect(imageCarouselFinder, findsOneWidget);
          });

          testWidgets("pokemon image card holder tests", (widgetTester) async {
            await widgetTester.pumpWidget(makeTestableWidget(
                child: pokemonImageCard(
                    context: buildContext, image: "image", type: "type")));

            expect(imageFinder, findsOneWidget);
            expect(typeFinder, findsOneWidget);
          });

          testWidgets("Single Pokemons Tab widgets", (widgetTester) async {
            await widgetTester.pumpWidget(makeTestableWidget(
                child: PokemonsDetailsTab(pokemonInfo: pokemon)));

            expect(tabBarFinder, findsOneWidget);
            expect(tabViewFinder, findsOneWidget);
            // expect(movesWidgetFinder, findsOneWidget);
          });

          testWidgets('about tab widgets test', (widgetTester) async {
            await widgetTester.pumpWidget(makeTestableWidget(
                child: pokemonAboutWidget(
                    pokemon: pokemon, context: buildContext)));

            expect(speciesFinder, findsOneWidget);
            expect(heightFinder, findsOneWidget);
            expect(weightFinder, findsOneWidget);
            expect(experienceFinder, findsOneWidget);
            expect(abilityFinder, findsOneWidget);
          });

          testWidgets('Stats widget plus listView builder',
              (widgetTester) async {
            await widgetTester.pumpWidget(makeTestableWidget(
                child: pokemonStatsWidget(
                    pokemon: pokemon, context: buildContext)));

            expect(statBuilderFinder, findsOneWidget);
            expect(statFinder, findsWidgets);
          });

          testWidgets('evolution Widget ', (widgetTester) async {
            await widgetTester.pumpWidget(makeTestableWidget(
                child: pokemonEvolutionWidget(
                    pokemon: pokemon, context: buildContext)));

            expect(evolutionFinderGeneral, findsOneWidget);
            expect(cardEvolution, findsNothing);
          });

          testWidgets('moves widget plus listView builder',
              (widgetTester) async {
            await widgetTester.pumpWidget(makeTestableWidget(
                child: pokemonMovesWidget(
                    pokemon: pokemon, context: buildContext)));

            expect(moveBuilderFinder, findsOneWidget);
            expect(moveFinder, findsOneWidget);
          });
        });
      });
    });

    group('Interactivity And Behaviour Version', () {
      testWidgets(
          "On Success Pokemons retrieval List the pokemons tap and go to detail Screen",
              (widgetTester) async {
            final pokemonMockBloc = MockPokemonBloc();

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
              pokemons: List.generate(3, (index) =>
              // pokemon
                    PokemonInfo(
                    pokemonName: "$pokemonName$index",
                    baseExperience: 3,
                    pokemonHeight: pokemonHeight,
                    pokemonWeight: pokemonWeight,
                    types: const [],
                    abilities: abilities,
                    stats: stats,
                    moves: moves,
                    sprites: sprites,
                    species: species
                )
              ),
            ));

            /// instantiating the Widget Screen for all Pokemons
            AllPokemonsScreen allPokemonsScreen = const AllPokemonsScreen();

            /// wrap the all screen with a bloc provider
            final allPokemonScreenWithBlocWithDelegate = BlocProvider<PokemonsBloc>(
              create: (context) => pokemonMockBloc,
              child: makeTestableWidget(child: allPokemonsScreen),
            );

            /// instantiating the Single Pokemon Screen that takes in a pokemon
            final singlePokemonScreen = SinglePokemonScreen(pokemon: pokemon);

            final routerDelegate = BeamerDelegate(
                initialPath: "/",
                locationBuilder: SimpleLocationBuilder(routes: {
                  // return screens
                  '/': (context) => allPokemonScreenWithBlocWithDelegate,
                  '/pokemons': (context) {
                    // extract beamState which holds route information
                    final beamState = context.currentBeamLocation.state;
                    final pokemon = beamState.data["pokemon"] as PokemonInfo;
                    return SinglePokemonScreen(pokemon: pokemon);
                    // return singlePokemonScreen;
                  }
                }));

            await widgetTester.pumpWidget(makeTestableWidgetWithBeamer(routerDelegate: routerDelegate));

            final stateTest = pokemonMockBloc.state as PokemonsLoaded;
            String cardText = "${stateTest.pokemons.first.pokemonName}";
            Finder cardTextFinder = find.text(cardText.capitalize());
            Finder gestureFinder = find.ancestor(of: cardTextFinder, matching: find.byType(GestureDetector));

            Finder cardGrid = find.byKey(const Key("grid_card"));
            // Finder gestureFinder = find.ancestor(
            //     of: textGridWithKey, matching: find.byType(GestureDetector));

            /// existence of a grid with respective cards
            expect(find.byType(GridView), findsOneWidget);
            expect(textGrid, findsWidgets);
            expect(gestureFinder, findsOneWidget);

            /// tap a particular card
            await widgetTester.tap(gestureFinder);
            for (int i = 0; i < 5; i++) {
              /// rebuild the frame
              await widgetTester.pump(const Duration(seconds: 1));
            }

            /// verify if you have moved to pokemons detail screen
            expect(cardGrid, findsNothing);
            expect(find.byKey(const Key('single_pokemon_column')), findsOneWidget);
            expect(find.byKey(const Key('single_pokemon_text_name')), findsOneWidget);
            expect(find.text("Janda0"), findsOneWidget);
          });
    });
  });
}
