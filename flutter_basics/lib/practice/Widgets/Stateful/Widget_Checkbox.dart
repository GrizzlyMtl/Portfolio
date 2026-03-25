import 'package:flutter/material.dart';
import '../../../stateful_widgets/custom_dark_theme_switch.dart';

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

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(title: Text("Checkbox Exercise")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomDarkThemeSwitch(
              value: _isDarkMode,
              onChanged: _toggleTheme,
              label: 'Dark Mode',
              description: 'Enable dark theme for the app',
              activeColor: const Color(0xFF4F8CFF),
              inactiveColor: const Color(0xFF23272F),
              thumbColor: Colors.white,
              activeIcon: Icons.dark_mode_outlined,
              inactiveIcon: Icons.light_mode_outlined,
              glassy: true,
            ),
            Expanded(child: ToDoList()),
          ],
        ),
      ),
    );
  }
}

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  ToDoListState createState() => ToDoListState();
}

class ToDoListState extends State<ToDoList> {
  List<Map<String, dynamic>> tasks = [
    {'task': 'Walk the dog', 'To do': false},
    {'task': 'Homework', 'To do': false},
    {'task': 'Make dinner', 'To do': false},
    {'task': 'Clean the house', 'To do': false},
    {'task': 'Grocery shopping', 'To do': false},
  ];

  @override
  Widget build(BuildContext context) {
    int checkedCount = tasks.where((task) => task['To do'] == true).length;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Tasks Completed: $checkedCount',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: tasks.map((task) {
                  return CheckboxListTile(
                    title: Text(
                      task['task'],
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        decoration: task['To do']
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    value: task['To do'],
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool? value) {
                      setState(() {
                        task['To do'] = value!;
                      });
                    },
                  );
                }).toList(),
                // ...existing code...
                // Custom painter for diagonal strikethrough
              ),
            ),
          ),
        ),
      ],
    );
  }
}
