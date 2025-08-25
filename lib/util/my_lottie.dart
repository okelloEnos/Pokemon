import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MyLottie extends StatefulWidget {
  final String lottie;
  final Size size;
  final bool shouldPlay;
  final bool playOnce;
  final bool reverse;
  final Duration? delay;
  final BoxFit? fit;

  const MyLottie(
      {Key? key,
      required this.lottie,
      required this.size,
      this.fit,
      this.shouldPlay = true,
      this.playOnce = false,
      this.delay,
      this.reverse = true}) : super(key: key);

  @override
  State<MyLottie> createState() => _MyLottieState();
}

class _MyLottieState extends State<MyLottie> with TickerProviderStateMixin {
  late final AnimationController _lottieController;

  @override
  void initState() {
    super.initState();

    _lottieController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(widget.lottie,
        alignment: Alignment.center,
        animate: widget.shouldPlay,
        fit: widget.fit,
        reverse: widget.reverse,
        width: widget.size.width,
        height: widget.size.height,
        controller: _lottieController, onLoaded: (composition) {
      _lottieController.duration = composition.duration;
      if (widget.delay != null) {
        Future.delayed(widget.delay!).then((value) {
          _lottieController.forward();
        });
      } else {
        _lottieController.forward();
      }

      if (!widget.playOnce) {
        _lottieController.repeat();
      }
    });
  }
}
