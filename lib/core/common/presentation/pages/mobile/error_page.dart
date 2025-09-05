import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../features/features_barrel.dart';
import '../../../../core_barrel.dart';

class CreatureCodexErrorWidget extends StatelessWidget {
  final String? message;
  final double? size;
  final String? description;
  final Size? minimumBtnSize;
  final VoidCallback? onRetry;
  final String? btnText;
  final double? fontSize;
  const CreatureCodexErrorWidget({Key? key, this.message, this.size, this.description, this.minimumBtnSize, this.onRetry, this.btnText, this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: MyLottie(
            lottie: 'assets/lottie/error.json',
            size: Size(size ?? 250, size ?? 250),
          ),
        ),
        // const SizedBox(height: 8.0,),
        Text(description ?? "Well, that was unexpected. Give it another shot.",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: fontSize),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16.0,),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Theme.of(context).colorScheme.primary),
            minimumSize: minimumBtnSize ?? const Size(200, 45)
          ),
            onPressed: onRetry ?? (){
              context.read<PokemonsBloc>().add(PokemonsFetched());
            },
            child: Text("Retry", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: fontSize)))
      ],
    );
  }
}


