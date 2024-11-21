import 'package:flutter/material.dart';

class CustomRoutes<T> extends MaterialPageRoute<T> {
  CustomRoutes({required super.builder, super.settings});

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }
}

class CustomPageTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
   
    // if (route.settings.name == '/auth') {
    //   return child;
    // }

    return FadeTransition(opacity: animation, child: child);
  }
}