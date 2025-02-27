import 'package:flutter/material.dart';

class LikesScreen extends StatefulWidget {
  const LikesScreen({super.key});

  @override
  _LikesScreenState createState() => _LikesScreenState();
}

class _LikesScreenState extends State<LikesScreen> {
  // Sample liked items (you can replace this with real data)
  List<Map<String, dynamic>> likedItems = [
    {
      "image": "assets/images/Resturan.jpeg",
      "title": "Ambrosia Hotel & Restaurant",
      "location": "Kazi Deiry, Taiger Pass, Chittagong",
      "price": "\$12.99",
      "rating": 4.5
    },
    {
      "image": "assets/images/Resturant.jpeg",
      "title": "BLBN Restaurant",
      "location": "4 Bab El-Sharq",
      "price": "\$7.99",
      "rating": 4.2
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
       backgroundColor: Colors.grey[100],
      body: likedItems.isEmpty
          ? _buildEmptyState()
          : _buildLikedItemsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 100,
            color: Colors.grey[300],
          ),
          SizedBox(height: 20),
          const Text(
            "No favorite restaurants yet!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Explore and add your favorite restaurants",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLikedItemsList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10),
      itemCount: likedItems.length,
      itemBuilder: (context, index) {
        final item = likedItems[index];
        return _buildLikedItemCard(item, index);
      },
    );
  }

  Widget _buildLikedItemCard(Map<String, dynamic> item, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        leading: Hero(
          tag: 'restaurant_image_$index',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              item["image"],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          item["title"],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(
              item["location"],
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                SizedBox(width: 5),
                Text(
                  "${item["rating"]} | ${item["price"]}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.favorite, color: Colors.red),
          onPressed: () => _removeFromLikes(index),
        ),
      ),
    );
  }
}