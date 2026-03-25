import 'package:flutter/material.dart';

/// Standalone demo entry point for this example file.
void main() {
  runApp(const PageChangerApp());
}

class PageChangerApp extends StatelessWidget {
  const PageChangerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Page Changer Example')),
        body: const PageChangerWidget(),
      ),
    );
  }
}

class PageChangerWidget extends StatefulWidget {
  const PageChangerWidget({super.key});

  @override
  State<PageChangerWidget> createState() => _PageChangerWidgetState();
}

class _PageChangerWidgetState extends State<PageChangerWidget> {
  int _currentPage = 0;

  void _nextPage() {
    setState(() {
      _currentPage = (_currentPage + 1) % 3;
    });
  }

  void _previousPage() {
    setState(() {
      _currentPage = (_currentPage - 1 + 3) % 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _buildPage(
        icon: Icons.home,
        title: 'This is Page 1',
        color: Colors.blue.shade100,
      ),
      _buildPage(
        icon: Icons.star,
        title: 'Welcome to Page 2',
        color: Colors.green.shade100,
      ),
      _buildPage(
        icon: Icons.settings,
        title: 'You are on Page 3',
        color: Colors.orange.shade100,
      ),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: pages[_currentPage]),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _previousPage,
              child: const Icon(Icons.arrow_back),
            ),
            const SizedBox(width: 16),
            Text('Page ${_currentPage + 1} of ${pages.length}'),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: _nextPage,
              child: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPage({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      color: color,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 100),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
