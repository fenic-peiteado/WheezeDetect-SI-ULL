import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whezzedetect/shared/models/widgets/background_gradient.dart';
import '../../shared/models/app_state.dart';
import '../../shared//models/widgets/elevated_contend_Card.dart';

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    final colorScheme = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;

    return GradientBackground(
      child: Scaffold(
        // backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Home'),
          backgroundColor: colorScheme.primaryContainer,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                ElevatedContentCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'This app is a Flutter project that uses a pre-trained machine learning model to detect pneumonia.',
                        style: typography.bodyLarge?.copyWith(
                          // fontWeight: FontWeight.bold, // Removido para no estar todo en negrita
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'How to Use:',
                        style: typography.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold, // Solo el título en negrita
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '1. Upload an image of a chest X-ray by clicking "Select Image".',
                        style: typography.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '2. After the image is uploaded, click "Analyze" to process it and get results.',
                        style: typography.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
