import 'package:flutter/material.dart';

class SplashImage extends StatelessWidget {
  const SplashImage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/images/app_launcher.png", width: 200.0, height: 250.0, fit: BoxFit.contain);
  }
}

