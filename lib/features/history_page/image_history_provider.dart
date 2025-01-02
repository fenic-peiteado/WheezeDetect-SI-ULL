import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Para SharedPreferences
import 'package:path_provider/path_provider.dart'; // Para acceder al almacenamiento local

class ImageHistoryProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _imageHistory = [];

  List<Map<String, dynamic>> get imageHistory => _imageHistory;

  ImageHistoryProvider() {
    _loadHistory(); // Cargar historial cuando se inicia la aplicación
  }

  // Método para cargar el historial desde el almacenamiento local
  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    String? historyData = prefs.getString('imageHistory');
    
    if (historyData != null) {
      List<dynamic> historyList = json.decode(historyData);
      _imageHistory = List<Map<String, dynamic>>.from(historyList);
      notifyListeners();
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
    _imageHistory.add(newItem);
    _saveHistory(); // Guardar después de añadir un nuevo análisis
    notifyListeners();
  }

  // Método para eliminar un elemento del historial (si es necesario)
  void removeFromHistory(int index) {
    _imageHistory.removeAt(index);
    _saveHistory(); // Guardar después de eliminar un análisis
    notifyListeners();
  }
}
