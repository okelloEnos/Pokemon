import 'package:bloc/bloc.dart';

class PokemonBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    print("Bloc has been created");
  }

  @override
  void onClose(BlocBase bloc) {
    print("Bloc has been closed");
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print("Bloc has an error");
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print("Bloc transition has happened");
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    print("Bloc change has happened");
  }

// @override
// void onEvent(Bloc bloc, Object event) {
//
// }
}
