import 'package:flutter/material.dart';
import '../features/home/home_page.dart';
import '../features/data_analysis/data_analysis_page.dart';
import '../features/history_page/history_page.dart';  // Importamos la nueva página de historial
import '../shared/models/widgets/background_gradient.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int selectedIndex = 0;

  // Lista de páginas ahora incluye la nueva página de historial
  final List<Widget> pages = [
    HomePage(), // Página sin fondo degradado
    GradientBackground(child: DataAnalysisPage()), // Página con degradado
    GradientBackground(child: HistoryPage()), // Página con degradado
  ];



 @override
Widget build(BuildContext context) {
  return GradientBackground( child: Scaffold(
    backgroundColor: Colors.transparent,
    body: GradientBackground(
      child: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
    ),
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: 'Data Analysis',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'History',
        ),
      ],
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).colorScheme.secondary,
      unselectedItemColor: Theme.of(context).unselectedWidgetColor,
      showUnselectedLabels: true,
      selectedFontSize: 16,
      unselectedFontSize: 12,
      backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
    ),
  )
  );
}

}
