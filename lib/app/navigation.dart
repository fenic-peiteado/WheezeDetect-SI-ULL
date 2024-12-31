import 'package:flutter/material.dart';
import '../features/home/home_page.dart';
import '../features/data_analysis/data_analysis_page.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: false,
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.analytics),
                label: Text('Data Analysis'),
              ),
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
          ),
          Expanded(
            child: IndexedStack( // IndexedStack es un widget que se usa para mostrar solo un widget hijo a la vez
              index: selectedIndex,
              children: [
                HomePage(),
                DataAnalysisPage(),
              ],
            ),
          ),
        ],
      ),
    )
    );
  }
}