import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

Future<void> saveHistoryToFile(List<Map<String, dynamic>> imageHistory) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/imageHistory.json');
  
  String jsonHistory = jsonEncode(imageHistory);
  await file.writeAsString(jsonHistory);
}

  Future<void> saveProcessedImageLocally(Uint8List imageData) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/processed_image.png'; // Ruta del archivo
      final file = File(filePath);

      await file.writeAsBytes(imageData); // Guardar los datos de la imagen en el archivo
      print("Imagen guardada en: $filePath");
    } catch (e) {
      print("Error guardando la imagen: $e");
    }
  }

Future<List<Map<String, dynamic>>> loadHistoryFromFile() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/imageHistory.json');
  
  if (await file.exists()) {
    String jsonHistory = await file.readAsString();
    List<dynamic> historyList = jsonDecode(jsonHistory);
    return historyList.map((e) => e as Map<String, dynamic>).toList();
  } else {
    return [];
  }
}