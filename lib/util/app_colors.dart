import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/util/swatch_colors.dart';

class PokemonColorValues{
  final primaryColor = 0XFFFFD600;
  final secondaryColor = 0XFF0A1045;
  final thirdColor = 0XFFEDEDED;
  final backgroundColor = 0XFFFFFFFF;
  final cardColor = 0XFFFFF59D;
}

final PokemonColorValues pokemonColorValues = PokemonColorValues();
final SwatchColors swatchColors = SwatchColors();

final lightThemeData = ThemeData(
  primaryColor: Color(pokemonColorValues.primaryColor),
  primaryColorDark: Color(pokemonColorValues.secondaryColor),
  primaryColorLight: Color(pokemonColorValues.thirdColor),
  primarySwatch: swatchColors.lightPrimarySwatch,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  brightness: Brightness.light,
  backgroundColor: Color(pokemonColorValues.backgroundColor),
  cardColor: Color(pokemonColorValues.cardColor),
  floatingActionButtonTheme:  FloatingActionButtonThemeData(
    foregroundColor: Color(pokemonColorValues.secondaryColor),
    backgroundColor: swatchColors.lightPrimarySwatch[600]
  ),

  tabBarTheme: TabBarTheme(
    labelColor: Color(pokemonColorValues.secondaryColor),
    labelStyle: TextStyle(fontFamily: 'Lemonada', fontWeight: FontWeight.bold, fontSize: 12, color: Color(pokemonColorValues.secondaryColor)),
    unselectedLabelColor: Colors.black54,
    unselectedLabelStyle: TextStyle(fontFamily: 'Lemonada', fontSize: 13, color: Color(pokemonColorValues.secondaryColor)),
  ),
  textTheme: TextTheme(
    headline5: TextStyle(fontFamily: 'Ewert', fontWeight: FontWeight.bold, color: Color(pokemonColorValues.secondaryColor)),
    headline6: TextStyle(color: Color(pokemonColorValues.secondaryColor)),
    subtitle1: TextStyle(fontFamily: 'Lemonada', fontSize: 18, color: Color(pokemonColorValues.secondaryColor)),
      subtitle2: TextStyle(fontFamily: 'Lemonada', fontSize: 16,fontWeight: FontWeight.bold, color: Color(pokemonColorValues.secondaryColor)),
      bodyText1: TextStyle(fontFamily: 'Lemonada', fontSize: 14, color: Color(pokemonColorValues.secondaryColor))
  ),
  buttonTheme: ButtonThemeData(buttonColor: Color(pokemonColorValues.secondaryColor)),
  indicatorColor: Color(pokemonColorValues.primaryColor)
);