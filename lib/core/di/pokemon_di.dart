import 'package:get_it/get_it.dart';

import '../../features/features_barrel.dart';

void invokePokemonDI({required GetIt locator}) {
  // data source
  locator.registerLazySingleton<GalleryRemoteDataSource>(
          () => GalleryRemoteDataSourceImpl(dio: locator()));

  // repository
  locator.registerLazySingleton<GalleryRepository>(
          () => GalleryRepositoryImpl(remoteDataSource: locator()));

  // use case
  // locator.registerLazySingleton(() => CustomerProfileUseCase(repository: locator()));

  // bloc
  locator.registerFactory(
      () => PokemonsBloc(pokemonRepository: locator()));

}
