import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextAlign? textAlign;
  final bool? isRequired;
  final int? maxLines;
  final double? letterSpacing;
  const CustomTextWidget({Key? key, required this.text, this.color,
    this.fontSize, this.fontWeight, this.fontFamily, this.textAlign,
    this.isRequired, this.maxLines, this.letterSpacing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (isRequired ?? false) ?  Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
            text,
            textAlign: textAlign ?? TextAlign.start,
            maxLines: maxLines,
            style: TextStyle(
              color: color ?? Theme.of(context).colorScheme.primary,
              fontWeight: fontWeight ?? FontWeight.normal,
              fontSize: fontSize ?? 16.0,
              fontFamily: fontFamily ?? 'DM Sans',
            )),
        const SizedBox(width: 1.0,),
        Text(
           "*",
           style: TextStyle(
              color: color ?? Theme.of(context).colorScheme.primary,
              fontWeight: fontWeight ?? FontWeight.normal,
              fontSize: fontSize ?? 16.0,
              fontFamily: fontFamily ?? 'DM Sans',
            )
        ),
      ],
    ) : Text(
        text,
        textAlign: textAlign ?? TextAlign.start,
        maxLines: maxLines,
        style: TextStyle(
          color: color ?? Theme.of(context).colorScheme.primary,
          fontWeight: fontWeight ?? FontWeight.normal,
          fontSize: fontSize ?? 16.0,
          fontFamily: fontFamily ?? 'DM Sans',
          letterSpacing: letterSpacing,
        ));
  }
}

