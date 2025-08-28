import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/pokemons/bloc/pokemon_bloc_util.dart';
import 'package:pokemon/pokemons/data/data_service/data_service_provider.dart';
import 'package:pokemon/pokemons/data/models/pokemon_model_util.dart';
import 'package:pokemon/pokemons/data/repository/pokemon_repository.dart';
import 'package:pokemon/pokemons/presentation/screens/all_pokemons_screen.dart';
import 'package:pokemon/pokemons/presentation/screens/single_pokemon_screen.dart';
import 'package:pokemon/splash/splash_barrel.dart';
import 'package:pokemon/util/app_colors.dart';
import 'package:pokemon/util/app_route.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PokemonsApp extends StatelessWidget {
  const PokemonsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      headerBuilder: () => const WaterDropHeader(),
      footerBuilder:  () => const ClassicFooter(),
      headerTriggerDistance: 80.0,
      springDescription: const SpringDescription(stiffness: 170, damping: 16, mass: 1.9),
      maxOverScrollExtent : 100,
      maxUnderScrollExtent: 0,
      enableScrollWhenRefreshCompleted: true,
      enableLoadingWhenFailed : true,
      hideFooterWhenNotFull: false,
      enableBallisticLoad: true,
      child: MaterialApp.router(
        title: "Creature Codex",
        routerDelegate: appRouter.routerDelegate,
        routeInformationParser: appRouter.routeInformationParser,
        routeInformationProvider: appRouter.routeInformationProvider,
        debugShowCheckedModeBanner: false,
        theme: lightThemeData,
        darkTheme: lightThemeData,
        themeMode: ThemeMode.light,
      ),
    );
  }
}
