import 'package:flutter/material.dart';

// Entry point for this example
void main() => runApp(const FruitApp());

class FruitApp extends StatelessWidget {
  const FruitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fruit Selector',
      theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),
      home: const FruitListPage(),
    );
  }
}

/// Simple data model representing a fruit.
class Fruit {
  final String name;
  final IconData icon;

  const Fruit(this.name, this.icon);
}

class FruitListPage extends StatelessWidget {
  const FruitListPage({super.key});

  // 1. Data source
  static const List<Fruit> fruits = <Fruit>[
    Fruit('Apple', Icons.apple),
    Fruit('Banana', Icons.restaurant),
    Fruit('Orange', Icons.circle),
    Fruit('Strawberry', Icons.local_florist),
    Fruit('Kiwi', Icons.eco),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Fruits')),
      // 2. Dynamically build the list
      body: ListView.builder(
        itemCount: fruits.length,
        itemBuilder: (BuildContext context, int index) {
          final Fruit fruit = fruits[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 2,
            child: ListTile(
              leading: Icon(fruit.icon, color: Colors.green.shade700),
              title: Text(fruit.name),
              subtitle: const Text('Tap to see details'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              // 3. Handle tap: navigate to the detail page
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<Widget>(
                    builder: (BuildContext context) =>
                        FruitDetailPage(fruit: fruit),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class FruitDetailPage extends StatelessWidget {
  // Value passed from the list page
  final Fruit fruit;

  const FruitDetailPage({super.key, required this.fruit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fruit details')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(fruit.icon, size: 96, color: Colors.green.shade700),
              const SizedBox(height: 24),
              // 4. Display the selected value
              Text(
                fruit.name,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'You selected ${fruit.name.toLowerCase()}.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Choose another fruit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
