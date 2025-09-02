import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';
import 'core/core_barrel.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await setUpLocator();
  runApp(const PokemonsApp());
}
