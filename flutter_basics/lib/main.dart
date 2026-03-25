import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final IconData? icon;
  final bool? isSelected;
  final int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    this.icon,
    this.isSelected = false,
    this.quantity = 1,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});

  double get totalPrice => product.price * quantity;
}

final List<CartItem> cartItems = [];
bool expressDeliverySelected = false;

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/ProductPage',
      routes: {
        '/ProductPage': (context) => ProductPage(),
        '/CartPage': (context) => CartPage(),
        '/CheckoutPage': (context) => CheckoutPage(),
      },
    ),
  );
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  ProductPageState createState() => ProductPageState();
}

class ProductPageState extends State<ProductPage> {
  final List<Product> products = [
    Product(
      id: '1',
      name: 'Bread',
      price: 5.99,
      category: 'Bakery',
      icon: Icons.bakery_dining,
    ),
    Product(
      id: '2',
      name: 'Bacon',
      price: 8.99,
      category: 'Meat',
      icon: FontAwesomeIcons.bacon,
    ),
    Product(
      id: '3',
      name: 'Eggs',
      price: 3.49,
      category: 'Breakfast',
      icon: Icons.egg,
    ),
    Product(
      id: '4',
      name: 'Milk',
      price: 6.99,
      category: 'Dairy',
      icon: Icons.local_drink,
    ),
    Product(
      id: '5',
      name: 'Cheese',
      price: 4.99,
      category: 'Dairy',
      icon: FontAwesomeIcons.cheese,
    ),
    Product(
      id: '6',
      name: 'Butter',
      price: 2.99,
      category: 'Dairy',
      icon: FontAwesomeIcons.cakeCandles,
    ),
    Product(
      id: '7',
      name: 'Cereal',
      price: 6.99,
      category: 'Breakfast',
      icon: Icons.breakfast_dining,
    ),
    Product(
      id: '8',
      name: 'Orange Juice',
      price: 4.99,
      category: 'Beverages',
      icon: Icons.local_drink,
    ),
    Product(
      id: '9',
      name: 'Yogurt',
      price: 5.49,
      category: 'Dairy',
      icon: FontAwesomeIcons.cow,
    ),
    Product(
      id: '10',
      name: 'Waffles',
      price: 4.49,
      category: 'Breakfast',
      icon: Icons.breakfast_dining,
    ),
    Product(
      id: '11',
      name: 'Bagels',
      price: 3.99,
      category: 'Bakery',
      icon: Icons.bakery_dining,
    ),
    Product(
      id: '12',
      name: 'Ham',
      price: 9.49,
      category: 'Meat',
      icon: Icons.set_meal,
    ),
    Product(
      id: '13',
      name: 'Sausages',
      price: 7.99,
      category: 'Meat',
      icon: Icons.set_meal,
    ),
    Product(
      id: '14',
      name: 'Apple Juice',
      price: 3.99,
      category: 'Beverages',
      icon: Icons.local_drink,
    ),
    Product(
      id: '15',
      name: 'Coffee',
      price: 7.49,
      category: 'Beverages',
      icon: Icons.coffee,
    ),
    Product(
      id: '16',
      name: 'Tea',
      price: 4.29,
      category: 'Beverages',
      icon: FontAwesomeIcons.mugSaucer,
    ),
    Product(
      id: '17',
      name: 'Cream Cheese',
      price: 3.59,
      category: 'Dairy',
      icon: FontAwesomeIcons.cheese,
    ),
    Product(
      id: '18',
      name: 'Pancake Mix',
      price: 5.29,
      category: 'Breakfast',
      icon: Icons.breakfast_dining,
    ),
    Product(
      id: '19',
      name: 'Granola Bars',
      price: 4.19,
      category: 'Breakfast',
      icon: Icons.energy_savings_leaf,
    ),
    Product(
      id: '20',
      name: 'Muffins',
      price: 3.89,
      category: 'Bakery',
      icon: Icons.bakery_dining,
    ),
  ];

  String _selectedCategoryFilter = 'All';
  final Set<String> _selectedProductIds = {};
  final Map<String, int> _productQuantities = {};
  Product? selectedProduct;
  double _selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    final List<Product> filteredProducts = _selectedCategoryFilter == 'All'
        ? products
        : products.where((p) => p.category == _selectedCategoryFilter).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Product List')),
      body: Center(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/ProductPage');
                      },
                      child: const Text('Go to Products'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/CartPage');
                      },
                      child: const Text('Go to Cart'),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Filter by category:'),
                  DropdownButton<String>(
                    value: _selectedCategoryFilter,
                    items:
                        <String>[
                              'All',
                              ...{for (final p in products) p.category},
                            ]
                            .map(
                              (value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _selectedCategoryFilter = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedProduct = product;
                        final savedQty = _productQuantities[product.id] ?? 1;
                        _selectedQuantity = savedQty.toDouble();
                      });
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            if (product.icon != null)
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.blue,
                                  child: Icon(
                                    product.icon,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                product.category,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Checkbox(
                              value: _selectedProductIds.contains(product.id),
                              onChanged: (checked) {
                                setState(() {
                                  if (checked == true) {
                                    _selectedProductIds.add(product.id);
                                  } else {
                                    _selectedProductIds.remove(product.id);
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_selectedProductIds.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      final selectedProducts = products
                          .where((p) => _selectedProductIds.contains(p.id))
                          .toList();

                      int totalItemsAdded = 0;

                      for (final product in selectedProducts) {
                        final qty = _productQuantities[product.id] ?? 1;
                        final existingIndex = cartItems.indexWhere(
                          (item) => item.product.id == product.id,
                        );

                        if (existingIndex >= 0) {
                          cartItems[existingIndex].quantity += qty;
                        } else {
                          cartItems.add(
                            CartItem(product: product, quantity: qty),
                          );
                        }

                        totalItemsAdded += qty;
                      }

                      setState(() {
                        _selectedProductIds.clear();
                      });

                      if (selectedProducts.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 2),
                            content: Text(
                              'Added $totalItemsAdded items to cart',
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Add selected to cart'),
                  ),
                ),
              ),
            if (selectedProduct != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          selectedProduct!.name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          selectedProduct!.category,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Text('\$${selectedProduct!.price.toStringAsFixed(2)}'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('Quantity:'),
                            const SizedBox(width: 8),
                            Text(_selectedQuantity.toInt().toString()),
                          ],
                        ),
                        Slider(
                          min: 1,
                          max: 10,
                          divisions: 9,
                          value: _selectedQuantity,
                          label: _selectedQuantity.toInt().toString(),
                          onChanged: (value) {
                            setState(() {
                              _selectedQuantity = value;
                              if (selectedProduct != null) {
                                _productQuantities[selectedProduct!.id] = value
                                    .toInt();
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              final existingIndex = cartItems.indexWhere(
                                (item) =>
                                    item.product.id == selectedProduct!.id,
                              );

                              final qty = _selectedQuantity.toInt();

                              _productQuantities[selectedProduct!.id] = qty;

                              if (existingIndex >= 0) {
                                cartItems[existingIndex].quantity += qty;
                              } else {
                                cartItems.add(
                                  CartItem(
                                    product: selectedProduct!,
                                    quantity: qty,
                                  ),
                                );
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(
                                    seconds: 1,
                                    milliseconds: 200,
                                  ),
                                  content: Text(
                                    'Added $qty × ${selectedProduct!.name} to cart',
                                  ),
                                ),
                              );
                            },
                            child: const Text('Add to cart'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  String _selectedCategoryFilter = 'All';
  bool _expressDelivery = expressDeliverySelected;

  @override
  Widget build(BuildContext context) {
    final double subtotal = cartItems.fold(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );
    final double tps = subtotal * 0.05;
    final double tvq = subtotal * 0.09975;
    final double expressFee = _expressDelivery ? 5.0 : 0.0;
    final double total = subtotal + tps + tvq + expressFee;

    final visibleItems = _selectedCategoryFilter == 'All'
        ? cartItems
        : cartItems
              .where((item) => item.product.category == _selectedCategoryFilter)
              .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Filter by category:'),
                DropdownButton<String>(
                  value: _selectedCategoryFilter,
                  items:
                      <String>[
                            'All',
                            ...{
                              for (final item in cartItems)
                                item.product.category,
                            },
                          ]
                          .map(
                            (value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _selectedCategoryFilter = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Product: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Category: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text('Price: ', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: visibleItems.isEmpty
                ? const Center(child: Text('Your cart is empty'))
                : ListView.builder(
                    itemCount: visibleItems.length,
                    itemBuilder: (context, index) {
                      final item = visibleItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (item.product.icon != null)
                                Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.blue,
                                    child: Icon(
                                      item.product.icon,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Category: ${item.product.category}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Price: \$${item.product.price.toStringAsFixed(2)}',
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Line total: \$${item.totalPrice.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          setState(() {
                                            if (item.quantity > 1) {
                                              item.quantity--;
                                            } else {
                                              cartItems.removeAt(index);
                                            }
                                          });
                                        },
                                      ),
                                      Text(item.quantity.toString()),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          setState(() {
                                            item.quantity++;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        cartItems.removeAt(index);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    label: const Text(
                                      'Remove',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          SwitchListTile(
            title: const Text('Express delivery (+\$5.00)'),
            value: _expressDelivery,
            onChanged: (value) {
              setState(() {
                _expressDelivery = value;
                expressDeliverySelected = value;
              });
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 4,
                  offset: Offset(0, -2),
                  color: Colors.black12,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal:'),
                    Text('\$${subtotal.toStringAsFixed(2)}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('TPS (5%):'),
                    Text('\$${tps.toStringAsFixed(2)}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('TVQ (9.975%):'),
                    Text('\$${tvq.toStringAsFixed(2)}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Express delivery:'),
                    Text('\$${expressFee.toStringAsFixed(2)}'),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: cartItems.isEmpty
                      ? null
                      : () {
                          Navigator.pushNamed(context, '/CheckoutPage');
                        },
                  child: const Text('Pay'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  CheckoutPageState createState() => CheckoutPageState();
}

class CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    final double subtotal = cartItems.fold(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );
    final double tps = subtotal * 0.05;
    final double tvq = subtotal * 0.09975;
    final double expressFee = expressDeliverySelected ? 5.0 : 0.0;
    final double total = subtotal + tps + tvq + expressFee;

    return Scaffold(
      appBar: AppBar(title: const Text('Receipt')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/ProductPage');
                      },
                      child: const Text('Go to Products'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/CartPage');
                      },
                      child: const Text('Go to Cart'),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thank you for your purchase!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Receipt',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Divider(thickness: 2),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return ListTile(
                            leading: item.product.icon != null
                                ? CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.blue,
                                    child: Icon(
                                      item.product.icon,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  )
                                : null,
                            title: Text(
                              '${item.quantity} x ${item.product.name}',
                            ),
                            trailing: Text(
                              '\$${item.totalPrice.toStringAsFixed(2)}',
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Divider(thickness: 2),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Paid:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '\$${total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('TPS (5%):'),
                        Text('\$${tps.toStringAsFixed(2)}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('TVQ (9.975%):'),
                        Text('\$${tvq.toStringAsFixed(2)}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Express delivery:'),
                        Text('\$${expressFee.toStringAsFixed(2)}'),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${total.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          cartItems.clear();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/ProductPage',
                            (route) => false,
                          );
                        },
                        child: const Text('Finish'),
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
