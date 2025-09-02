import 'package:get_it/get_it.dart';

import '../core_barrel.dart';

final locator = GetIt.instance;

Future<void> setUpLocator() async {
  await invokeCoreDI(locator: locator);
  invokePokemonDI(locator: locator);
}
