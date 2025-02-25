import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 50,
              backgroundImage: const AssetImage("assets/images/MyPic.jpg"),
              backgroundColor: Colors.grey.shade200,
            ),
            const SizedBox(height: 10),

            // User Name
            Text(
              "Kareem Ezzat",
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Email
            Text(
              "kareem@example.com",
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),

            // Profile Settings
            _buildProfileOption(Icons.edit, "Edit Profile", () {}),
            _buildProfileOption(Icons.notifications, "Notifications", () {}),
            _buildProfileOption(Icons.lock, "Privacy & Security", () {}),
            _buildProfileOption(Icons.help, "Help & Support", () {}),

            const Divider(thickness: 1, height: 30),

            // Logout Button
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: Text(
                "Logout",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent,
                ),
              ),
              onTap: () {
                // Handle Logout
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(
        title,
        style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
