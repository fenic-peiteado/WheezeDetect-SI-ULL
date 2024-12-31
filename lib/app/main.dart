import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/models/app_state.dart';
import 'theme.dart';
import 'navigation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Wheeze Detect',
        theme: AppTheme.lightTheme,
        home: NavigationPage(),
      ),
    );
  }
}
