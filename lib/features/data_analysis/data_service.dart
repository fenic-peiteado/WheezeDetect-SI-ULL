import 'dart:convert';
import 'package:http/http.dart' as http;

class DataService {
  // Este CODIGO YA NO ES NECESARIO
  static const String url = 'https://df2b-34-16-149-200.ngrok-free.app/receive_data';

  static Future<String> sendData(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['message'] ?? 'Data sent successfully';
      } else {
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error of connection: $e';
    }
  }
}
