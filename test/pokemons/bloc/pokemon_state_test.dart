import 'package:pokemon/pokemons/bloc/pokemon_bloc_util.dart';
import 'package:test/test.dart';

void main(){
  group("Pokemons State X", (){
    
    test("returns correct values for PokemonStatusInitial()", (){
     var status = PokemonsInitial();
      expect(status.isInitial, isTrue);
      expect(status.isLoaded, isFalse);
      expect(status.isFailure, isFalse);
    });
  });

  test("returns true for status.Loaded", (){
    var status = PokemonsLoaded();
    expect(status.isInitial, isFalse);
    expect(status.isLoaded, isTrue);
    expect(status.isFailure, isFalse);
  });

  test("returns true for status.failure", (){
    var status = PokemonsFailure(errorText: 'errorText');
    expect(status.isInitial, isFalse);
    expect(status.isLoaded, isFalse);
    expect(status.isFailure, isTrue);
  });
}