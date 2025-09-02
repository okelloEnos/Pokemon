import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../features/features_barrel.dart';
import '../../../../core_barrel.dart';

class CreatureCodexErrorWidget extends StatelessWidget {
  final String? message;
  const CreatureCodexErrorWidget({Key? key, this.message }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 32.0),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 32.0, top: 0.0, left: 16.0, right: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: MyLottie(
                lottie: 'assets/lottie/error.json',
                size: Size(250, 250),
              ),
            ),
            // const SizedBox(height: 8.0,),
            Text("Well, that was unexpected. Give it another shot. \n ${message ?? ""}",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0,),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).colorScheme.primary),
                minimumSize: const Size(200, 45)
              ),
                onPressed: (){
                  context.read<PokemonsBloc>().add(PokemonsFetched());
                },
                child: Text("Retry", style: Theme.of(context).textTheme.bodyLarge))
          ],
        ),
      ),
    );
  }
}
