import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/models/app_state.dart';
import 'image_card.dart';

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    IconData icon = appState.favorites.contains(pair) ? Icons.auto_awesome : Icons.dangerous_outlined;
    const  String imagePath = 'assets/images/image_with_pneumonia.jpeg';
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageCard(imagePath: imagePath),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: appState.getNext,
                  child: Text('Subirr Imagen'),
                ),
                ElevatedButton.icon(
                  onPressed: appState.toggleFavorite,
                  icon: Icon(icon),
                  label: Text('Analizar Imagen'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
