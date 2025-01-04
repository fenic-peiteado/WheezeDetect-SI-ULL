import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:whezzedetect/shared/models/widgets/background_gradient.dart';
import '../history_page/image_history_provider.dart';
import '../../shared/models/widgets/elevated_contend_Card.dart';
import '../../shared/models/widgets/custom_button.dart';

class DataAnalysisPage extends StatefulWidget {
  @override
  _DataAnalysisPageState createState() => _DataAnalysisPageState();
}

class _DataAnalysisPageState extends State<DataAnalysisPage> {
  String resultText = '';
  File? _imageFile;
  Uint8List? _webImage;
  Uint8List? processedImage;
  bool isLoading = false; // Variable para controlar la carga

  // Método para enviar la imagen y obtener el resultado del análisis
  Future<void> sendData() async {
    if (_imageFile == null && _webImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image before analyzing.')),
      );
      return;
    }

    setState(() {
      isLoading = true; // Mostrar el indicador de carga
    });

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://handy-huge-glider.ngrok-free.app/process-image'),
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
          'processedImage': responseBody['processed_image'],
          'date': DateTime.now().toString(), // Agregar fecha y hora actual
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
    } finally {
      setState(() {
        isLoading = false; // Ocultar el indicador de carga
      });
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
    final colorScheme = Theme.of(context).colorScheme;
    return GradientBackground(
      child: Scaffold(
      //backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Data Analysis'),
        backgroundColor: colorScheme.primaryContainer,
      ),
      body: Center(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Center(
                  // ElevatedContentCard que contiene la imagen y los botones
                  child: ElevatedContentCard(
                    elevation: 5.0,
                    padding: EdgeInsets.all(8.0),
                    child: Column(
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
                        
                        SizedBox(height: 20),

                        // Fila de botones
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Botón para seleccionar la imagen
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: CustomButton(
                                label: 'Select Image',
                                onPressed: pickImage,
                              ),
                            ),

                            // Botón para analizar la imagen
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: CustomButton(
                                label: 'Analyze',
                                onPressed: sendData,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                  SizedBox(height: 20),

                  // Mostrar el resultado del análisis si existe
                  if (resultText.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ElevatedContentCard(
                        text: 'Analysis Result:\n$resultText',
                        image: processedImage != null
                            ? Image.memory(
                                processedImage!,
                                width: 300,
                                height: 300,
                              )
                            : null,
                      ),
                    ),
                ],
              ),
            ),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    )
    );
  }
}