import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resturantmangment/helpers/cubit_helper/api_cubit.dart';
import 'package:shimmer/shimmer.dart';
import 'package:animate_do/animate_do.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/resturant_model/resturant_model.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        centerTitle: true,
        backgroundColor: const Color(0xff32B768),
        elevation: 0,
      ),
      body: FutureBuilder<Resturant>(
        future: context.read<ApiCubit>().getResturant(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerLoading();
          } else if (snapshot.hasError) {
            return _buildErrorState(context);
          } else if (!snapshot.hasData) {
            return _buildEmptyState();
          }

          final restaurant = snapshot.data!;
          return _buildRestaurantInfo(restaurant);
        },
      ),
    );
  }

  /// 🔹 Shimmer Loading Effect
  Widget _buildShimmerLoading() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 20,
              width: 150,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 16,
              width: 250,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Error State UI
  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Failed to load restaurant info", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => context.read<ApiCubit>().getResturant(),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  /// 🔹 Empty State UI
  Widget _buildEmptyState() {
    return const Center(
      child: Text("No restaurant information available", style: TextStyle(fontSize: 18)),
    );
  }

  /// 🔹 Restaurant Information UI
  Widget _buildRestaurantInfo(Resturant restaurant) {
    return SingleChildScrollView(
      child: Column(
        children: [
          /// Restaurant Image with Animation
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: Hero(
              tag: "restaurantImage",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  restaurant.imageUrl ?? "https://via.placeholder.com/300",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          /// Name & Rating
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  restaurant.name ?? "Unknown Restaurant",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 24),
                    const SizedBox(width: 4),
                    Text(
                      restaurant.rating?.toStringAsFixed(1) ?? "N/A",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// Contact Details
          _buildContactSection(restaurant),

          /// User Reviews
          _buildReviewsSection(),

          /// Opening Hours & Location
          _buildMapSection(restaurant),
        ],
      ),
    );
  }

  /// 🔹 Contact Details
  Widget _buildContactSection(Resturant restaurant) {
    return FadeInLeft(
      duration: const Duration(milliseconds: 600),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildContactRow(Icons.phone, "+20224247" , "tel:01042256225}"),
              _buildContactRow(Icons.location_on, "33 st Elsalam 20 New Giza ", "https://maps.app.goo.gl/QifXtTLh3ADgqD1s8"),
              _buildSocialMediaRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text, String url) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(text, style: const TextStyle(fontSize: 16)),
      onTap: () => launchUrl(Uri.parse(url)),
    );
  }

  Widget _buildSocialMediaRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(icon: const FaIcon(FontAwesomeIcons.facebook), onPressed: () => launchUrl(Uri.parse("https://facebook.com"))),
        IconButton(icon: const FaIcon(FontAwesomeIcons.instagram), onPressed: () => launchUrl(Uri.parse("https://instagram.com"))),
        IconButton(icon: const FaIcon(FontAwesomeIcons.twitter), onPressed: () => launchUrl(Uri.parse("https://twitter.com"))),
      ],
    );
  }

  /// 🔹 User Reviews
  Widget _buildReviewsSection() {
    return FadeInRight(
      duration: const Duration(milliseconds: 600),
      child: SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.person, size: 40),
                    Text("User ${index+1}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Text("⭐️⭐️⭐️⭐️⭐️"),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// 🔹 Opening Hours & Google Maps
  Widget _buildMapSection(Resturant restaurant) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: SizedBox(
        height: 200,
        child: GoogleMap(

          initialCameraPosition: const CameraPosition(
            target: LatLng(30.059274, 31.222353),
            zoom: 14,
          ),
          markers: {
            const Marker(
              markerId: MarkerId("restaurant"),
              position: LatLng(30.059274,  31.222353),
            ),
          },
        ),
      ),
    );
  }
}
