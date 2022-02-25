import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon/pokemons/presentation/screens/single_pokemon_screen.dart';
import 'package:pokemon/pokemons/presentation/widgets/single_pokemon.dart';

import '../bloc/pokemon_bloc_test.dart';
import '../model/mock_pokemon_info.dart';
import 'all_pokemons_screen_widget_test.dart';

void main(){
  Widget makeTestableWidget({required Widget child}){
    return MaterialApp(
      home: child,
    );
  }

  group("Single Pokemons Widgets Tests", (){
    /// instantiating mocked params
    final context = MockBuildContext();
    var pokemon = MockPokemonInfo();

    /// adding pokemon info on mock
    when(() => pokemon.pokemonName).thenReturn(pokemonName);
    when(() => pokemon.pokemonHeight).thenReturn(pokemonHeight);
    when(() => pokemon.pokemonWeight).thenReturn(pokemonWeight);
    when(() => pokemon.sprites).thenReturn(sprites);
    when(() => pokemon.abilities).thenReturn(abilities);
    when(() => pokemon.species).thenReturn(species);
    when(() => pokemon.stats).thenReturn(stats);
    when(() => pokemon.moves).thenReturn(moves);

    /// instantiating finders for single pokemons
    /// general
    Finder columnFinder = find.byKey(const Key('single_pokemon_column'));
    Finder heroFinder = find.byKey(const Key('single_pokemon_hero'));
    Finder upperCardFinder = find.byKey(const Key('single_pokemon_card_image'));
    Finder backButtonFinder = find.byKey(const Key('single_pokemon_back_button'));
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
    Finder speciesFinder = find.byKey(const Key('single_pokemon_species_information'));
    Finder heightFinder = find.byKey(const Key('single_pokemon_height_information'));
    Finder weightFinder = find.byKey(const Key('single_pokemon_weight_information'));
    Finder experienceFinder = find.byKey(const Key('single_pokemon_experience_information'));
    Finder abilityFinder = find.byKey(const Key('single_pokemon_abilities_information'));
    /// stats widget
    Finder statBuilderFinder = find.byKey(const Key('single_pokemon_stats_builder'));
    Finder statFinder = find.byKey(const Key('single_pokemon_stats_information'));
    /// evolution widget
    Finder evolutionFinderGeneral = find.byKey(const Key('single_pokemon_evolution_information'));
    Finder cardEvolution = find.descendant(of: evolutionFinderGeneral, matching: find.byType(Card));
    /// moves widget
    Finder moveBuilderFinder = find.byKey(const Key('single_pokemon_moves_builder'));
    Finder moveFinder = find.byKey(const Key('single_pokemon_moves_information'));

    testWidgets("Single pokemon screen", (widgetTester) async{

      final singlePokemonScreen = SinglePokemonScreen(pokemon: pokemon);

      await widgetTester.pumpWidget(makeTestableWidget(child: singlePokemonScreen));

      expect(columnFinder, findsOneWidget);
      expect(heroFinder, findsOneWidget);
      expect(upperCardFinder, findsOneWidget);
      expect(backButtonFinder, findsOneWidget);
      expect(nameFinder, findsOneWidget);
      expect(carouselFinder, findsOneWidget);
      expect(tabsCardFinder, findsOneWidget);
      // expect(imageCarouselFinder, findsOneWidget);

    });

    testWidgets("pokemon image card holder tests", (widgetTester) async{

      await widgetTester.pumpWidget(makeTestableWidget(child: pokemonImageCard(context: context, image: "image", type: "type")));

      expect(imageFinder, findsOneWidget);
      expect(typeFinder, findsOneWidget);

    });

    testWidgets("Single Pokemons Tab widgets", (widgetTester) async{

      await widgetTester.pumpWidget(makeTestableWidget(child: PokemonsDetailsTab(pokemonInfo: pokemon)));

      expect(tabBarFinder, findsOneWidget);
      expect(tabViewFinder, findsOneWidget);
      // expect(movesWidgetFinder, findsOneWidget);

    });
    
    testWidgets('about tab widgets test', (widgetTester) async{

      await widgetTester.pumpWidget(makeTestableWidget(child: pokemonAboutWidget(pokemon: pokemon, context: context)));

      expect(speciesFinder, findsOneWidget);
      expect(heightFinder, findsOneWidget);
      expect(weightFinder, findsOneWidget);
      expect(experienceFinder, findsOneWidget);
      expect(abilityFinder, findsOneWidget);
    });

    testWidgets('Stats widget plus listView builder', (widgetTester) async{

      await widgetTester.pumpWidget(makeTestableWidget(child: pokemonStatsWidget(pokemon: pokemon, context: context)));

      expect(statBuilderFinder, findsOneWidget);
      expect(statFinder, findsWidgets);
    });

    testWidgets('evolution Widget ', (widgetTester) async{

      await widgetTester.pumpWidget(makeTestableWidget(child: pokemonEvolutionWidget(pokemon: pokemon, context: context)));

      expect(evolutionFinderGeneral, findsOneWidget);
      expect(cardEvolution, findsNothing);

    });

    testWidgets('moves widget plus listView builder', (widgetTester) async{

      await widgetTester.pumpWidget(makeTestableWidget(child: pokemonMovesWidget(pokemon: pokemon, context: context)));

      expect(moveBuilderFinder, findsOneWidget);
      expect(moveFinder, findsOneWidget);
    });
  });
}