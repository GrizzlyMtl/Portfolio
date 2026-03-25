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
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // First row of 3 images
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

                  const SizedBox(height: 20),
                  const Divider(
                    thickness: 2,
                    color: Colors.grey,
                    indent: 50,
                    endIndent: 50,
                  ),
                  const SizedBox(height: 20),

                  // Second row of 3 images
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildImageCard(
                        context,
                        'Random Image3',
                        'https://picsum.photos/200/200?random=3',
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
                        'Random Image4',
                        'https://picsum.photos/200/200?random=4',
                        BoxFit.cover,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Overlay message
            if (_showMessage)
              Card(
                color: Colors.black.withAlpha(128),
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

  Widget _buildImageCard(
    BuildContext context,
    String title,
    String imageUrl,
    BoxFit fit,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return HoverCard(
      child: Card(
        color: isDarkMode ? Colors.blue : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite, color: Colors.white, size: 24),
              Image.network(imageUrl, width: 150, height: 150, fit: fit),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
