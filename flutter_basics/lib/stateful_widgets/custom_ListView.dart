import 'package:flutter/material.dart';

class CustomListViewDemo extends StatefulWidget {
  const CustomListViewDemo({super.key});

  @override
  State<CustomListViewDemo> createState() => _CustomListViewDemoState();
}

class _CustomListViewDemoState extends State<CustomListViewDemo> {
  final List<String> items = List.generate(15, (i) => 'Item ${i + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Professional Custom ListView'),
        backgroundColor: const Color(0xFF4200AC),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF181818),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'Total Items:',
                  style: TextStyle(
                    color: Color(0xFFC0C0C0),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(
                    '${items.length}',
                    style: const TextStyle(
                      color: Color(0xFFC0C0C0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: const Color(0xFF4200AC),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: items.isEmpty
                  ? const Center(
                      child: Text(
                        'No items to display.',
                        style: TextStyle(
                          color: Color(0xFFA0A0A0),
                          fontSize: 18,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (context, index) => const Divider(
                        color: Color(0xFF232323),
                        thickness: 1,
                        height: 8,
                      ),
                      itemBuilder: (context, index) => Card(
                        color: const Color(0xFF232323),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF4200AC),
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Color(0xFFC0C0C0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            items[index],
                            style: const TextStyle(
                              color: Color(0xFFC1C1C1),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              setState(() {
                                items.removeAt(index);
                              });
                            },
                          ),
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
