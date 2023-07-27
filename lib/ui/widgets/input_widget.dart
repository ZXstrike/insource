import 'package:flutter/material.dart';

class TextInputSpace extends StatelessWidget {
  final double verticalOutterPadding;
  final double horizontalOutterPadding;
  final double verticalContentPadding;
  final double horizontalContentPadding;
  final double radius;
  final TextEditingController? inputController;
  final bool hideInput;
  final String? inputHint;
  final TextStyle? inputHintStyle;

  const TextInputSpace(
      {super.key,
      this.verticalOutterPadding = 0,
      this.horizontalOutterPadding = 0,
      this.verticalContentPadding = 5,
      this.horizontalContentPadding = 10,
      this.radius = 0,
      this.inputController,
      this.hideInput = false,
      this.inputHint,
      this.inputHintStyle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalOutterPadding,
        vertical: verticalOutterPadding,
      ),
      child: TextField(
        controller: inputController,
        obscureText: hideInput,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              horizontal: horizontalContentPadding,
              vertical: verticalContentPadding),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          hintText: inputHint,
          filled: true,
          fillColor: Colors.white,
          hintStyle: inputHintStyle,
        ),
      ),
    );
  }
}

class ButtonSpace extends StatelessWidget {
  final Widget child;
  final Color boxColor;
  final double padding;
  final double radius;
  final double verticalOutterPadding;
  final double horizontalOutterPadding;
  final void Function()? onPressed;

  const ButtonSpace({
    super.key,
    required this.child,
    this.boxColor = Colors.white,
    this.padding = 10,
    this.radius = 10,
    this.verticalOutterPadding = 0,
    this.horizontalOutterPadding = 0,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: verticalOutterPadding, horizontal: horizontalOutterPadding),
      child: GestureDetector(
        onTap: onPressed,
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(padding),
            color: boxColor,
            child: child,
          ),
        ),
      ),
    );
  }
}

class TextButtonSpace extends StatelessWidget {
  final String text;
  final Color? textColor;
  final String textButton;
  final Color? textButtonColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final MainAxisAlignment mainAlignment;
  final CrossAxisAlignment crossAlignment;
  final void Function()? onPressed;

  const TextButtonSpace({
    super.key,
    this.text = '',
    required this.textButton,
    required this.onPressed,
    this.textColor,
    this.textButtonColor,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
    required this.mainAlignment,
    required this.crossAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAlignment,
      crossAxisAlignment: crossAlignment,
      children: [
        Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontFamily: fontFamily,
          ),
        ),
        GestureDetector(
          onTap: onPressed,
          child: Text(
            textButton,
            style: TextStyle(
              color: textButtonColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontFamily: fontFamily,
            ),
          ),
        ),
      ],
    );
  }
}

