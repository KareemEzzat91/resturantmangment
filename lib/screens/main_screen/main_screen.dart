import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resturantmangment/screens/Registration/login_screen/login_screen.dart';
import 'package:resturantmangment/screens/reservation_screen/reservation_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../about_screen/about_screen.dart';
import '../chefs_screen/chiefs_screen.dart';
 import '../home_screen/home_screen.dart';
import '../likes_screen/likes_screen.dart';
import '../notifications_screen/notifications_screen.dart';
import '../profile_screen/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0; // Keep track of selected tab
  final List<Widget> screens = [
    const HomeScreen(),
    const LikesScreen(),
    const ProfileScreen(), // Change this to a ProfileScreen later
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      drawer: buildMenu(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: screens[currentIndex], // Animated transition
      ),
      bottomNavigationBar: buildNavigationBar(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0, // Remove shadow
      title: Text(
        'Welcome To Our Restaurant',
        style: GoogleFonts.inter(
            fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xff4B5563)),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: CircleAvatar(
            radius: 22,
            backgroundImage: const AssetImage("assets/images/MyPic.jpg"),
            backgroundColor: Colors.grey.shade200,
          ),
        ),
      ],
    );
  }

  Container buildNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: SalomonBottomBar(
          currentIndex: currentIndex,
          onTap: (i) => setState(() {
            currentIndex = i;
          }),
          itemPadding: const EdgeInsets.symmetric(horizontal: 33, vertical: 14),
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey[400],
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.home_rounded),
              title: const Text(
                "Home",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              selectedColor: Colors.teal,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.favorite_rounded),
              title: const Text(
                "Likes",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              selectedColor: Colors.pink,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.person_rounded),
              title: const Text(
                "Profile",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              selectedColor: Colors.deepPurple,
            ),

          ],
        ),
      ),
    );
  }

  Drawer buildMenu() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              'Kareem Ezzat',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              'kareem@example.com',
              style: GoogleFonts.inter(fontSize: 14, color: Colors.white70),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage("assets/images/MyPic.jpg"),
            ),
            decoration: const BoxDecoration(
              color: Color(0xff32B768), // Stylish green
            ),
          ),
          _buildDrawerItem(Icons.receipt_long, "Reservations", Colors.teal, () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const ReservationScreen()));

          }),

          _buildDrawerItem(Icons.payment, "Payments", Colors.blue, () {}),
          _buildDrawerItem(null, "Chefs", Colors.blueGrey, () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const ChefsScreen()));
          },image: "assets/images/chef.png"),
          _buildDrawerItem(Icons.notifications, "Notifications", Colors.orangeAccent, () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const NotificationsScreen()));
          }),

          _buildDrawerItem(Icons.info, "About", Colors.blueGrey, () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const AboutScreen()));
          }),
           const Divider(thickness: 1, indent: 16, endIndent: 16),
          _buildDrawerItem(Icons.logout, "Logout", Colors.redAccent, () {
             Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const LoginScreen()), (Route<dynamic> route) => false);
          }),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Version 1.0.0",
              style: GoogleFonts.inter(fontSize: 14, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData? icon , String title, Color color, VoidCallback onTap,{String  ?image}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: icon !=null ?  Icon(icon, color: color):Image.asset(image!,color: Colors.white,width: 25,height: 25,),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      onTap: onTap,
    );
  }
}
