import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../history_page/image_history_provider.dart';

class DataAnalysisPage extends StatefulWidget {
  @override
  DataAnalysisPageState createState() => DataAnalysisPageState();
}

class DataAnalysisPageState extends State<DataAnalysisPage> {
  String resultText = '';
  File? _imageFile;
  Uint8List? _webImage;
  Uint8List? processedImage;

  // Método para enviar la imagen y obtener el resultado del análisis
  Future<void> sendData() async {
    if (_imageFile == null && _webImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image before analyzing.')),
      );
      return;
    }

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://735a-34-81-220-1.ngrok-free.app/process-image'),
      );

      if (kIsWeb) {
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          _webImage!,
          filename: 'image.png',
        ));
      } else {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          _imageFile!.path,
        ));
      }

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final responseBody = json.decode(responseData.body);
        Provider.of<ImageHistoryProvider>(context, listen: false).addToHistory({
          'image': kIsWeb
              ? base64Encode(_webImage!)
              : base64Encode(File(_imageFile!.path).readAsBytesSync()),
          'result': responseBody['result'],
          'processedImage': base64Decode(responseBody['processed_image']),
        });
        setState(() {
          resultText = responseBody['result'];
          processedImage = base64Decode(responseBody['processed_image']);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Método para seleccionar la imagen desde la galería
  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final webImage = await pickedFile.readAsBytes();
        setState(() {
          _webImage = webImage;
        });
      } else {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Data Analysis'),
    ),
    body: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mostrar la imagen seleccionada si está disponible
            if (_webImage != null)
              Image.memory(
                _webImage!,
                width: 300,
                height: 300,
              )
            else if (_imageFile != null)
              Image.file(
                _imageFile!,
                width: 300,
                height: 300,
              ),

            // Espaciado para separar los botones
            SizedBox(height: 20),

            // Fila de botones
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Centra los botones
              children: [
                // Botón para seleccionar la imagen
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ElevatedButton(
                    onPressed: pickImage,
                    child: Text('Select Image'),
                  ),
                ),

                // Botón para analizar la imagen
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ElevatedButton(
                    onPressed: sendData,
                    child: Text('Analyze'),
                  ),
                ),
              ],
            ),

            // Mostrar el resultado del análisis si existe
            if (resultText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  children: [
                    Text(
                      'Analysis Result:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      resultText,
                      style: TextStyle(fontSize: 18),
                    ),

                    // Mostrar la imagen procesada si está disponible
                    if (processedImage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Image.memory(
                          processedImage!,
                          width: 300,
                          height: 300,
                        ),
                      ),
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