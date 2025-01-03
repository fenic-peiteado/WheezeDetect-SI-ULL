import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child; // Contenido que estará sobre el fondo

  const GradientBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade200,
            Colors.white,
          ],
        begin: Alignment.topCenter,    // Dirección inicial
        end: Alignment.bottomCenter,   // Dirección final
        ),
      ),
      child: child, // Contenido que estará sobre el fondo
    );
  }
}
