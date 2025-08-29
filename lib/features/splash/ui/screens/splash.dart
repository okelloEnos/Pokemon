import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core_barrel.dart';
import '../../../features_barrel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController? _logoAnimationController;

  startNextScreen() async {
    await _logoAnimationController!.reverse();
    if (mounted) {
      context.pushReplacement("/gallery");
    }
  }

  @override
  void initState() {
    super.initState();

    _logoAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));

    startTime();
  }

  startTime() {
    var duration = const Duration(seconds: 4);
    return Timer(duration, startNextScreen);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: theme.colorScheme.primary),
      child: Scaffold(
        key: const Key("splash_screen"),
        extendBody: true,
        backgroundColor: Color(pokemonColorValues.secondaryColor),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Positioned(
                  top: 100.0,
                  left: 0.0,
                  right: 0.0,
                  child: const SplashImage().animate().fadeIn().then().scale(
                    duration: const Duration(milliseconds: 800)
                  )),
              Positioned(
                  bottom: 50.0,
                  left: 0.0,
                  right: 0.0,
                  child: Center(
                      child: CustomTextWidget(
                    text: "Creature Codex",
                    color: theme.colorScheme.onPrimary,
                    fontSize: 28.0,
                        fontFamily: "Ewert",
                        letterSpacing: 2.5,

                  ).animate(
                        delay: const Duration(milliseconds: 300)
                      ).fadeIn().then().moveY(
                      begin: 100.0, end: 0.0, duration: const Duration(milliseconds: 800)
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
