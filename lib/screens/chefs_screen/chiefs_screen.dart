import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturantmangment/helpers/cubit_helper/api_cubit.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/chefs_model/chefs_model.dart';

class ChefsScreen extends StatelessWidget {
  const ChefsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Our Chefs",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff32B768),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),

      body: FutureBuilder<List<Chef>?>(
        future: context.read<ApiCubit>().getChefs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerLoading();
          } else if (snapshot.hasError) {
            return _buildErrorState(context);
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          final chefs = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              itemCount: chefs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two columns
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final chef = chefs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChefDetailsScreen(chef: chef),
                      ),
                    );
                  },
                  child: ChefCard(chef: chef),
                );
              },
            ),
          );
        },
      ),
    );
  }

  /// 🔹 Shimmer Loading Effect
  Widget _buildShimmerLoading() {
    return GridView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: 6, // Show shimmer for 6 items
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }

  /// 🔹 Error State UI
  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Failed to load chefs", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => context.read<ApiCubit>().getChefs(),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  /// 🔹 Empty State UI
  Widget _buildEmptyState() {
    return const Center(
      child: Text("No chefs found", style: TextStyle(fontSize: 18)),
    );
  }
}

/// 🔹 Improved Chef Card
class ChefCard extends StatelessWidget {
  final Chef chef;
  const ChefCard({super.key, required this.chef});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: CachedNetworkImage(
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
              imageUrl:chef.imageUrl??"https://th.bing.com/th/id/OIP.EeYVQmrl6Ab_uKyWLFHgYgHaEK?rs=1&pid=ImgDetMain" ,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  SizedBox(
                width: 200.0,
                height: 100.0,
                child: Shimmer.fromColors(
                  baseColor: Colors.black12,
                  highlightColor: Colors.yellow,
                  child: const Text(
                    'Loading',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),             ),
          ),
          const SizedBox(height: 8),
          Text(
            chef.name ?? "Unknown",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              chef.description ?? "No description available",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// 🔹 Chef Details Screen
class ChefDetailsScreen extends StatelessWidget {
  final Chef chef;
  const ChefDetailsScreen({super.key, required this.chef});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chef.name ?? "Chef Details"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: chef.imageUrl ?? "",
              child: Image.network(
                chef.imageUrl ?? "https://via.placeholder.com/300",
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              chef.name ?? "Unknown",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Job Title: ${chef.jobTitle ?? "Not specified"}",
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                chef.description ?? "No description available.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
