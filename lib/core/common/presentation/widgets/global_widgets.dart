import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget imagePlaceHolder({required Color color, double? size}){
  return Center(child: SpinKitSpinningLines(
    color: color,
    size: size ?? 50.0,
  ),);
}

Widget itemsLoadingWidget({required Color color, double? size}){
  return Center(child: SpinKitRipple(
    key: const Key("pokemon_loading"),
    color: color,
    size: size ?? 50.0,
  ),);
}

Widget imageErrorWidget({double? size}){
  return SvgPicture.asset(
    'assets/images/svg-logo.svg',
    key: const Key("image_error"),
    height: size ?? 100,
    width: size ?? 100,
    fit: BoxFit.contain,
    color: Colors.grey.shade300,
    colorBlendMode: BlendMode.srcIn,
    // colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),

  );
}