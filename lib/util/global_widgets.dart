import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget imagePlaceHolder({required Color color}){
  return Center(child: SpinKitSpinningLines(
    color: color,
    size: 50.0,
  ),);
}

Widget itemsLoadingWidget({required Color color}){
  return Center(child: SpinKitRipple(
    color: color,
    size: 50.0,
  ),);
}

final imageErrorWidget = Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Image.asset("assets/images/defaultpic.jpg"),);