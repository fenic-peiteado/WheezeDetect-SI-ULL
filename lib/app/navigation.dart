import 'package:flutter/material.dart';
import '../features/home/home_page.dart';
import '../features/data_analysis/data_analysis_page.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int selectedIndex = 0;

  // List of pages to display based on the selected index
  final List<Widget> pages = [
    HomePage(),
    DataAnalysisPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body with IndexedStack to switch between the pages
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),

      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index; // Update selected page on tap
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
        ],
        // Customize the appearance of the navigation bar for a better UI
        type: BottomNavigationBarType.fixed, // Fixed to avoid shifting items
        selectedItemColor: Theme.of(context).colorScheme.secondary, // Color when selected
        unselectedItemColor: Theme.of(context).unselectedWidgetColor, // Color when unselected
        showUnselectedLabels: true, // Show labels even when unselected
        selectedFontSize: 16, // Font size for selected item
        unselectedFontSize: 12, // Font size for unselected item
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor, // Background color
      ),
    );
  }
}
