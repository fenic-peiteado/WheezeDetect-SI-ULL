import 'package:flutter/material.dart';

class ElevatedContentCard extends StatelessWidget {
  final String? text;
  final Widget? image;
  final Widget? child; // Permite contenido personalizado
  final double elevation;
  final EdgeInsetsGeometry padding;

  const ElevatedContentCard({
    Key? key,
    this.text,
    this.image,
    this.child,
    this.elevation = 5.0,
    this.padding = const EdgeInsets.all(16.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;

    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Bordes más redondeados
      ),
      // color: colorScheme.surface, // Usa el color de superficie del tema
      color: colorScheme.surface, // Usa el color de superficie del tema
      child: Padding(
        padding: padding,
        child: child ??
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center, // Centra el contenido
              children: [
                if (text != null)
                  Text(
                    text!,
                    style: typography.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                if (text != null && image != null) SizedBox(height: 12),
                if (image != null) image!,
              ],
            ),
      ),
    );
  }
}
