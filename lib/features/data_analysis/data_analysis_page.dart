import 'package:flutter/material.dart';
import 'data_service.dart';

class DataAnalysisPage extends StatefulWidget {
  @override
  _DataAnalysisPageState createState() => _DataAnalysisPageState();
}

class _DataAnalysisPageState extends State<DataAnalysisPage> {
  String buttonText = "Enviar Datos";

  Future<void> sendData() async {
    String response = await DataService.sendData({
      'name': 'Flutter',
      'message': 'Hola desde Flutter',
    });

    setState(() {
      buttonText = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: sendData,
        child: Text(buttonText),
      ),
    );
  }
}
