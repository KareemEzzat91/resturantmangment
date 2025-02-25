import 'package:flutter/material.dart';

class LikesScreen extends StatefulWidget {
  const LikesScreen({super.key});

  @override
  _LikesScreenState createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  // Sample liked items (you can replace this with real data)
  List<Map<String, String>> likedItems = [
    {
      "image": "assets/images/Resturan.jpeg",
      "title": "Ambrosia Hotel & Restaurant",
      "location": "Kazi Deiry, Taiger Pass, Chittagong",
      "price": "\$12.99"
    },
    {
      "image": "assets/images/Resturant.jpeg",
      "title": "BLBN",
      "location": "4 Bab El-Sharq",
      "price": "\$7.99"
    },
  ];

  // Function to remove an item from the liked list
  void _removeFromLikes(int index) {
    setState(() {
      likedItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: likedItems.isEmpty
          ? const Center(
        child: Text(
          "No liked items yet!",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      )
          : ListView.builder(
        itemCount: likedItems.length,
        itemBuilder: (context, index) {
          final item = likedItems[index];
          return Card(
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  item["image"]!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(item["title"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(item["location"]!),
              trailing: IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () => _removeFromLikes(index),
              ),
            ),
          );
        },
      ),
    );
  }
}
