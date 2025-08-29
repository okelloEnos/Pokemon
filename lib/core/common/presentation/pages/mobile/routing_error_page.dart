import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core_barrel.dart';


class RoutingErrorPage extends StatelessWidget {
  final GoRouterState goRouterState;
  const RoutingErrorPage({Key? key,  required this.goRouterState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextWidget(
              text: "There was an issue experienced while accessing the next screen kindly contact the customer support.",
              textAlign: TextAlign.center,
              color: theme.hintColor,
            ),
            const SizedBox(height: 40.0,),
            GestureDetector(onTap: (){
              // context.push("/need_help");
            }, child: CustomTextWidget(text: "Need help?",
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
              fontSize: 14.0,
            )),
          ],
        ),
      ),
    );
  }
}
