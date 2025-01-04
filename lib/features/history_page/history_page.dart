import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whezzedetect/shared/models/widgets/background_gradient.dart';
import 'image_history_provider.dart';
import 'dart:convert';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtener el historial desde el Provider
    final imageHistory = Provider.of<ImageHistoryProvider>(context).imageHistory;
     final colorScheme = Theme.of(context).colorScheme;
    return GradientBackground(
      child:Scaffold(
        // backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Analysis History'),
        backgroundColor: colorScheme.primaryContainer,
      ),
      body: imageHistory.isEmpty
          ? Center(
              child: Text('No analysis history available.'),
            )
          : ListView.builder(
              itemCount: imageHistory.length,
              itemBuilder: (context, index) {
                var item = imageHistory[index];
                return ListTile(
                  title: Text('Result: ${item['result']}'),
                  subtitle: Text('Date: ${item['date']}'),
                  leading: Image.memory(base64Decode(item['processedImage']),
                    width: 50,
                    height: 50,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: Icon(Icons.image),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                content: Image.memory(
                                   base64Decode(item['processedImage']),
                                ),
                              ),
                            );
                          },
                        ),
                      IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: () {
                          // Eliminar el historial si lo deseas
                          Provider.of<ImageHistoryProvider>(context, listen: false)
                              .removeFromHistory(index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    )
    );
  }
}
