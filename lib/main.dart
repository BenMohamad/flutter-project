import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee List',
      theme: ThemeData.light(),
      home: ItemListPage(),
    );
  }
}

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  _ItemListPageState createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  final List<Map<String, String>> items = [
    {"title": "Mohamed Ali", "subtitle": "Department 1", "details": "Senior Flutter Developer ,With 3 years experince.", "image": "https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80"},
    {"title": "Omar Ahmed", "subtitle": "Department 2", "details": "DevOps Leader with 10+ years experince .", "image": "https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80"},
    {"title": "Ibrahim Mohamed", "subtitle": "Department 3", "details": "Project Alpha Lead Team.", "image": "https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80"},
  ];

  final Set<int> favoriteIndexes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.red),
            tooltip: 'Favorite Employees',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteEmployeesPage(
                    favoriteItems: favoriteIndexes.map((i) => items[i]).toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final isFavorite = favoriteIndexes.contains(index);
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemDetailPage(item: items[index]),
                ),
              );
            },
            child: Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            items[index]['title']!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            items[index]['subtitle']!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                      tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
                      onPressed: () {
                        setState(() {
                          if (isFavorite) {
                            favoriteIndexes.remove(index);
                          } else {
                            favoriteIndexes.add(index);
                          }
                        });
                      },
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FavoriteEmployeesPage extends StatelessWidget {
  final List<Map<String, String>> favoriteItems;
  const FavoriteEmployeesPage({super.key, required this.favoriteItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorite Employees')),
      body: favoriteItems.isEmpty
          ? Center(child: Text('No favorite employees yet.'))
          : ListView.builder(
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                final item = favoriteItems[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: item['image'] != null
                        ? CircleAvatar(backgroundImage: NetworkImage(item['image']!))
                        : null,
                    title: Text(item['title'] ?? ''),
                    subtitle: Text(item['subtitle'] ?? ''),
                  ),
                );
              },
            ),
    );
  }
}

class ItemDetailPage extends StatelessWidget {
  final Map<String, String> item;

  // Constructor to receive the item data
  const ItemDetailPage({super.key, required this.item});

  void _downloadImage(BuildContext context, String url) async {
    // Show a SnackBar as a placeholder for download logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Download started for image!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item['title']!)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item['image'] != null)
              Center(
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            child: InteractiveViewer(
                              child: Image.network(
                                item['image']!,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          item['image']!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.download, color: Colors.blue),
                      tooltip: 'Download Image',
                      onPressed: () => _downloadImage(context, item['image']!),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 16),
            Text(
              item['title']!,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              item['subtitle']!,
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),
            Text(
              item['details']!,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
