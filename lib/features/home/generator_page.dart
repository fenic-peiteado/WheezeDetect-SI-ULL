import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/models/app_state.dart';
import 'image_card.dart';

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Línea superior gruesa
              ImageCard(
                imagePath: 'assets/icons/icono_sin_fondo.png',
                width: 300,
                height: 300,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Thiss app is a Flutter project that uses a pre-trained machine learning model to detect pneumonia.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'How to Use:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '1. Upload an image of a chest X-ray by clicking "Upload Image".\n'
                      '2. After the image is uploaded, click "Analyze Image" to process it and get results.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
