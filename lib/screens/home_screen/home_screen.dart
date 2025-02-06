import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> carouselItems = [
    {"image": "assets/images/Chicken.jpg", "title": "Delicious Biryani"},
    {"image": "assets/images/pizza.jpg", "title": "Tasty Pizza"},
    {"image": "assets/images/pasta.jpg", "title": "Creamy Pasta"},
    {"image": "assets/images/Burger.jpg", "title": "Juicy Burger"},
    {"image": "assets/images/salad.jpg", "title": "Healthy Salad"},
  ];
TextEditingController textController =TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    var currentIndex=0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
      ),
      drawer: buildMenu(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildSearchBar(width),
            buildCarouselSlider(width, height),
            const SizedBox(height: 20),
            Text(
              "Explore Our Specials",
              style: GoogleFonts.inter(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white, // خلفية البار
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
            onTap: (i) => setState(() => currentIndex = i),
            itemPadding: EdgeInsets.symmetric(horizontal: 33, vertical: 14), // تقليل المسافات
            selectedItemColor: Colors.deepPurple,
            unselectedItemColor: Colors.grey[400],

            items: [
              /// Home
              SalomonBottomBarItem(
                icon: Icon(Icons.home_rounded,),
                title: const Text(
                  "Home",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                selectedColor: Colors.deepPurple,
              ),

              /// Likes
              SalomonBottomBarItem(
                icon: Icon(Icons.favorite_rounded),
                title: Text(
                  "Likes",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                selectedColor: Colors.pink,
              ),

              /// Profile
              SalomonBottomBarItem(
                icon: Icon(Icons.person_rounded),
                title: Text(
                  "Profile",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                selectedColor: Colors.teal,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildSearchBar(double width) {
    /*
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: AnimSearchBar(
              onSubmitted: (tt){},
              width: width,
              textController: textController,
              onSuffixTap: () {
                setState(() {
                  textController.clear();
                });}),
            ),
*/

    return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              height: 38,
            width: width/1.33,
            decoration:  BoxDecoration(
              borderRadius:BorderRadius.circular(10) ,
              color: const Color(0xffE6E7E9)

            ),
              child:Row(
                children: [
                  const SizedBox(width: 20,),
                  const Icon(Icons.search_outlined,color: Color(0xff9CA3AF),),
                  const SizedBox(width: 5,),

                  Text("Search",style: GoogleFonts.inter(color: const Color(0xff9CA3AF)),),
                ],
              ),
            ),
          );
  }

  /// 🔥 **Improved Carousel Slider**
  CarouselSlider buildCarouselSlider(double width, double height) {
    return CarouselSlider(
      items: carouselItems.map((item) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(15), // Rounded corners
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                item["image"]!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, size: 50),
              ),
              Positioned(
                bottom: 20,
                left: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    item["title"]!,
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: height / 5,
        aspectRatio: 16 / 9,
        viewportFraction: 0.85,
        initialPage: 0,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.3,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  /// 🔥 **Enhanced Drawer with Custom Styling**
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
          _buildDrawerItem(Icons.notifications, "Notifications", Colors.blueGrey, () {}),
          _buildDrawerItem(Icons.receipt_long, "Orders", Colors.orangeAccent, () {}),
          _buildDrawerItem(Icons.settings, "Settings", Colors.teal, () {}),
          const Divider(thickness: 1, indent: 16, endIndent: 16),
          _buildDrawerItem(Icons.logout, "Logout", Colors.redAccent, () {
            // Handle Logout
          }),
          const Spacer(), // Push items to top, keeping logout at bottom
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

  /// 🔥 **Reusable Drawer Item**
  Widget _buildDrawerItem(IconData icon, String title, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      onTap: onTap,
    );
  }
}
