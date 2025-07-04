import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlackFadeTransition extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve? curve,
      Alignment? alignment,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return FadeTransition(
      opacity: animation,
      child: ColoredBox(
        color: Colors.black,
        child: child,
      ),
    );
  }
}