import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerWidget(
      {Key? key,  required this.child, this.baseColor, this.highlightColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Shimmer.fromColors(
      baseColor: baseColor ?? theme.colorScheme.onPrimary,
      highlightColor: highlightColor ?? theme.scaffoldBackgroundColor,
      child: child,
    );
  }
}

class ShimmerContainer extends StatelessWidget {
  final double width;
  final double height;
  final Color? baseColor;
  final Color? highlightColor;
  final double borderRadius;

  const ShimmerContainer(
      {Key? key,
      required this.width,
      required this.height,
      this.baseColor,
      this.highlightColor,
      this.borderRadius = 20.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return ShimmerWidget(
      baseColor: baseColor ?? theme.scaffoldBackgroundColor,
      highlightColor: highlightColor ?? theme.colorScheme.onPrimary,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: baseColor ?? theme.scaffoldBackgroundColor,),
      ),
    );
  }
}

class ShimmerLine extends StatelessWidget {
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerLine({Key? key,  this.baseColor, this.highlightColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ShimmerContainer(
          baseColor: baseColor,
          highlightColor: highlightColor,
          width: double.infinity,
          height: 10.0,
          borderRadius: 4.0),
    );
  }
}

class ShimmerMultipleLines extends StatelessWidget {
  final int lines;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerMultipleLines(
      {Key? key,  required this.lines, this.baseColor, this.highlightColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(
          lines,
          (index) => Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: ShimmerLine(
                    baseColor: baseColor, highlightColor: highlightColor),
              )),
    );
  }
}
