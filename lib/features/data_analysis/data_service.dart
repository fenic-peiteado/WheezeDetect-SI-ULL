import 'dart:convert';
import 'package:http/http.dart' as http;

class DataService {
  static const String url = 'https://03a2-34-86-192-105.ngrok-free.app/receive_data';

  static Future<String> sendData(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['message'] ?? 'Datos enviados con éxito';
      } else {
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error de conexión: $e';
    }
  }
}
