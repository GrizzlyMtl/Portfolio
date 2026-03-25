import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  bool _showMessage = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dart_Widgets_Card'),
          actions: [
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                // Example: show dialog
              },
            ),
            Switch(
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
              },
              activeThumbColor: Colors.white,
            ),
          ],
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Center(child: ImageGrid(isDarkMode: _isDarkMode)),

            // Overlay message
            if (_showMessage)
              Card(
                color: Colors.black.withValues(alpha: 0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Hello World",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _showMessage = true;
            });
            Future.delayed(const Duration(seconds: 3), () {
              setState(() {
                _showMessage = false;
              });
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class ImageGrid extends StatelessWidget {
  final bool isDarkMode;

  const ImageGrid({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildImageCard(
              context,
              'Random Image1',
              'https://picsum.photos/200/200?random=1',
              BoxFit.cover,
            ),
            const SizedBox(width: 20),
            _buildImageCard(
              context,
              'Google Logo',
              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Google_2015_logo.svg/500px-Google_2015_logo.svg.png',
              BoxFit.contain,
            ),
            const SizedBox(width: 20),
            _buildImageCard(
              context,
              'Random Image2',
              'https://picsum.photos/200/200?random=2',
              BoxFit.cover,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageCard(
    BuildContext context,
    String title,
    String imageUrl,
    BoxFit fit,
  ) {
    return HoverCard(
      child: Card(
        color: isDarkMode ? Colors.blue : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SizedBox(
          width: 300,
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite, color: Colors.white, size: 30),
              Image.network(imageUrl, width: 200, height: 200, fit: fit),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom widget to add hover popup effect
class HoverCard extends StatefulWidget {
  final Widget child;
  const HoverCard({super.key, required this.child});

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: AnimatedPhysicalModel(
          duration: const Duration(milliseconds: 200),
          shape: BoxShape.rectangle,
          elevation: _hovering ? 12 : 4,
          color: Colors.transparent,
          shadowColor: Colors.black,
          child: widget.child,
        ),
      ),
    );
  }
}
