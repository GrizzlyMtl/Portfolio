import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF5200BC),
    brightness: Brightness.light,
  ),
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFFF5F5F7),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF5200BC),
    foregroundColor: Colors.white,
    elevation: 2,
    centerTitle: true,
  ),
  cardTheme: const CardThemeData(
    elevation: 2,
    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
);

final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFBB86FC),
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1F1B2E),
    foregroundColor: Colors.white,
    elevation: 2,
    centerTitle: true,
  ),
  cardTheme: const CardThemeData(
    elevation: 2,
    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
);

class Product {
  final String name;
  final double buyingPrice;
  final double sellingPrice;
  final String category;
  final bool inStock;
  final int quantity;
  Product({
    required this.name,
    required this.buyingPrice,
    required this.sellingPrice,
    required this.category,
    required this.inStock,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'buyingPrice': buyingPrice,
      'sellingPrice': sellingPrice,
      'category': category,
      'inStock': inStock,
      'quantity': quantity,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    // Backwards compatibility for older data that only stored 'price'
    final hasBuying = json.containsKey('buyingPrice');
    final hasSelling = json.containsKey('sellingPrice');
    final double legacyPrice = json.containsKey('price')
        ? (json['price'] as num).toDouble()
        : 0.0;
    final double buying = hasBuying
        ? (json['buyingPrice'] as num).toDouble()
        : legacyPrice;
    final double selling = hasSelling
        ? (json['sellingPrice'] as num).toDouble()
        : legacyPrice;

    return Product(
      name: json['name'] as String,
      buyingPrice: buying,
      sellingPrice: selling,
      category: json['category'] as String,
      inStock: json['inStock'] as bool,
      quantity: json['quantity'] as int,
    );
  }
}

// Global product list
List<Product> productList = [];

const String productListPrefKey = 'productList';

Future<void> saveProductList() async {
  final prefs = await SharedPreferences.getInstance();
  final List<Map<String, dynamic>> data = productList
      .map((p) => p.toJson())
      .toList();
  await prefs.setString(productListPrefKey, jsonEncode(data));
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
    final String? productsJson = prefs.getString(productListPrefKey);
    if (productsJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(productsJson);
        productList = decoded
            .map((e) => Product.fromJson(e as Map<String, dynamic>))
            .toList();

        // One-time migration: if older products have buyingPrice equal to
        // sellingPrice, derive a plausible buyingPrice (e.g. 70% of selling).
        bool updated = false;
        productList = productList.map((p) {
          if (p.sellingPrice > 0 && p.buyingPrice == p.sellingPrice) {
            updated = true;
            final double newBuying = p.sellingPrice * 0.7;
            return Product(
              name: p.name,
              buyingPrice: newBuying,
              sellingPrice: p.sellingPrice,
              category: p.category,
              inStock: p.inStock,
              quantity: p.quantity,
            );
          }
          return p;
        }).toList();

        if (updated) {
          await saveProductList();
        }
      } catch (_) {
        productList = [];
      }
    }

    if (productList.isEmpty) {
      productList = [
        Product(
          name: 'Laptop Pro 15"',
          buyingPrice: 800.0,
          sellingPrice: 1200.0,
          category: 'Electronics',
          inStock: true,
          quantity: 10,
        ),
        Product(
          name: 'Wireless Mouse',
          buyingPrice: 10.0,
          sellingPrice: 19.99,
          category: 'Electronics',
          inStock: true,
          quantity: 40,
        ),
        Product(
          name: 'Mechanical Keyboard',
          buyingPrice: 35.0,
          sellingPrice: 59.99,
          category: 'Electronics',
          inStock: true,
          quantity: 25,
        ),
        Product(
          name: '4K Monitor 27"',
          buyingPrice: 180.0,
          sellingPrice: 299.99,
          category: 'Electronics',
          inStock: true,
          quantity: 8,
        ),
        Product(
          name: 'Smartphone Case',
          buyingPrice: 3.0,
          sellingPrice: 9.99,
          category: 'Electronics',
          inStock: true,
          quantity: 60,
        ),
        Product(
          name: 'Men\'s T-Shirt',
          buyingPrice: 6.0,
          sellingPrice: 14.99,
          category: 'Clothing',
          inStock: true,
          quantity: 50,
        ),
        Product(
          name: 'Women\'s Jeans',
          buyingPrice: 18.0,
          sellingPrice: 39.99,
          category: 'Clothing',
          inStock: true,
          quantity: 30,
        ),
        Product(
          name: 'Hoodie Unisex',
          buyingPrice: 20.0,
          sellingPrice: 44.99,
          category: 'Clothing',
          inStock: true,
          quantity: 22,
        ),
        Product(
          name: 'Running Shoes',
          buyingPrice: 35.0,
          sellingPrice: 69.99,
          category: 'Clothing',
          inStock: true,
          quantity: 18,
        ),
        Product(
          name: 'Baseball Cap',
          buyingPrice: 4.0,
          sellingPrice: 11.99,
          category: 'Clothing',
          inStock: true,
          quantity: 35,
        ),
        Product(
          name: 'Pasta Pack 500g',
          buyingPrice: 0.6,
          sellingPrice: 1.49,
          category: 'Food',
          inStock: true,
          quantity: 80,
        ),
        Product(
          name: 'Olive Oil 1L',
          buyingPrice: 3.0,
          sellingPrice: 6.49,
          category: 'Food',
          inStock: true,
          quantity: 40,
        ),
        Product(
          name: 'Breakfast Cereal',
          buyingPrice: 1.8,
          sellingPrice: 3.99,
          category: 'Food',
          inStock: true,
          quantity: 45,
        ),
        Product(
          name: 'Chocolate Bar',
          buyingPrice: 0.4,
          sellingPrice: 0.99,
          category: 'Food',
          inStock: true,
          quantity: 120,
        ),
        Product(
          name: 'Gummy Bears Pack',
          buyingPrice: 0.5,
          sellingPrice: 1.29,
          category: 'Food',
          inStock: true,
          quantity: 70,
        ),
        Product(
          name: 'Building Blocks Set',
          buyingPrice: 10.0,
          sellingPrice: 24.99,
          category: 'Toys',
          inStock: true,
          quantity: 15,
        ),
        Product(
          name: 'Plush Teddy Bear',
          buyingPrice: 5.0,
          sellingPrice: 14.99,
          category: 'Toys',
          inStock: true,
          quantity: 20,
        ),
        Product(
          name: 'Board Game Classic',
          buyingPrice: 9.0,
          sellingPrice: 22.99,
          category: 'Toys',
          inStock: true,
          quantity: 12,
        ),
        Product(
          name: 'Non-stick Frying Pan',
          buyingPrice: 8.0,
          sellingPrice: 19.99,
          category: 'Kitchen',
          inStock: true,
          quantity: 16,
        ),
        Product(
          name: 'Chef Knife Set',
          buyingPrice: 15.0,
          sellingPrice: 34.99,
          category: 'Kitchen',
          inStock: true,
          quantity: 10,
        ),
      ];
      await saveProductList();
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
            _buildTab(context, 'Add Product'),
            _buildTab(context, 'Product List'),
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
      Text(
        label,
        style: const TextStyle(
          color: Color.fromARGB(255, 197, 197, 197),
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
      ),
    ],
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manag' ventory"),
        centerTitle: true,
        actions: [
          CustomDarkThemeSwitch(
            isDarkMode: isDarkMode,
            onChanged: onThemeChanged,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to Manag'Ventory!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddProductPage(
                      totalItems: 0,
                      inStockItems: 0,
                      isDarkMode: isDarkMode,
                      onThemeChanged: onThemeChanged,
                    ),
                  ),
                );
              },
              child: const Text('Enter Inventory Management'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddProductPage extends StatefulWidget {
  final int totalItems;
  final int inStockItems;
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  const AddProductPage({
    super.key,
    required this.totalItems,
    required this.inStockItems,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController buyingPriceController;
  late TextEditingController sellingPriceController;
  String? selectedCategory;
  bool inStock = false;
  double quantity = 0;
  final List<String> categories = [
    'Electronics',
    'Clothing',
    'Food',
    'Toys',
    'Kitchen',
    'Books',
  ];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    buyingPriceController = TextEditingController();
    sellingPriceController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    buyingPriceController.dispose();
    sellingPriceController.dispose();
    super.dispose();
  }

  void _changeScreen(String screenName) {
    if (screenName == 'Add Product') {
      // Already on AddProductPage, do nothing or maybe pop to root
      return;
    } else if (screenName == 'Product List') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProductListPage(
            totalItems: productList.length,
            inStockItems: productList.where((p) => p.inStock).length,
            isDarkMode: widget.isDarkMode,
            onThemeChanged: widget.onThemeChanged,
          ),
        ),
      );
    } else if (screenName == 'Statistics') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StatisticsPage(
            totalItems: productList.length,
            inStockItems: productList.where((p) => p.inStock).length,
            isDarkMode: widget.isDarkMode,
            onThemeChanged: widget.onThemeChanged,
          ),
        ),
      );
    }
  }

  double getTotalInventoryValue() {
    return productList.fold(
      0.0,
      (sum, p) => sum + (p.sellingPrice * p.quantity),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double totalValue = getTotalInventoryValue();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        actions: [
          CustomDarkThemeSwitch(
            isDarkMode: widget.isDarkMode,
            onChanged: widget.onThemeChanged,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              color:
                  Theme.of(context).appBarTheme.backgroundColor ??
                  Theme.of(context).colorScheme.primary,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat(
                    Icons.inventory,
                    '${widget.totalItems}',
                    'Total Items',
                  ),
                  _buildStat(
                    Icons.playlist_add_check_circle_outlined,
                    '${widget.inStockItems}',
                    'In Stock',
                  ),
                  _buildStat(
                    Icons.money_rounded,
                    '${widget.totalItems - widget.inStockItems}',
                    'Out of Stock',
                  ),
                  _buildStat(
                    Icons.attach_money,
                    '${totalValue.toStringAsFixed(2)}\$',
                    'Inventory Value',
                  ),
                ],
              ),
            ),
            PageNavigationBar(
              onSelect: _changeScreen,
              currentPage: 'Add Product',
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Manage Inventory',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Product Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a product name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: buyingPriceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Buying Price',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a buying price';
                        }
                        final price = double.tryParse(value);
                        if (price == null || price < 0) {
                          return 'Enter a valid buying price';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: sellingPriceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Selling Price',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a selling price';
                        }
                        final price = double.tryParse(value);
                        if (price == null || price < 0) {
                          return 'Enter a valid selling price';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: selectedCategory,
                      items: categories
                          .map(
                            (cat) =>
                                DropdownMenuItem(value: cat, child: Text(cat)),
                          )
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedCategory = val;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('In Stock'),
                        Switch(
                          value: inStock,
                          onChanged: (val) {
                            setState(() {
                              inStock = val;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Quantity'),
                        Expanded(
                          child: Slider(
                            value: quantity,
                            min: 0,
                            max: 500,
                            divisions: 100,
                            label: quantity.round().toString(),
                            onChanged: (val) {
                              setState(() {
                                quantity = val;
                                inStock = val > 0;
                              });
                            },
                          ),
                        ),
                        Text(quantity.round().toString()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            productList.add(
                              Product(
                                name: nameController.text.trim(),
                                buyingPrice: double.parse(
                                  buyingPriceController.text.trim(),
                                ),
                                sellingPrice: double.parse(
                                  sellingPriceController.text.trim(),
                                ),
                                category: selectedCategory!,
                                inStock: inStock,
                                quantity: quantity.round(),
                              ),
                            );
                            await saveProductList();
                            if (!mounted) return;
                            setState(() {
                              nameController.clear();
                              buyingPriceController.clear();
                              sellingPriceController.clear();
                              selectedCategory = null;
                              inStock = true;
                              quantity = 0;
                            });
                            FocusScope.of(this.context).unfocus();
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              const SnackBar(content: Text('Product added!')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: const Text('Add Product'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductListPage extends StatefulWidget {
  final int totalItems;
  final int inStockItems;
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  const ProductListPage({
    super.key,
    required this.totalItems,
    required this.inStockItems,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late ScrollController _scrollController;
  String _filterMode = 'In stock';
  String? _selectedCategoryFilter;
  late TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();
    // Any other initialization (timers, listeners, etc.)
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    // Dispose any other controllers/resources here
    super.dispose();
  }

  void _changeScreen(String screenName) {
    if (screenName == 'Product List') {
      // Already on ProductListPage, do nothing
      return;
    } else if (screenName == 'Add Product') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AddProductPage(
            totalItems: productList.length,
            inStockItems: productList.where((p) => p.inStock).length,
            isDarkMode: widget.isDarkMode,
            onThemeChanged: widget.onThemeChanged,
          ),
        ),
      );
    } else if (screenName == 'Statistics') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StatisticsPage(
            totalItems: productList.length,
            inStockItems: productList.where((p) => p.inStock).length,
            isDarkMode: widget.isDarkMode,
            onThemeChanged: widget.onThemeChanged,
          ),
        ),
      );
    }
  }

  double getTotalInventoryValue() {
    return productList.fold(
      0.0,
      (sum, p) => sum + (p.sellingPrice * p.quantity),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> availableCategories =
        productList.map((p) => p.category).toSet().toList()..sort();

    List<Product> filteredProducts;
    switch (_filterMode) {
      case 'All':
        filteredProducts = List<Product>.from(productList);
        break;
      case 'In stock':
        filteredProducts = productList.where((p) => p.inStock).toList();
        break;
      case 'Out of stock':
        filteredProducts = productList.where((p) => !p.inStock).toList();
        break;
      case 'By category':
        if (_selectedCategoryFilter == null) {
          filteredProducts = List<Product>.from(productList);
        } else {
          filteredProducts = productList
              .where((p) => p.category == _selectedCategoryFilter)
              .toList();
        }
        break;
      default:
        filteredProducts = List<Product>.from(productList);
        break;
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filteredProducts = filteredProducts
          .where((p) => p.name.toLowerCase().contains(query))
          .toList();
    }

    String emptyMessage = '';
    if (filteredProducts.isEmpty) {
      if (productList.isEmpty) {
        emptyMessage = 'No products available.';
      } else if (_searchQuery.isNotEmpty) {
        emptyMessage = 'No products match your search.';
      } else {
        switch (_filterMode) {
          case 'All':
            emptyMessage = 'No products to display.';
            break;
          case 'In stock':
            emptyMessage = 'No in-stock products.';
            break;
          case 'Out of stock':
            emptyMessage = 'No out-of-stock products.';
            break;
          case 'By category':
            emptyMessage = _selectedCategoryFilter == null
                ? 'Select a category to filter.'
                : 'No products in the selected category.';
            break;
          default:
            emptyMessage = 'No products to display.';
            break;
        }
      }
    }
    final double totalValue = getTotalInventoryValue();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStat(
                  Icons.inventory,
                  '${widget.totalItems}',
                  'Total Items',
                ),
                _buildStat(
                  Icons.playlist_add_check_circle_outlined,
                  '${widget.inStockItems}',
                  'In Stock',
                ),
                _buildStat(
                  Icons.money_rounded,
                  '${widget.totalItems - widget.inStockItems}',
                  'Out of Stock',
                ),
                _buildStat(
                  Icons.attach_money,
                  '${totalValue.toStringAsFixed(2)}\$',
                  'Inventory Value',
                ),
              ],
            ),
          ),
          PageNavigationBar(
            onSelect: _changeScreen,
            currentPage: 'Product List',
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Filter:',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: _filterMode,
                      items: const [
                        DropdownMenuItem(
                          value: 'All',
                          child: Text('All products'),
                        ),
                        DropdownMenuItem(
                          value: 'In stock',
                          child: Text('In stock'),
                        ),
                        DropdownMenuItem(
                          value: 'Out of stock',
                          child: Text('Out of stock'),
                        ),
                        DropdownMenuItem(
                          value: 'By category',
                          child: Text('By category'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _filterMode = value;
                          if (_filterMode != 'By category') {
                            _selectedCategoryFilter = null;
                          }
                        });
                      },
                    ),
                  ],
                ),
                if (_filterMode == 'By category')
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: DropdownButton<String>(
                      value: _selectedCategoryFilter,
                      hint: const Text('Select category'),
                      items: availableCategories
                          .map(
                            (cat) =>
                                DropdownMenuItem(value: cat, child: Text(cat)),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoryFilter = value;
                        });
                      },
                    ),
                  ),
                const SizedBox(height: 8),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search by name',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                                _searchController.clear();
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(child: Text(emptyMessage))
                : ListView.separated(
                    controller: _scrollController,
                    itemCount: filteredProducts.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      final originalIndex = productList.indexOf(product);
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: Icon(
                            product.inStock ? Icons.check_circle : Icons.cancel,
                            color: product.inStock ? Colors.green : Colors.red,
                          ),
                          title: Text(
                            product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Buying: ${product.buyingPrice.toStringAsFixed(2)} | Selling: ${product.sellingPrice.toStringAsFixed(2)}',
                              ),
                              Text('Category: ${product.category}'),
                              Text('Quantity: ${product.quantity}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Add stock',
                                icon: const Icon(Icons.add_circle_outline),
                                color: Colors.blueGrey,
                                onPressed: () async {
                                  if (originalIndex == -1) return;

                                  final controller = TextEditingController();
                                  final added = await showDialog<int>(
                                    context: context,
                                    builder: (dialogContext) {
                                      return AlertDialog(
                                        title: const Text('Add Stock'),
                                        content: TextField(
                                          controller: controller,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            labelText: 'Quantity to add',
                                            hintText: 'e.g. 10',
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(dialogContext).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              final value = int.tryParse(
                                                controller.text.trim(),
                                              );
                                              if (value == null || value <= 0) {
                                                Navigator.of(
                                                  dialogContext,
                                                ).pop();
                                              } else {
                                                Navigator.of(
                                                  dialogContext,
                                                ).pop(value);
                                              }
                                            },
                                            child: const Text('Add'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (!context.mounted) return;
                                  if (added == null || added <= 0) return;

                                  setState(() {
                                    final current = productList[originalIndex];
                                    final newQuantity =
                                        current.quantity + added;
                                    productList[originalIndex] = Product(
                                      name: current.name,
                                      buyingPrice: current.buyingPrice,
                                      sellingPrice: current.sellingPrice,
                                      category: current.category,
                                      inStock: newQuantity > 0,
                                      quantity: newQuantity,
                                    );
                                  });
                                  await saveProductList();
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Added $added to ${product.name} stock.',
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Text(
                                product.inStock ? 'In stock' : 'Out of stock',
                                style: TextStyle(
                                  color: product.inStock
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 8),
                              Switch(
                                value: product.inStock,
                                onChanged: (val) async {
                                  if (originalIndex == -1) return;
                                  setState(() {
                                    final current = productList[originalIndex];
                                    productList[originalIndex] = Product(
                                      name: current.name,
                                      buyingPrice: current.buyingPrice,
                                      sellingPrice: current.sellingPrice,
                                      category: current.category,
                                      inStock: val,
                                      quantity: current.quantity,
                                    );
                                  });
                                  await saveProductList();
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  if (originalIndex == -1) return;
                                  setState(() {
                                    productList.removeAt(originalIndex);
                                  });
                                  await saveProductList();
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Product deleted.'),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class StatisticsPage extends StatefulWidget {
  final int totalItems;
  final int inStockItems;
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  const StatisticsPage({
    super.key,
    required this.totalItems,
    required this.inStockItems,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Any other initialization (timers, listeners, etc.)
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
    } else if (screenName == 'Add Product') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AddProductPage(
            totalItems: productList.length,
            inStockItems: productList.where((p) => p.inStock).length,
            isDarkMode: widget.isDarkMode,
            onThemeChanged: widget.onThemeChanged,
          ),
        ),
      );
    } else if (screenName == 'Product List') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProductListPage(
            totalItems: productList.length,
            inStockItems: productList.where((p) => p.inStock).length,
            isDarkMode: widget.isDarkMode,
            onThemeChanged: widget.onThemeChanged,
          ),
        ),
      );
    }
  }

  double getTotalInventoryValue() {
    return productList.fold(
      0.0,
      (sum, p) => sum + (p.sellingPrice * p.quantity),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int totalProducts = productList.length;
    final int inStockCount = productList.where((p) => p.inStock).length;
    final int outOfStockCount = totalProducts - inStockCount;
    final double totalValue = getTotalInventoryValue();
    final double totalCost = productList.fold(
      0.0,
      (sum, p) => sum + (p.buyingPrice * p.quantity),
    );
    final double potentialProfit = totalValue - totalCost;
    final double averageMarginPercent = totalValue > 0
        ? ((potentialProfit / totalValue) * 100).clamp(-9999.0, 9999.0)
        : 0.0;
    final int totalUnits = productList.fold(0, (sum, p) => sum + p.quantity);

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStat(Icons.inventory, '$totalProducts', 'Total Items'),
                _buildStat(Icons.check_circle, '$inStockCount', 'In Stock'),
                _buildStat(
                  Icons.money_rounded,
                  '$outOfStockCount',
                  'Out of Stock',
                ),
                _buildStat(
                  Icons.attach_money,
                  '${totalValue.toStringAsFixed(2)}\$',
                  'Inventory Value',
                ),
              ],
            ),
          ),
          PageNavigationBar(onSelect: _changeScreen, currentPage: 'Statistics'),
          const SizedBox(height: 32),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.list_alt, color: Colors.deepPurple),
                      const SizedBox(width: 8),
                      Text(
                        'Distinct Products: $totalProducts',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.inventory_2, color: Colors.indigo),
                      const SizedBox(width: 8),
                      Text(
                        'Total Product Count: $totalUnits',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        'In Stock: $inStockCount',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.attach_money, color: Colors.amber),
                      const SizedBox(width: 8),
                      Text(
                        'Total Inventory Value: ${totalValue.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.shopping_cart, color: Colors.blueGrey),
                      const SizedBox(width: 8),
                      Text(
                        'Total Buying Cost: ${totalCost.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.trending_up, color: Colors.redAccent),
                      const SizedBox(width: 8),
                      Text(
                        'Potential Profit: ${potentialProfit.toStringAsFixed(2)} (${averageMarginPercent.toStringAsFixed(1)}%)',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
