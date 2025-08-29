import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

CustomTransitionPage pageBuilderWithTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
  PageTransitionType? transitionType,
  int? duration,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: Duration(milliseconds: duration ?? 500),
    reverseTransitionDuration: Duration(milliseconds: duration ?? 500),
    transitionsBuilder: ((context, animation, secondaryAnimation, child) {
      return PageTransition(
        child: child,
        type: transitionType ?? PageTransitionType.rightToLeftWithFade,
        alignment: Alignment.center,
      ).buildTransitions(
        context,
        animation,
        secondaryAnimation,
        child,
      );
    }),
  );
}
