import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pokemon/pokemons/bloc/gallery_view/gallery_view_cubit.dart';
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // const Spacer(),
              Text('Creature Gallery', style: theme.textTheme.titleLarge,),
              // const Spacer(),
              const SizedBox(width: 8.0),
              BlocBuilder<GalleryViewCubit, ViewType>(builder: (context, state){
                return state == ViewType.grid ?
                GestureDetector(
                    onTap: (){
                      context.read<GalleryViewCubit>().toggleView(ViewType.list);
                    },
                    child: Icon(Icons.list, color: theme.colorScheme.primary, size: 32,)) :
                GestureDetector(
                    onTap: (){
                      context.read<GalleryViewCubit>().toggleView(ViewType.grid);
                    },
                    child: Icon(Icons.grid_view_outlined, color: theme.colorScheme.primary));
              }),
            ],
          ),
        ),
        body: BlocBuilder<PokemonsBloc, PokemonStates>(builder: (context, state){
      if(state is PokemonsLoaded){
        return  AllPokemonsGrid(state: state);
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
