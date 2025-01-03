import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageHistoryProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _imageHistory = [];

  List<Map<String, dynamic>> get imageHistory => _imageHistory;

  ImageHistoryProvider() {
    _loadHistory(); // Cargar historial al iniciar
  }

  // Método para cargar el historial desde el almacenamiento local
  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    String? historyData = prefs.getString('imageHistory');

    if (historyData != null) {
      try {
        List<dynamic> historyList = json.decode(historyData);

        // Validar que cada elemento tenga las claves necesarias
        _imageHistory = historyList.map<Map<String, dynamic>>((item) {
          return {
            'image': item['image'],
            'result': item['result'],
            'processedImage': item['processedImage'],
            'date': item['date'] ?? 'Unknown Date', // Proveer fecha predeterminada
          };
        }).toList();

        notifyListeners();
      } catch (e) {
        // Manejar errores de deserialización
        print('Error loading history: $e');
      }
    }
  }

  // Método para guardar el historial en el almacenamiento local
  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    String historyData = json.encode(_imageHistory);
    prefs.setString('imageHistory', historyData);
  }

  // Método para agregar un nuevo elemento al historial
  void addToHistory(Map<String, dynamic> newItem) {
    _imageHistory.add({
      ...newItem,
      'date': newItem['date'] ?? DateTime.now().toString(), // Garantizar fecha
    });
    _saveHistory(); // Guardar después de añadir
    notifyListeners();
  }

  // Método para eliminar un elemento del historial
  void removeFromHistory(int index) {
    _imageHistory.removeAt(index);
    _saveHistory(); // Guardar después de eliminar
    notifyListeners();
  }
}
