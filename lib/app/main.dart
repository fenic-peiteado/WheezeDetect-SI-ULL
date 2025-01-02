import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/models/app_state.dart';
import 'theme.dart';
import 'navigation.dart';
import '../features/history_page/image_history_provider.dart';  // Importa el ImageHistoryProvider

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyAppState()),  // Ya lo tienes
        ChangeNotifierProvider(create: (context) => ImageHistoryProvider()),  // Añadido el provider para el historial
      ],
      child: MaterialApp(
        title: 'Wheeze Detect',
        theme: AppTheme.lightTheme,
        home: NavigationPage(),
      ),
    );
  }
}

