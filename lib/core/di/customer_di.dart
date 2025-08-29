// import 'package:get_it/get_it.dart';
// import 'package:rido_v2/features/customer_profile/data/data_provider/customer_data_provider.dart';
// import 'package:rido_v2/features/customer_profile/data/repository/customer_repository.dart';
// import 'package:rido_v2/features/customer_profile/domain/repository/customer_repository.dart';
// import 'package:rido_v2/features/customer_profile/domain/usecases/customer_use_case.dart';
// import 'package:rido_v2/features/customer_profile/presentation/bloc/customer_bloc.dart';
//
// void invokeCustomerDI({required GetIt locator}) {
//   // data source
//   locator.registerLazySingleton<CustomerRemoteDataSource>(
//           () => CustomerRemoteDataSourceImpl(dio: locator()));
//
//   // repository
//   locator.registerLazySingleton<CustomerRepository>(
//           () => CustomerRepositoryImpl(remoteDataSource: locator()));
//
//   // use case
//   locator.registerLazySingleton(() => CustomerProfileUseCase(repository: locator()));
//
//   // bloc
//   locator.registerFactory(
//       () => CustomerBloc(useCase: locator()));
//
// }
