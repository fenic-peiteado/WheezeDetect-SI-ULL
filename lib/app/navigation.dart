import 'package:flutter/material.dart';
import '../features/home/home_page.dart';
import '../features/data_analysis/data_analysis_page.dart';
import '../features/history_page/history_page.dart';  // Importamos la nueva página de historial

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int selectedIndex = 0;

  // Lista de páginas ahora incluye la nueva página de historial
  final List<Widget> pages = [
    HomePage(),
    DataAnalysisPage(),
    HistoryPage(),  // Página de historial
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Cuerpo con IndexedStack para cambiar entre las páginas
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),

      // Barra de navegación inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;  // Actualizamos la página seleccionada
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
            icon: Icon(Icons.history),  // Ícono para historial
            label: 'History',
          ),
        ],
        type: BottomNavigationBarType.fixed,  // Para evitar el cambio de posición de los íconos
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        showUnselectedLabels: true,
        selectedFontSize: 16,
        unselectedFontSize: 12,
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      ),
    );
  }
}
