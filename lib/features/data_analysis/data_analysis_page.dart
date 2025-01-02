import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class DataAnalysisPage extends StatefulWidget {
  @override
  DataAnalysisPageState createState() => DataAnalysisPageState();
}

class DataAnalysisPageState extends State<DataAnalysisPage> {
  String resultText = '';
  File? _imageFile;
  Uint8List? _webImage;
  Uint8List? processedImage;

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
        Uri.parse('https://df2b-34-16-149-200.ngrok-free.app/process-image'),
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

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

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
              if (_webImage != null)
                Image.memory(_webImage!, width: 300, height: 300)
              else if (_imageFile != null)
                Image.file(_imageFile!, width: 300, height: 300),
              ElevatedButton(
                onPressed: pickImage,
                child: Text('Select Image'),
              ),
              ElevatedButton(
                onPressed: sendData,
                child: Text('Analyze'),
              ),
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