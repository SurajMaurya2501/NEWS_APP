import 'package:flutter/material.dart';

class CustomPageRouteBuilder extends PageRouteBuilder {
  final Widget page;

  CustomPageRouteBuilder({required this.page})
      : super(
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve,),);

              var offsetAnimation = animation.drive(tween);

              return FadeTransition(
                opacity: animation,
                // position: offsetAnimation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 300));
}
