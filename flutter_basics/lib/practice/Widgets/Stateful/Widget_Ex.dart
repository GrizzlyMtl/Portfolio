import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../stateful_widgets/custom_dark_theme_switch.dart';
import '../../../stateful_widgets/custom_buttons.dart';
import '../../../stateful_widgets/custom_textfield.dart';
import '../../../stateful_widgets/custom_slider.dart';

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
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _loading = false;
    });
  }

  Future<void> _saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    _saveTheme(value);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Basics',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter Basics')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomWidgetsShowcase(
              isDarkMode: _isDarkMode,
              onThemeChanged: _toggleTheme,
            ),
          ),
        ),
      ),
    );
  }
}

// Demo widget to show CustomSwitch usage

/// A showcase for all custom widgets in the project
class CustomWidgetsShowcase extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  const CustomWidgetsShowcase({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<CustomWidgetsShowcase> createState() => _CustomWidgetsShowcaseState();
}

class _CustomWidgetsShowcaseState extends State<CustomWidgetsShowcase> {
  void _showVolumeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        content: SizedBox(
          width: 220,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _volume == 0
                        ? Icons.volume_off
                        : (_volume <= 15
                              ? Icons.volume_mute
                              : (_volume <= 50
                                    ? Icons.volume_down
                                    : Icons.volume_up)),
                    color: _volume == 0
                        ? Colors.green
                        : (_volume <= 15
                              ? Colors.green
                              : (_volume <= 50
                                    ? Colors.yellow[700]
                                    : (_volume <= 60
                                          ? Colors.orange
                                          : Colors.red))),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Volume: ${_volume.round()}%',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _volume <= 25
                          ? Colors.green
                          : (_volume <= 74 ? Colors.yellow[700] : Colors.red),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomSlider(
                value: _volume,
                min: 0,
                max: 100,
                divisions: 100,
                label: '${_volume.round()}%',
                onChanged: (val) => setState(() => _volume = val),
                activeColor: Colors.blueAccent,
                inactiveColor: Colors.grey,
                thumbColor: Colors.white,
                trackHeight: 6,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // For custom slider/radio knob demo
  double _volume = 50;
  final GlobalKey _rowKey = GlobalKey();
  Offset? _fabOffset;
  bool _fabFloating = false;
  Offset? _fabHomeOffset; // Where the FAB should snap back
  String _greeting = '';
  double _elevation = 2;
  String _title = 'Custom Widgets Showcase';
  bool _showOutline = false;

  void _showSnack(String label) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Pressed: $label')));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate the home offset for the FAB (row position + offset in row)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_fabFloating && _rowKey.currentContext != null) {
            RenderBox box =
                _rowKey.currentContext!.findRenderObject() as RenderBox;
            Offset rowPos = box.localToGlobal(Offset.zero);
            setState(() {
              _fabHomeOffset = rowPos + Offset(12 + 56.0 * 5, 0);
            });
          }
        });
        return Stack(
          children: [
            // Small volume button in top right
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: _showVolumeDialog,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    _volume == 0
                        ? Icons.volume_off
                        : (_volume <= 15
                              ? Icons.volume_mute
                              : (_volume <= 50
                                    ? Icons.volume_down
                                    : Icons.volume_up)),
                    color: _volume == 0
                        ? Colors.green
                        : (_volume <= 15
                              ? Colors.green
                              : (_volume <= 50
                                    ? Colors.yellow[700]
                                    : (_volume <= 60
                                          ? Colors.orange
                                          : Colors.red))),
                    size: 22,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _volume == 0
                              ? Icons.volume_off
                              : (_volume <= 15
                                    ? Icons.volume_mute
                                    : (_volume <= 50
                                          ? Icons.volume_down
                                          : Icons.volume_up)),
                          color: _volume == 0
                              ? Colors.green
                              : (_volume <= 15
                                    ? Colors.green
                                    : (_volume <= 50
                                          ? Colors.yellow[700]
                                          : (_volume <= 60
                                                ? Colors.orange
                                                : Colors.red))),
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Volume: ${_volume.round()}%',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: _volume <= 25
                                    ? Colors.green
                                    : (_volume <= 74
                                          ? Colors.yellow[700]
                                          : Colors.red),
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: CustomSlider(
                        value: _volume,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: '${_volume.round()}%',
                        onChanged: (val) => setState(() => _volume = val),
                        activeColor: Colors.blueAccent,
                        inactiveColor: Colors.grey,
                        thumbColor: Colors.white,
                        icon: Icon(Icons.volume_up, color: Colors.blueAccent),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      _title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    // Professional Custom Dark Theme Switch
                    CustomDarkThemeSwitch(
                      value: widget.isDarkMode,
                      onChanged: widget.onThemeChanged,
                      label: 'Dark Mode',
                      description: 'Enable dark theme for the app',
                      activeColor: const Color(0xFF4F8CFF),
                      inactiveColor: const Color(0xFF23272F),
                      thumbColor: Colors.white,
                      activeIcon: Icons.dark_mode,
                      inactiveIcon: Icons.light_mode,
                      glassy: true,
                    ),
                    const SizedBox(height: 32),
                    // Row of all custom buttons
                    Text(
                      'Custom Buttons',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        key: _rowKey,
                        children: [
                          AnimatedPhysicalModel(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                            elevation: _elevation,
                            color: Colors.transparent,
                            shadowColor: Colors.black,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              decoration: _showOutline
                                  ? BoxDecoration(
                                      border: Border.all(
                                        color: Colors.red,
                                        width: 4,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    )
                                  : null,
                              child: CustomElevatedButton(
                                elevation: 0,
                                label: 'Elevated',
                                icon: Icons.star,
                                onPressed: () {
                                  setState(() => _elevation = 20);
                                  Future.delayed(Duration(seconds: 5), () {
                                    setState(() => _elevation = 2);
                                  });
                                  _showSnack('ElevatedButton');
                                },
                                color: Colors.blueAccent,
                                textColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            decoration: _showOutline
                                ? BoxDecoration(
                                    border: Border.all(
                                      color: Colors.red,
                                      width: 4,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  )
                                : null,
                            child: CustomTextButton(
                              label: 'Text',
                              icon: Icons.text_fields,
                              onPressed: () async {
                                String? newTitle = await showDialog<String>(
                                  context: context,
                                  builder: (context) {
                                    String temp = '';
                                    return AlertDialog(
                                      title: Text('Enter new title'),
                                      content: TextField(
                                        onChanged: (val) => temp = val,
                                        decoration: InputDecoration(
                                          hintText: 'Enter new title',
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, temp),
                                          child: Text('Ok'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                if (newTitle != null && newTitle.isNotEmpty) {
                                  setState(() => _title = newTitle);
                                  _showSnack('TextButton');
                                }
                              },
                              color: Colors.white10,
                              textColor: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(width: 12),
                          CustomOutlinedButton(
                            label: 'Outlined',
                            icon: Icons.outlined_flag,
                            onPressed: () {
                              setState(() => _showOutline = true);
                              Future.delayed(Duration(seconds: 5), () {
                                setState(() => _showOutline = false);
                              });
                              _showSnack('OutlinedButton');
                            },
                            borderColor: Colors.blueAccent,
                            textColor: Colors.blueAccent,
                            outline: _showOutline,
                          ),
                          const SizedBox(width: 12),
                          Container(
                            decoration: _showOutline
                                ? BoxDecoration(
                                    border: Border.all(
                                      color: Colors.red,
                                      width: 4,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  )
                                : null,
                            child: CustomIconButton(
                              icon: Icons.thumb_up,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => Center(
                                    child: Icon(
                                      Icons.thumb_up,
                                      size: 150,
                                      color: Colors.purpleAccent.withAlpha(100),
                                    ),
                                  ),
                                );
                                _showSnack('IconButton');
                              },
                              color: Colors.purpleAccent,
                              backgroundColor: Colors.white10,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Custom FloatingActionButton styled to fit in a row
                          _fabFloating && _fabOffset != null
                              ? SizedBox(width: 56, height: 56)
                              : Container(
                                  decoration: _showOutline
                                      ? BoxDecoration(
                                          border: Border.all(
                                            color: Colors.red,
                                            width: 4,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            28,
                                          ),
                                        )
                                      : null,
                                  child: SizedBox(
                                    width: 56,
                                    height: 56,
                                    child: Draggable<int>(
                                      data: 1,
                                      feedback: Material(
                                        color: Colors.transparent,
                                        child: CustomFloatingActionButton(
                                          icon: Icons.add,
                                          onPressed: () => _showSnack(
                                            'FloatingActionButton',
                                          ),
                                          backgroundColor: Colors.orange,
                                          iconColor: Colors.white,
                                          tooltip: 'Add',
                                        ),
                                      ),
                                      childWhenDragging: SizedBox.shrink(),
                                      onDragStarted: () {
                                        RenderBox box =
                                            _rowKey.currentContext!
                                                    .findRenderObject()
                                                as RenderBox;
                                        Offset rowPos = box.localToGlobal(
                                          Offset.zero,
                                        );
                                        setState(() {
                                          _fabFloating = true;
                                          _fabOffset =
                                              _fabHomeOffset ??
                                              (rowPos +
                                                  Offset(12 + 56.0 * 5, 0));
                                        });
                                      },
                                      onDraggableCanceled: (velocity, offset) {
                                        setState(() {
                                          _fabFloating = false;
                                          _fabOffset = null;
                                        });
                                      },
                                      onDragEnd: (details) {
                                        // If close to home, snap back
                                        if (_fabHomeOffset != null &&
                                            (details.offset - _fabHomeOffset!)
                                                    .distance <
                                                80) {
                                          setState(() {
                                            _fabFloating = false;
                                            _fabOffset = null;
                                          });
                                        } else {
                                          setState(() {
                                            _fabFloating = true;
                                            _fabOffset = details.offset;
                                          });
                                        }
                                      },
                                      child: CustomFloatingActionButton(
                                        icon: Icons.add,
                                        onPressed: () =>
                                            _showSnack('FloatingActionButton'),
                                        backgroundColor: Colors.orange,
                                        iconColor: Colors.white,
                                        tooltip: 'Add',
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Custom TextField
                    Text(
                      'Custom Text Field',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Your Name',
                      hint: 'Enter your name',
                      icon: Icons.person,
                      onSubmitted: (name) {
                        setState(() {
                          _greeting = 'Hello $name';
                        });
                        Future.delayed(const Duration(seconds: 3), () {
                          if (mounted) {
                            setState(() {
                              _greeting = '';
                            });
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    // Info
                    if (_greeting.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _greeting,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.amber),
                        ),
                      ),
                    if (widget.isDarkMode)
                      Text(
                        'Dark mode is enabled!',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    // Floating FAB overlay
                    if (_fabFloating && _fabOffset != null)
                      Positioned(
                        left: _fabOffset!.dx,
                        top: _fabOffset!.dy,
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            setState(() {
                              _fabOffset = _fabOffset! + details.delta;
                            });
                          },
                          child: CustomFloatingActionButton(
                            icon: Icons.add,
                            onPressed: () => _showSnack('FloatingActionButton'),
                            backgroundColor: Colors.orange,
                            iconColor: Colors.white,
                            tooltip: 'Add',
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
