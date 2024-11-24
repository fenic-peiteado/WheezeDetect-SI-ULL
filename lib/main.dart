import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      body: Row(
        children: [
          SafeArea( // SafeArea es un widget que se usa para evitar que el contenido se superponga con la barra de estado
            child: NavigationRail( // NavigationRail es un widget que se usa para crear una barra de navegación lateral
              extended: false, // extended es un booleano que se usa para extender la barra de navegación lateral
              backgroundColor: Theme.of(context).colorScheme.inversePrimary, // backgroundColor es un color que se usa para establecer el color de fondo de la barra de navegación lateral
              destinations: [
                NavigationRailDestination( // NavigationRailDestination es un widget que se usa para crear un destino de navegación 
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination( // iconos sobre machine learning
                  // iconos sobre data analysis
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
          ),
          Expanded( // Expanded es un widget que se usa para expandir un widget hijo para que ocupe todo el espacio disponible
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;
    final theme = Theme.of(context);

// ...
    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.auto_awesome;
    } else {
      icon = Icons.dangerous_outlined;
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // se usa para centrar el contenido
          children: [
            // Text('A random AWESOME idea:'),
            // se hizo un refactor de BigCard a un widget separado
            BigCard(pair: pair),
            // SizedBox es un widget que se usa para agregar espacio entre los widgets
            SizedBox(height: 16),
            // ElevatedButton es un widget que se usa para crear botones
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  // onPressed es un callback que se llama cuando el usuario presiona el botón
                  onPressed: () {
                    appState.getNext();
                  },
                  // child es un widget que se usa para mostrar el contenido del botón
                  child: Text('Subir Imagen'),
                ),
                SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: Text('Analizar Imagen'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
// ...
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;
  // Se establece una imagen por defecto
  final String imagePath = 'assets/images/image_with_pneumonia.jpeg';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    // Añadir foto desde local
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          imagePath,
          width: 300,
          height: 300,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(
                Icons.broken_image,
                size: 48,
              ),
            );
          },)
      ),
    );
  }
}
