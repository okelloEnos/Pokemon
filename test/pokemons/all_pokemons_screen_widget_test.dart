import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon/pokemons/bloc/pokemon_bloc_util.dart';
import 'package:pokemon/pokemons/presentation/screens/all_pokemons_screen.dart';
import 'package:pokemon/pokemons/presentation/widgets/pokemons_grid.dart';

import 'bloc/pokemon_bloc_test.dart';

class MockPokemonBloc extends MockBloc<PokemonEvents, PokemonStates> implements PokemonsBloc{}

class PokemonsFakeEvents extends Fake implements PokemonEvents{}

class PokemonsFakeStates extends Fake implements PokemonStates{}

class MockBuildContext extends Mock implements BuildContext{}

void main(){

  /// make a widget testable by providing material info
  Widget makeTestableWidget({required Widget child}){
    return MaterialApp(
      home: child,
    );
  }

  /// registerFallbackValue registers types Value to allow usage of Any where the value is expected
  // setUpAll(() {
  //   registerFallbackValue<AuthenticationState>(AuthenticationStateFake());
  //   registerFallbackValue<AuthenticationEvent>(AuthenticationEventFake());
  // });

  group("all pokemons screen widgets", () {

    testWidgets("testing AllPokemonsScreen() widgets with success", (WidgetTester tester) async{
      /// instantiate the mocked pokemon bloc
      final pokemonMockBloc = MockPokemonBloc();
      /// place a successful state when launching
      when(() => pokemonMockBloc.state).thenReturn(PokemonsLoaded());
      /// instantiating the Widget Screen for all Pokemons
      AllPokemonsScreen allPokemonsScreen = const AllPokemonsScreen();
      /// wrap the all screen with a bloc provider
      final allPokemonScreenWithBloc = BlocProvider<PokemonsBloc>(
        create: (context) => pokemonMockBloc ,
        child: makeTestableWidget(child: allPokemonsScreen),);
      await tester.pumpWidget(allPokemonScreenWithBloc);
      Finder gridViewFinder = find.byKey(const Key("pokemon_grid"));
      Finder failTextFinder = find.byKey(const Key("error"));
      Finder loaderFinder = find.byKey(const Key("pokemon_loading"));

      expect(gridViewFinder, findsOneWidget);
      expect(failTextFinder, findsNothing);
      expect(loaderFinder, findsNothing);
    });


    testWidgets("testing AllPokemonsScreen() widgets with failure", (WidgetTester tester) async{
      /// instantiate the mocked pokemon bloc
      final pokemonMockBloc = MockPokemonBloc();
      /// place a successful state when launching
      when(() => pokemonMockBloc.state).thenReturn(PokemonsFailure(errorText: 'errorText'));
      /// instantiating the Widget Screen for all Pokemons
      AllPokemonsScreen allPokemonsScreen = const AllPokemonsScreen();
      /// wrap the all screen with a bloc provider
      final allPokemonScreenWithBloc = BlocProvider<PokemonsBloc>(
        create: (context) => pokemonMockBloc ,
        child: makeTestableWidget(child: allPokemonsScreen),);
      await tester.pumpWidget(allPokemonScreenWithBloc);
      Finder failTextFinder = find.byKey(const Key("error"));
      Finder loaderFinder = find.byKey(const Key("pokemon_loading"));
      Finder gridViewFinder = find.byKey(const Key("pokemon_grid"));

      expect(failTextFinder, findsOneWidget);
      expect(loaderFinder, findsNothing);
      expect(gridViewFinder, findsNothing);
    });

    testWidgets("All Screen Pokemons Loading..", (widgetTester)async{
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

    testWidgets("grids card widgets", (widgetTester) async{
      final buildContext = MockBuildContext();
      final pokemon = MockPokemonInfo();

      when(() => pokemon.pokemonName).thenReturn(pokemonName);
      when(() => pokemon.pokemonWeight).thenReturn(pokemonWeight);
      when(() => pokemon.pokemonHeight).thenReturn(pokemonHeight);
      when(() => pokemon.sprites).thenReturn(sprites);
      // when(() => pokemon.moves).thenReturn(moves);
      // when(() => pokemon.stats).thenReturn(stats);
      // when(() => pokemon.abilities).thenReturn(abilities);


      final gridCard = pokemonCard(buildContext, pokemon);

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
  });
}