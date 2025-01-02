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
  String buttonText = "Send Data";
  String? _imageUrl;
  File? _imageFile;
  Uint8List? _webImage;

  
  Future<void> sendData() async {
    if (_imageUrl == null && _imageFile == null && _webImage == null) {
      setState(() {
        buttonText = 'No image selected';
      });
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
        final processedImage = base64Decode(responseBody['processed_image']);

        setState(() {
          buttonText = responseBody['result'];
          _imageUrl = 'data:image/png;base64,' + base64Encode(processedImage);
        });
      } else {
        setState(() {
          buttonText = 'Error with status code: ${response.statusCode}';
        });
        print('Error: ${response.statusCode} - ${responseData.body}');
      }
    } catch (e) {
      setState(() {
        buttonText = 'Error sending data' + e.toString();
      });
      print('Exception: $e');
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final webImage = await pickedFile.readAsBytes();
        setState(() {
          _webImage = webImage;
          _imageUrl = pickedFile.path;
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_imageUrl != null && kIsWeb)
            SizedBox(
              width: 300,
              height: 300,
              child: Image.network(_imageUrl!),
            )
          else if (_imageFile != null)
            SizedBox(
              width: 300,
              height: 300,
              child: Image.file(_imageFile!),
            ),
          ElevatedButton(
            onPressed: pickImage,
            child: Text('Select Image'),
          ),
          ElevatedButton(
            onPressed: sendData,
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}