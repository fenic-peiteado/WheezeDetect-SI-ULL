import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({
    super.key,
    required this.imagePath, // Ahora requiere la ruta de la imagen
    this.width = 300,        // Ancho por defecto
    this.height = 300,       // Alto por defecto
    this.fit = BoxFit.cover, // Ajuste por defecto
  });

  final String imagePath;
  final double width;
  final double height;
  final BoxFit fit;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          imagePath,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(
                Icons.broken_image,
                size: 48,
              ),
            );
          },
        ),
      ),
    );
  }
}