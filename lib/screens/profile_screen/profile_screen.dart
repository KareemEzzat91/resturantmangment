import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String firstName = "Kareem";
  String lastName = "Ezzat";
  String email = "kareemezzat@gmail.com";
  String phoneNumber = "";
  int role =0;
  String userRole= "none";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        firstName = prefs.getString("firstName") ?? firstName;
        lastName = prefs.getString("lastName") ?? lastName;
        email = prefs.getString("email") ?? email;
        phoneNumber = prefs.getString("phoneNumber") ?? phoneNumber;
        role = prefs.getInt("role") ?? 0;
        _isLoading = false;
        userRole = getRole(role);

      });
    } catch (e) {
      debugPrint("Error loading user info: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }
  String getRole (int role){
    switch (role){
      case 0 : return " Customer ";
      case 1 : return "Branch Admin ";
      case 2 : return "Restaurant Admin";
      default :return "You Haven't Logged Yet ";
    }


  }

  void _handleLogout() async {
    // Show confirmation dialog
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("CANCEL"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("LOGOUT"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Handle actual logout logic here
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      if (!mounted) return;
      // Navigate to login screen or handle accordingly
      // Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture
             CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(role==1 ?"assets/images/MyPic.jpg":role==2?"assets/images/noffal.jpg":"assets/images/Coustmer.jpg"),
              backgroundColor: Colors.grey,
            ),
            const SizedBox(height: 16),

            // User Name
            Text(
              "$firstName $lastName",
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Email
            Text(
              email,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),

            // Email
            Text(
              userRole,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),

            // Phone number if available
            if (phoneNumber.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                phoneNumber,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Profile Settings
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildProfileOption(
                      Icons.edit,
                      "Edit Profile",
                          () {
                        // Navigate to edit profile screen
                      }
                  ),
                  const Divider(height: 1),
                  _buildProfileOption(
                      Icons.notifications,
                      "Notifications",
                          () {
                        // Navigate to notifications settings
                      }
                  ),
                  const Divider(height: 1),
                  _buildProfileOption(
                      Icons.lock,
                      "Privacy & Security",
                          () {
                        // Navigate to privacy settings
                      }
                  ),
                  const Divider(height: 1),
                  _buildProfileOption(
                      Icons.help,
                      "Help & Support",
                          () {
                        // Navigate to help/support
                      }
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: Text(
                  "Logout",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _handleLogout,
              ),
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
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}