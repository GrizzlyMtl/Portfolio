import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle, NetworkAssetBundle;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:file_selector/file_selector.dart';

final ThemeData lightTheme = ThemeData(
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF2E7D32), // deep jungle green
    onPrimary: Colors.white,
    secondary: Color(0xFFF9A825), // savannah golden
    onSecondary: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    surface: Color(0xFFFFF8E1), // warm sand
    onSurface: Color(0xFF3E2723),
    surfaceTint: Color(0xFF2E7D32),
    shadow: Colors.black26,
    outline: Color(0xFF8D6E63),
    surfaceContainerHighest: Color(0xFFFFF3E0),
    primaryContainer: Color(0xFF66BB6A),
    onPrimaryContainer: Colors.white,
    secondaryContainer: Color(0xFFFFE082),
    onSecondaryContainer: Color(0xFF3E2723),
    tertiary: Color(0xFF8BC34A),
    onTertiary: Colors.black,
    tertiaryContainer: Color(0xFFC5E1A5),
    onTertiaryContainer: Color(0xFF1B5E20),
    surfaceContainerLowest: Color(0xFFFFFDE7),
    surfaceContainerLow: Color(0xFFFFF9C4),
    surfaceContainer: Color(0xFFFFF8E1),
    surfaceBright: Color(0xFFFFFDE7),
    surfaceDim: Color(0xFFFBE9E7),
    inverseSurface: Color(0xFF3E2723),
    onInverseSurface: Colors.white,
    inversePrimary: Color(0xFFA5D6A7),
    scrim: Colors.black54,
  ),
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFFFFF8E1),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF2E7D32),
    foregroundColor: Colors.white,
    elevation: 2,
    centerTitle: true,
  ),
  cardTheme: const CardThemeData(
    elevation: 3,
    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    filled: true,
    fillColor: Color(0xFFFFFDE7),
  ),
);

final ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF004D40), // deep jungle teal
    onPrimary: Colors.white,
    secondary: Color(0xFFFFB300), // warm savannah amber
    onSecondary: Colors.black,
    error: Colors.redAccent,
    onError: Colors.black,
    surface: Color(0xFF1B1B1B),
    onSurface: Color(0xFFE0F2F1),
    surfaceTint: Color(0xFF004D40),
    shadow: Colors.black87,
    outline: Color(0xFF4E342E),
    surfaceContainerHighest: Color(0xFF263238),
    primaryContainer: Color(0xFF00695C),
    onPrimaryContainer: Colors.white,
    secondaryContainer: Color(0xFFFF8F00),
    onSecondaryContainer: Colors.black,
    tertiary: Color(0xFF33691E),
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFF558B2F),
    onTertiaryContainer: Colors.white,
    surfaceContainerLowest: Color(0xFF121212),
    surfaceContainerLow: Color(0xFF1E2725),
    surfaceContainer: Color(0xFF1B1B1B),
    surfaceBright: Color(0xFF263238),
    surfaceDim: Color(0xFF121212),
    inverseSurface: Color(0xFFE0F2F1),
    onInverseSurface: Color(0xFF004D40),
    inversePrimary: Color(0xFF80CBC4),
    scrim: Colors.black87,
  ),
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF004D40),
    foregroundColor: Colors.white,
    elevation: 2,
    centerTitle: true,
  ),
  cardTheme: const CardThemeData(
    elevation: 3,
    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
    filled: true,
    fillColor: Color(0xFF1E2725),
  ),
);

// Global prediction statistics
const String predictionStatsPrefKey = 'predictionStats';

class PredictionStats {
  final int totalPredictions;
  final Map<String, int> perLabelCount;
  final String? lastLabel;
  final double? lastBestScore;
  final List<String> labels;
  final int correctCount;
  final int incorrectCount;

  const PredictionStats({
    required this.totalPredictions,
    required this.perLabelCount,
    required this.lastLabel,
    required this.lastBestScore,
    required this.labels,
    required this.correctCount,
    required this.incorrectCount,
  });

  factory PredictionStats.empty() => const PredictionStats(
    totalPredictions: 0,
    perLabelCount: {},
    lastLabel: null,
    lastBestScore: null,
    labels: [],
    correctCount: 0,
    incorrectCount: 0,
  );

  Map<String, dynamic> toJson() {
    return {
      'totalPredictions': totalPredictions,
      'perLabelCount': perLabelCount,
      'lastLabel': lastLabel,
      'lastBestScore': lastBestScore,
      'labels': labels,
      'correctCount': correctCount,
      'incorrectCount': incorrectCount,
    };
  }

  factory PredictionStats.fromJson(Map<String, dynamic> json) {
    final perLabel = <String, int>{};
    final rawPerLabel = json['perLabelCount'] as Map<String, dynamic>?;
    if (rawPerLabel != null) {
      for (final entry in rawPerLabel.entries) {
        perLabel[entry.key] = (entry.value as num).toInt();
      }
    }

    final labelsList =
        (json['labels'] as List?)?.map((e) => e.toString()).toList() ??
        <String>[];

    return PredictionStats(
      totalPredictions: (json['totalPredictions'] as num?)?.toInt() ?? 0,
      perLabelCount: perLabel,
      lastLabel: json['lastLabel'] as String?,
      lastBestScore: (json['lastBestScore'] as num?)?.toDouble(),
      labels: labelsList,
      correctCount: (json['correctCount'] as num?)?.toInt() ?? 0,
      incorrectCount: (json['incorrectCount'] as num?)?.toInt() ?? 0,
    );
  }

  String? get mostPredictedLabel {
    if (perLabelCount.isEmpty) return null;
    String? bestLabel;
    int bestCount = -1;
    perLabelCount.forEach((label, count) {
      if (count > bestCount) {
        bestCount = count;
        bestLabel = label;
      }
    });
    return bestLabel;
  }
}

PredictionStats predictionStats = PredictionStats.empty();

Future<void> savePredictionStats() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(
    predictionStatsPrefKey,
    jsonEncode(predictionStats.toJson()),
  );
}

Future<void> _recordPredictionStats(
  String bestLabel,
  double bestScore,
  List<double> scores,
  List<String> labels,
) async {
  final Map<String, int> updatedCounts = Map<String, int>.from(
    predictionStats.perLabelCount,
  );
  updatedCounts[bestLabel] = (updatedCounts[bestLabel] ?? 0) + 1;

  predictionStats = PredictionStats(
    totalPredictions: predictionStats.totalPredictions + 1,
    perLabelCount: updatedCounts,
    lastLabel: bestLabel,
    lastBestScore: bestScore,
    labels: labels,
    correctCount: predictionStats.correctCount,
    incorrectCount: predictionStats.incorrectCount,
  );

  await savePredictionStats();
}

Future<void> _recordPredictionFeedback(bool isCorrect) async {
  predictionStats = PredictionStats(
    totalPredictions: predictionStats.totalPredictions,
    perLabelCount: predictionStats.perLabelCount,
    lastLabel: predictionStats.lastLabel,
    lastBestScore: predictionStats.lastBestScore,
    labels: predictionStats.labels,
    correctCount: predictionStats.correctCount + (isCorrect ? 1 : 0),
    incorrectCount: predictionStats.incorrectCount + (isCorrect ? 0 : 1),
  );

  await savePredictionStats();
}

Future<void> resetPredictionStats() async {
  predictionStats = PredictionStats.empty();
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(predictionStatsPrefKey);
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const _themePrefKey = 'isDarkMode';
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themePrefKey) ?? false;
    // Load persisted prediction statistics if available
    final String? statsJson = prefs.getString(predictionStatsPrefKey);
    if (statsJson != null) {
      try {
        predictionStats = PredictionStats.fromJson(
          jsonDecode(statsJson) as Map<String, dynamic>,
        );
      } catch (_) {
        predictionStats = PredictionStats.empty();
      }
    }

    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> _updateTheme(bool isDark) async {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themePrefKey, isDark);
  }

  bool get _isDarkMode => _themeMode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      themeAnimationDuration: const Duration(milliseconds: 350),
      themeAnimationCurve: Curves.easeInOut,
      home: WelcomePage(isDarkMode: _isDarkMode, onThemeChanged: _updateTheme),
    );
  }
}

class CustomDarkThemeSwitch extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onChanged;

  const CustomDarkThemeSwitch({
    super.key,
    required this.isDarkMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: Colors.white),
        Switch(
          value: isDark,
          onChanged: onChanged,
          activeThumbColor: Colors.amber,
        ),
      ],
    );
  }
}

class PageNavigationBar extends StatelessWidget {
  final void Function(String) onSelect;
  final String currentPage;

  const PageNavigationBar({
    super.key,
    required this.onSelect,
    required this.currentPage,
  });

  Widget _buildTab(BuildContext context, String label) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool isSelected = label == currentPage;

    return Expanded(
      child: TextButton(
        onPressed: () => onSelect(label),
        style: TextButton.styleFrom(
          foregroundColor: isSelected
              ? scheme.onPrimary
              : scheme.onSurfaceVariant,
          backgroundColor: isSelected ? scheme.primary : Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Material(
      elevation: 2,
      color: scheme.surfaceContainerHighest,
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            _buildTab(context, 'Load Data'),
            _buildTab(
              context,
              'Predict',
            ), //Navigator.pushReplacement to Remove current page from stack and change page
            _buildTab(context, 'Statistics'),
          ],
        ),
      ),
    );
  }
}

Widget _buildStat(IconData icon, String value, String label) {
  return Column(
    children: [
      const SizedBox(height: 10),
      Icon(icon, color: const Color.fromARGB(255, 197, 197, 197)),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(
          color: Color.fromARGB(255, 197, 197, 197),
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
      ),
      Tooltip(
        waitDuration: const Duration(seconds: 2),
        message: label,
        child: Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color.fromARGB(255, 197, 197, 197),
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    ],
  );
}

//Right Slide Transition when navigating to a new page
Route<T> _buildPageRoute<T>(Widget page, AxisDirection direction) {
  Offset begin;
  switch (direction) {
    case AxisDirection.up:
      begin = const Offset(0.0, 1.0);
      break;
    case AxisDirection.down:
      begin = const Offset(0.0, -1.0);
      break;
    case AxisDirection.left:
      begin = const Offset(-1.0, 0.0);
      break;
    case AxisDirection.right:
      begin = const Offset(1.0, 0.0);
      break;
  }

  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween<Offset>(
        begin: begin,
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeInOut));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

class WelcomePage extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const WelcomePage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('SavahnAnimal Predictor'),
        centerTitle: true,
        actions: [
          CustomDarkThemeSwitch(
            isDarkMode: isDarkMode,
            onChanged: onThemeChanged,
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/Welcome_Page.jpg', fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withAlpha(153),
                  Colors.transparent,
                  Colors.black.withAlpha(153),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                color: scheme.surface.withAlpha(230),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'SavahnAnimal Predictor',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: scheme.onSurface,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Bring the savannah to your screen.\nLoad an animal image and let the CNN guess the species.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            _buildPageRoute(
                              LoadDataPage(
                                isDarkMode: isDarkMode,
                                onThemeChanged: onThemeChanged,
                              ),
                              AxisDirection.right,
                            ),
                          );
                        },
                        icon: const Icon(Icons.pets),
                        label: const Text('Start Prediction'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          textStyle: const TextStyle(fontSize: 18),
                          elevation: 4,
                          shadowColor: Colors.black45,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          animationDuration: const Duration(milliseconds: 150),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoadDataPage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  const LoadDataPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<LoadDataPage> createState() => _LoadDataPageState();
}

class _LoadDataPageState extends State<LoadDataPage> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  final TextEditingController _urlController = TextEditingController();
  String? _imageUrl;
  bool _isLoadingFromWeb = false;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _changeScreen(String screenName) {
    if (screenName == 'Load Data') {
      // Already on LoadDataPage, do nothing or maybe pop to root
      return;
    } else if (screenName == 'Predict') {
      Navigator.pushReplacement(
        context,
        _buildPageRoute(
          CnnPredictionPage(
            isDarkMode: widget.isDarkMode,
            onThemeChanged: widget.onThemeChanged,
            initialImage: _imageBytes,
          ),
          AxisDirection.right,
        ),
      );
    } else if (screenName == 'Statistics') {
      Navigator.pushReplacement(
        context,
        _buildPageRoute(
          StatisticsPage(
            isDarkMode: widget.isDarkMode,
            onThemeChanged: widget.onThemeChanged,
          ),
          AxisDirection.left,
        ),
      );
    }
  }

  Future<void> _pickFromDevice() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    final bytes = await file.readAsBytes();
    if (!mounted) return;

    setState(() {
      _imageBytes = bytes;
      _imageUrl = null;
    });
  }

  Future<void> _pickMultipleAndGoToPredict() async {
    final ctx = context;
    final String? directoryPath = await getDirectoryPath();
    if (directoryPath == null) return;

    final dir = Directory(directoryPath);
    final List<Uint8List> images = [];
    await for (final entity in dir.list()) {
      if (entity is File) {
        final lower = entity.path.toLowerCase();
        if (lower.endsWith('.jpg') ||
            lower.endsWith('.jpeg') ||
            lower.endsWith('.png')) {
          final bytes = await entity.readAsBytes();
          images.add(bytes);
        }
      }
    }
    if (!ctx.mounted || images.isEmpty) return;

    Navigator.pushReplacement(
      ctx,
      _buildPageRoute(
        CnnPredictionPage(
          isDarkMode: widget.isDarkMode,
          onThemeChanged: widget.onThemeChanged,
          initialImages: images,
        ),
        AxisDirection.right,
      ),
    );
  }

  Future<void> _captureFromCameraAndGoToPredict() async {
    final ctx = context;
    // Camera capture is not supported on all desktop setups with image_picker.
    // On Windows/macOS/Linux this may fail, so show a helpful message instead.
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      if (!ctx.mounted) return;
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text(
            'Camera capture is not supported on this platform. Use gallery/files or URL instead.',
          ),
        ),
      );
      return;
    }

    final XFile? file = await _picker.pickImage(source: ImageSource.camera);
    if (file == null) return;

    final bytes = await file.readAsBytes();
    if (!ctx.mounted) return;

    Navigator.pushReplacement(
      ctx,
      _buildPageRoute(
        CnnPredictionPage(
          isDarkMode: widget.isDarkMode,
          onThemeChanged: widget.onThemeChanged,
          initialImage: bytes,
        ),
        AxisDirection.right,
      ),
    );
  }

  Future<void> _loadFromWeb() async {
    final ctx = context;
    final url = _urlController.text.trim();
    if (url.isEmpty) return;

    try {
      if (!ctx.mounted) return;
      setState(() {
        _isLoadingFromWeb = true;
      });
      final uri = Uri.parse(url);
      final bundle = NetworkAssetBundle(uri);
      final byteData = await bundle.load(uri.toString());
      final bytes = byteData.buffer.asUint8List();
      // Validate that the downloaded bytes are actually an image Flutter can decode
      final decoded = img.decodeImage(bytes);
      if (decoded == null) {
        if (!ctx.mounted) return;
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('The URL did not return a valid image (PNG/JPEG).'),
          ),
        );
        return;
      }
      if (!ctx.mounted) return;

      Navigator.pushReplacement(
        ctx,
        _buildPageRoute(
          CnnPredictionPage(
            isDarkMode: widget.isDarkMode,
            onThemeChanged: widget.onThemeChanged,
            initialImage: bytes,
          ),
          AxisDirection.right,
        ),
      );
    } catch (e) {
      if (!ctx.mounted) return;
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text('Failed to load image from URL: $e')),
      );
    } finally {
      if (ctx.mounted) {
        setState(() {
          _isLoadingFromWeb = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Load Data'),
        actions: [
          CustomDarkThemeSwitch(
            isDarkMode: widget.isDarkMode,
            onChanged: widget.onThemeChanged,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageNavigationBar(
              onSelect: _changeScreen,
              currentPage: 'Load Data',
            ),
            const SizedBox(height: 16),
            Text(
              'SavahnAnimal Predictor',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Load an animal image from your device or from the web to run predictions.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              'Load from device',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _pickFromDevice,
              icon: const Icon(Icons.photo_library),
              label: const Text('Choose image from gallery / files'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _pickMultipleAndGoToPredict,
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('Load album / multiple images'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _captureFromCameraAndGoToPredict,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take picture and open Predict'),
            ),
            const SizedBox(height: 24),
            Text(
              'Load from web',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Image URL',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _loadFromWeb,
                icon: const Icon(Icons.cloud_download),
                label: const Text('Load from URL'),
              ),
            ),
            if (_isLoadingFromWeb) ...[
              const SizedBox(height: 8),
              const LinearProgressIndicator(),
            ],
            const SizedBox(height: 24),
            if (_imageBytes != null ||
                (_imageUrl != null && _imageUrl!.isNotEmpty))
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Preview',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _imageBytes != null
                          ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                          : Image.network(_imageUrl!, fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class CnnPredictionPage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final Uint8List? initialImage;
  final List<Uint8List>? initialImages;
  const CnnPredictionPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    this.initialImage,
    this.initialImages,
  });

  @override
  State<CnnPredictionPage> createState() => _CnnPredictionPageState();
}

class _CnnPredictionPageState extends State<CnnPredictionPage> {
  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();
  final Random _random = Random();

  final List<Uint8List> _images = [];
  int _currentIndex = 0;
  bool _randomMode = false;

  Interpreter? _interpreter;
  bool _modelLoaded = false;
  String? _modelError;
  List<String> _labels = [];
  String? _prediction;
  List<String> _allPredictions = [];
  bool _feedbackGivenForCurrent = false;
  List<double>? _lastScores;
  String? _lastPredictedLabel;
  Uint8List? _lastImageBytes;

  @override
  void initState() {
    super.initState();
    _loadModel();
    if (widget.initialImages != null && widget.initialImages!.isNotEmpty) {
      _images.addAll(widget.initialImages!);
      _currentIndex = 0;
      _prediction = null;
      _allPredictions = [];
      _feedbackGivenForCurrent = false;
    } else if (widget.initialImage != null) {
      _images.add(widget.initialImage!);
      _currentIndex = _images.length - 1;
      _prediction = null;
      _allPredictions = [];
      _feedbackGivenForCurrent = false;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _interpreter?.close();
    super.dispose();
  }

  void _changeScreen(String screenName) {
    if (screenName == 'Predict') {
      // Already on prediction page
      return;
    } else if (screenName == 'Load Data') {
      Navigator.pushReplacement(
        context,
        _buildPageRoute(
          LoadDataPage(
            isDarkMode: widget.isDarkMode,
            onThemeChanged: widget.onThemeChanged,
          ),
          AxisDirection.left,
        ),
      );
    } else if (screenName == 'Statistics') {
      Navigator.pushReplacement(
        context,
        _buildPageRoute(
          StatisticsPage(
            isDarkMode: widget.isDarkMode,
            onThemeChanged: widget.onThemeChanged,
          ),
          AxisDirection.right,
        ),
      );
    }
  }

  Future<void> _loadModel() async {
    try {
      final interpreter = await Interpreter.fromAsset(
        'assets/cnn_model_20260104_023557.tflite',
      );
      final labelsStr = await rootBundle.loadString(
        'assets/cnn_model_20260104_023557_labels.txt',
      );
      final labels = labelsStr
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      setState(() {
        _interpreter = interpreter;
        _labels = labels;
        _modelLoaded = true;
        _modelError = null;
      });
    } catch (e) {
      setState(() {
        _modelError = 'Failed to load model: $e';
        _modelLoaded = false;
      });
    }
  }

  Future<void> _addImage() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    if (!mounted) return;

    setState(() {
      _images.add(bytes);
      _currentIndex = _images.length - 1;
      _prediction = null;
      _allPredictions = [];
      _feedbackGivenForCurrent = false;
    });
  }

  Future<void> _runPredictionForCurrent() async {
    if (!_modelLoaded || _interpreter == null) return;
    if (_images.isEmpty) return;

    final bytes = _images[_currentIndex];
    final img.Image? original = img.decodeImage(bytes);
    if (original == null) return;

    final inputTensor = _interpreter!.getInputTensor(0);
    final inputShape = inputTensor.shape;
    if (inputShape.length != 4) return;

    final height = inputShape[1];
    final width = inputShape[2];
    final channels = inputShape[3];
    if (channels != 3) return;

    final img.Image resized = img.copyResize(
      original,
      width: width,
      height: height,
    );

    // The Keras/TFLite model already includes a Rescaling(1./255) layer,
    // so we pass raw 0-255 RGB values here (no extra division).
    final input = List.generate(
      1,
      (_) => List.generate(
        height,
        (y) => List.generate(width, (x) {
          final pixel = resized.getPixel(x, y);
          final r = pixel.r.toDouble();
          final g = pixel.g.toDouble();
          final b = pixel.b.toDouble();
          return [r, g, b];
        }),
      ),
    );

    final outputTensor = _interpreter!.getOutputTensor(0);
    final outputShape = outputTensor.shape;
    final numClasses = outputShape.last;
    final output = List.generate(
      1,
      (_) => List<double>.filled(numClasses, 0.0),
    );

    _interpreter!.run(input, output);

    final scores = output[0];
    int bestIndex = 0;
    double bestScore = scores[0];
    for (int i = 1; i < scores.length; i++) {
      if (scores[i] > bestScore) {
        bestScore = scores[i];
        bestIndex = i;
      }
    }

    final label = (bestIndex < _labels.length)
        ? _labels[bestIndex]
        : '#$bestIndex';

    // Remember full prediction context so user feedback can be stored
    _lastScores = List<double>.from(scores);
    _lastPredictedLabel = label;
    _lastImageBytes = Uint8List.fromList(bytes);

    // Build list of all class probabilities (e.g., 6 classes)
    final List<String> allPredictions = [];
    for (int i = 0; i < scores.length; i++) {
      final classLabel = (i < _labels.length) ? _labels[i] : '#$i';
      final pct = (scores[i] * 100).toStringAsFixed(1);
      allPredictions.add('$classLabel: $pct%');
    }
    if (!mounted) return;
    setState(() {
      _prediction = '$label (${(bestScore * 100).toStringAsFixed(1)}%)';
      _allPredictions = allPredictions;
      _feedbackGivenForCurrent = false;
    });

    // Update persisted prediction statistics
    await _recordPredictionStats(label, bestScore, scores, _labels);
  }

  /// Append a supervised-learning feedback sample to a JSONL log file.
  /// Each line contains: timestamp, predicted/true label, scores, labels,
  /// whether the prediction was correct, and the image as base64.
  Future<void> _saveSupervisedFeedback({
    required bool isCorrect,
    required String trueLabel,
  }) async {
    if (_lastScores == null ||
        _lastPredictedLabel == null ||
        _lastImageBytes == null ||
        trueLabel.isEmpty) {
      return;
    }

    final Map<String, dynamic> record = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'isCorrect': isCorrect,
      'predictedLabel': _lastPredictedLabel,
      'trueLabel': trueLabel,
      'scores': _lastScores,
      'labels': _labels,
      'imageBase64': base64Encode(_lastImageBytes!),
    };

    final Directory dir = Directory('blobs/supervised_feedback');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    final File file = File(
      '${dir.path}${Platform.pathSeparator}feedback.jsonl',
    );

    await file.writeAsString(
      '${jsonEncode(record)}\n',
      mode: FileMode.append,
      flush: true,
    );
  }

  Future<void> _showPrevious() async {
    if (_images.isEmpty) return;
    setState(() {
      if (_randomMode && _images.length > 1) {
        int nextIndex = _currentIndex;
        while (nextIndex == _currentIndex) {
          nextIndex = _random.nextInt(_images.length);
        }
        _currentIndex = nextIndex;
      } else {
        _currentIndex = (_currentIndex - 1 + _images.length) % _images.length;
      }
      _prediction = null;
      _allPredictions = [];
      _feedbackGivenForCurrent = false;
    });
  }

  Future<void> _showNext() async {
    if (_images.isEmpty) return;
    setState(() {
      if (_randomMode && _images.length > 1) {
        int nextIndex = _currentIndex;
        while (nextIndex == _currentIndex) {
          nextIndex = _random.nextInt(_images.length);
        }
        _currentIndex = nextIndex;
      } else {
        _currentIndex = (_currentIndex + 1) % _images.length;
      }
      _prediction = null;
      _allPredictions = [];
      _feedbackGivenForCurrent = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Predict'),
        actions: [
          CustomDarkThemeSwitch(
            isDarkMode: widget.isDarkMode,
            onChanged: widget.onThemeChanged,
          ),
        ],
      ),
      body: Column(
        children: [
          PageNavigationBar(onSelect: _changeScreen, currentPage: 'Predict'),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Prediction images',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                // Navigation arrows remain here; image selection and
                // random switch are moved under the 224x224 preview.
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: _showPrevious,
                      icon: const Icon(Icons.arrow_back),
                    ),
                    IconButton(
                      onPressed: _showNext,
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_images.isNotEmpty)
                  Text(
                    'Image ${_currentIndex + 1} of ${_images.length}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                if (_modelError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _modelError!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                else if (!_modelLoaded)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: const [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 8),
                        Text('Loading model...'),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: _images.isEmpty
                ? const Center(
                    child: Text('No images loaded. Choose an image to start.'),
                  )
                : ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: GestureDetector(
                                  onHorizontalDragEnd: (details) {
                                    final velocity =
                                        details.primaryVelocity ?? 0.0;
                                    if (velocity < 0) {
                                      _showNext();
                                    } else if (velocity > 0) {
                                      _showPrevious();
                                    }
                                  },
                                  child: SizedBox(
                                    width: 224,
                                    height: 224,
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      transitionBuilder: (child, animation) {
                                        final offsetAnimation = Tween<Offset>(
                                          begin: const Offset(0.1, 0),
                                          end: Offset.zero,
                                        ).animate(animation);
                                        return FadeTransition(
                                          opacity: animation,
                                          child: SlideTransition(
                                            position: offsetAnimation,
                                            child: child,
                                          ),
                                        );
                                      },
                                      child: ClipRRect(
                                        key: ValueKey<int>(_currentIndex),
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.memory(
                                          _images[_currentIndex],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (_prediction != null ||
                                  _allPredictions.isNotEmpty)
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (child, animation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                  child: Column(
                                    key: ValueKey<String>(
                                      '${_prediction ?? ''}_${_allPredictions.join(',')}',
                                    ),
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      if (_prediction != null) ...[
                                        Text(
                                          _prediction!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 12),
                                        if (!_feedbackGivenForCurrent)
                                          Wrap(
                                            spacing: 12,
                                            runSpacing: 8,
                                            alignment: WrapAlignment.center,
                                            children: [
                                              ElevatedButton.icon(
                                                onPressed: () async {
                                                  final ctx = context;
                                                  setState(() {
                                                    _feedbackGivenForCurrent =
                                                        true;
                                                  });
                                                  await _recordPredictionFeedback(
                                                    true,
                                                  );
                                                  await _saveSupervisedFeedback(
                                                    isCorrect: true,
                                                    trueLabel:
                                                        _lastPredictedLabel ??
                                                        '',
                                                  );
                                                  if (!ctx.mounted) return;
                                                  ScaffoldMessenger.of(
                                                    ctx,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Thanks, statistics updated.',
                                                      ),
                                                      duration: Duration(
                                                        milliseconds: 800,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.thumb_up,
                                                  color: Colors.green,
                                                ),
                                                label: const Text(
                                                  'Prediction is correct',
                                                ),
                                              ),
                                              ElevatedButton.icon(
                                                onPressed: () async {
                                                  final ctx = context;
                                                  if (_labels.isEmpty) {
                                                    ScaffoldMessenger.of(
                                                      ctx,
                                                    ).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          'No class labels available to record feedback.',
                                                        ),
                                                      ),
                                                    );
                                                    return;
                                                  }

                                                  String selectedLabel =
                                                      _labels.first;
                                                  final String?
                                                  trueLabel = await showDialog<String>(
                                                    context: ctx,
                                                    builder: (dialogContext) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                          'Select the correct label',
                                                        ),
                                                        content: StatefulBuilder(
                                                          builder:
                                                              (
                                                                context,
                                                                setStateDialog,
                                                              ) {
                                                                return DropdownButtonFormField<
                                                                  String
                                                                >(
                                                                  initialValue:
                                                                      selectedLabel,
                                                                  items: _labels
                                                                      .map(
                                                                        (e) =>
                                                                            DropdownMenuItem<
                                                                              String
                                                                            >(
                                                                              value: e,
                                                                              child: Text(
                                                                                e,
                                                                              ),
                                                                            ),
                                                                      )
                                                                      .toList(),
                                                                  onChanged: (value) {
                                                                    if (value ==
                                                                        null) {
                                                                      return;
                                                                    }
                                                                    setStateDialog(() {
                                                                      selectedLabel =
                                                                          value;
                                                                    });
                                                                  },
                                                                );
                                                              },
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                dialogContext,
                                                              ).pop();
                                                            },
                                                            child: const Text(
                                                              'Cancel',
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                dialogContext,
                                                              ).pop(
                                                                selectedLabel,
                                                              );
                                                            },
                                                            child: const Text(
                                                              'Save',
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );

                                                  if (trueLabel == null ||
                                                      trueLabel.isEmpty) {
                                                    return;
                                                  }

                                                  setState(() {
                                                    _feedbackGivenForCurrent =
                                                        true;
                                                  });
                                                  await _recordPredictionFeedback(
                                                    false,
                                                  );
                                                  await _saveSupervisedFeedback(
                                                    isCorrect: false,
                                                    trueLabel: trueLabel,
                                                  );
                                                  if (!ctx.mounted) return;
                                                  ScaffoldMessenger.of(
                                                    ctx,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Thanks, statistics and labelled sample updated.',
                                                      ),
                                                      duration: Duration(
                                                        milliseconds: 800,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.thumb_down,
                                                  color: Colors.red,
                                                ),
                                                label: const Text(
                                                  'Prediction is wrong',
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                      if (_allPredictions.isNotEmpty) ...[
                                        const SizedBox(height: 16),
                                        Text(
                                          'All class probabilities:',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                        ),
                                        const SizedBox(height: 4),
                                        ..._allPredictions
                                            .take(6)
                                            .map(
                                              (p) => Text(
                                                p,
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                              ),
                                            ),
                                      ],
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 16),
                              // Controls grouped under image and metrics
                              Wrap(
                                spacing: 12,
                                runSpacing: 8,
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: _addImage,
                                    icon: const Icon(Icons.add_photo_alternate),
                                    label: const Text(
                                      'Choose image to predict',
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Random'),
                                      Switch(
                                        value: _randomMode,
                                        onChanged: (val) {
                                          setState(() {
                                            _randomMode = val;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: ElevatedButton.icon(
                                  onPressed:
                                      (_images.isNotEmpty && _modelLoaded)
                                      ? _runPredictionForCurrent
                                      : null,
                                  icon: const Icon(Icons.analytics),
                                  label: const Text('Predict current image'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    textStyle: const TextStyle(fontSize: 16),
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class StatisticsPage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  const StatisticsPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late ScrollController _scrollController;
  bool _cardVisible = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Any other initialization (timers, listeners, etc.)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _cardVisible = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // Dispose any other controllers/resources here
    super.dispose();
  }

  void _changeScreen(String screenName) {
    if (screenName == 'Statistics') {
      // Already on StatisticsPage, do nothing
      return;
    } else if (screenName == 'Load Data') {
      Navigator.pushReplacement(
        context,
        _buildPageRoute(
          LoadDataPage(
            isDarkMode: widget.isDarkMode,
            onThemeChanged: widget.onThemeChanged,
          ),
          AxisDirection.left,
        ),
      );
    } else if (screenName == 'Predict') {
      Navigator.pushReplacement(
        context,
        _buildPageRoute(
          CnnPredictionPage(
            isDarkMode: widget.isDarkMode,
            onThemeChanged: widget.onThemeChanged,
          ),
          AxisDirection.left,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = predictionStats;
    final int totalPredictions = stats.totalPredictions;
    final String totalPredictionsLabel = '$totalPredictions';
    final int classCount = stats.labels.length;
    final String classCountLabel = '$classCount';
    final String lastLabel = stats.lastLabel ?? 'N/A';
    final String lastConfidenceLabel = stats.lastBestScore != null
        ? '${(stats.lastBestScore! * 100).toStringAsFixed(1)}%'
        : 'N/A';
    const String modelAccuracyLabel = '96.542';
    final String mostPredictedLabel = stats.mostPredictedLabel ?? 'N/A';
    final int answered = stats.correctCount + stats.incorrectCount;
    final double accuracyValue = answered > 0
        ? (stats.correctCount * 100 / answered)
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        actions: [
          CustomDarkThemeSwitch(
            isDarkMode: widget.isDarkMode,
            onChanged: widget.onThemeChanged,
          ),
        ],
      ),
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            color:
                Theme.of(context).appBarTheme.backgroundColor ??
                Theme.of(context).colorScheme.primary,
            height: 100,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat(
                    Icons.analytics,
                    totalPredictionsLabel,
                    'Total Predictions',
                  ),
                  _buildStat(Icons.category, classCountLabel, 'CNN Classes'),
                  _buildStat(
                    Icons.check_circle_outline,
                    lastConfidenceLabel,
                    'Last Confidence',
                  ),
                  _buildStat(Icons.star, mostPredictedLabel, 'Most Predicted'),
                ],
              ),
            ),
          ),
          PageNavigationBar(onSelect: _changeScreen, currentPage: 'Statistics'),
          const SizedBox(height: 32),
          AnimatedScale(
            scale: _cardVisible ? 1.0 : 0.95,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.memory, color: Colors.deepPurple),
                              SizedBox(width: 8),
                              Expanded(
                                child: Tooltip(
                                  waitDuration: Duration(seconds: 2),
                                  message: 'CNN Model Metrics',
                                  child: Text(
                                    'CNN Model Metrics',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Model file: cnn_model_20260104_023557.tflite',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Number of classes: $classCountLabel',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Model accuracy: $modelAccuracyLabel',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Last confidence: $lastConfidenceLabel',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          TweenAnimationBuilder<double>(
                            duration: const Duration(milliseconds: 300),
                            tween: Tween<double>(begin: 0, end: accuracyValue),
                            builder: (context, value, child) {
                              final String labelText = answered > 0
                                  ? 'User-labelled accuracy: '
                                        '${value.toStringAsFixed(3)}%'
                                  : 'User-labelled accuracy: N/A';
                              return Text(
                                labelText,
                                style: const TextStyle(fontSize: 16),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.person, color: Colors.indigo),
                              SizedBox(width: 8),
                              Expanded(
                                child: Tooltip(
                                  waitDuration: Duration(seconds: 2),
                                  message: 'User Prediction Metrics',
                                  child: Text(
                                    'User Prediction Metrics',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TweenAnimationBuilder<int>(
                            duration: const Duration(milliseconds: 300),
                            tween: IntTween(begin: 0, end: totalPredictions),
                            builder: (context, value, child) {
                              return Text(
                                'Total predictions made: $value',
                                style: const TextStyle(fontSize: 16),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Most predicted class: $mostPredictedLabel',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Last predicted class: $lastLabel',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          TweenAnimationBuilder<int>(
                            duration: const Duration(milliseconds: 300),
                            tween: IntTween(begin: 0, end: stats.correctCount),
                            builder: (context, value, child) {
                              return Text(
                                'Marked correct: $value',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.green,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          TweenAnimationBuilder<int>(
                            duration: const Duration(milliseconds: 300),
                            tween: IntTween(
                              begin: 0,
                              end: stats.incorrectCount,
                            ),
                            builder: (context, value, child) {
                              return Text(
                                'Marked wrong: $value',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final bool? confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Reset statistics'),
                                    content: const Text(
                                      'Do you really want to reset all user statistics?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        child: const Text('Reset'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirm == true) {
                                await resetPredictionStats();
                                if (mounted) {
                                  setState(() {});
                                }
                              }
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reset user statistics'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              textStyle: const TextStyle(fontSize: 14),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
