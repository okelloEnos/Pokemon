import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pokemon/pokemons/bloc/pokemon_bloc_util.dart';
import 'package:pokemon/pokemons/presentation/widgets/pokemons_grid.dart';
import 'package:pokemon/util/global_widgets.dart';

class AllPokemonsScreen extends StatelessWidget {
  const AllPokemonsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // timeDilation = 3.0;
   return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Pokemons', style: theme.textTheme.headline5,)),
        ),
        body: BlocBuilder<PokemonsBloc, PokemonStates>(builder: (context, state){
      if(state is PokemonsLoaded){
        return  allPokemonsGrid(state.pokemons);
      }
      else if(state is PokemonsFailure){
        return Center(child: Text(state.errorText, key: const Key("error"),));
      }
      return itemsLoadingWidget(color: theme.primaryColorDark);
    },
    ),
   );
  }
}
