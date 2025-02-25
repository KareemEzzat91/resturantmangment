import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturantmangment/helpers/cubit_helper/api_cubit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../models/menu_model/menu_model.dart';

class MenuScreen extends StatefulWidget {
  final int branchId;
  const MenuScreen({super.key, required this.branchId});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with SingleTickerProviderStateMixin {
  bool showAvailableOnly = false;
  int? selectedCategory;
  String searchKeyword = '';
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<String> categories = ['All', 'Appetizers', 'Main Course', 'Desserts', 'Beverages'];
  final Color primaryColor = const Color(0xff32B768);
  final Color secondaryColor = const Color(0xffE6F7EC);
  final Color darkTextColor = const Color(0xff1F2937);
  final Color lightTextColor = const Color(0xff6B7280);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<List<MenuModel>?> fetchMenu() async {
    if (searchKeyword.isNotEmpty) {
      return context.read<ApiCubit>().searchMenu(widget.branchId, searchKeyword);
    } else if (selectedCategory != null) {
      return context.read<ApiCubit>().filterMenuByCategory(widget.branchId, selectedCategory!);
    } else if (showAvailableOnly) {
      return context.read<ApiCubit>().getAvailableMenu(widget.branchId);
    } else {
      return context.read<ApiCubit>().getMenu(widget.branchId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 120,
              floating: true,
              pinned: true,
              backgroundColor: primaryColor,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "Our Menu",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    image: DecorationImage(
                      image: const NetworkImage("https://images.unsplash.com/photo-1414235077428-338989a2e8c0?ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80"),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        primaryColor.withOpacity(0.7),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    showAvailableOnly ? Icons.check_circle : Icons.check_circle_outline,
                    color: Colors.white,
                  ),
                  tooltip: 'Show available items only',
                  onPressed: () {
                    setState(() {
                      showAvailableOnly = !showAvailableOnly;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.tune, color: Colors.white),
                  tooltip: 'More filters',
                  onPressed: () {
                    _showFilterBottomSheet(context);
                  },
                ),
              ],
            ),
          ];
        },
        body: Column(
          children: [
            // Search Bar
            FadeInDown(
              duration: const Duration(milliseconds: 400),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search our delicious menu...",
                      hintStyle: GoogleFonts.poppins(
                        color: lightTextColor,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(Icons.search, color: primaryColor),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                        icon: Icon(Icons.clear, color: lightTextColor),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            searchKeyword = '';
                          });
                        },
                      )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchKeyword = value;
                      });
                    },
                  ),
                ),
              ),
            ),

            // Category Tabs
            FadeInDown(
              delay: Duration(milliseconds: 200),
              duration: Duration(milliseconds: 400),
              child: Container(
                margin: EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: primaryColor,
                  unselectedLabelColor: lightTextColor,
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 3, color: primaryColor),
                    insets: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  tabs: categories.map((String category) {
                    return Tab(text: category);
                  }).toList(),
                  onTap: (index) {
                    setState(() {
                      selectedCategory = index == 0 ? null : index;
                    });
                  },
                ),
              ),
            ),

            // Menu Items
            Expanded(
              child: FutureBuilder<List<MenuModel>?>(
                future: fetchMenu(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: primaryColor),
                          SizedBox(height: 16),
                          Text(
                            "Loading delicious items...",
                            style: GoogleFonts.poppins(
                              color: lightTextColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 60, color: Colors.red.shade300),
                          SizedBox(height: 16),
                          Text(
                            "Couldn't load menu items",
                            style: GoogleFonts.poppins(
                              color: Colors.red.shade400,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {});
                            },
                            icon: Icon(Icons.refresh),
                            label: Text("Try Again"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: FadeIn(
                        duration: Duration(milliseconds: 500),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.restaurant_menu,
                              size: 80,
                              color: Colors.grey.shade300,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "No menu items found",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: darkTextColor,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              searchKeyword.isNotEmpty
                                  ? "Try a different search term"
                                  : "Check back later for updates",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: lightTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final item = snapshot.data![index];
                        return FadeInUp(
                          duration: Duration(milliseconds: 350),
                          delay: Duration(milliseconds: 50 * index),
                          child: _buildMenuItemCard(item, index),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to cart or show cart modal
        },
        backgroundColor: primaryColor,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(Icons.shopping_basket, color: Colors.white),
            Positioned(
              right: -5,
              top: -5,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  '0',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItemCard(MenuModel item, int index) {
    bool isEvenItem = index % 2 == 0;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          // Navigate to item details
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Image section
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  Image.network(
                    "https://th.bing.com/th/id/OIP.PBTb6VPZw0t51s5qdLpk2QHaE6?w=800&h=531&rs=1&pid=ImgDetMain",
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, error, stackTrace) => Container(
                      height: 180,
                      color: Colors.grey.shade200,
                      child: Center(
                        child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey.shade400),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isEvenItem ? primaryColor : Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "\$${(item.price ?? 0).toStringAsFixed(2)}",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  if (showAvailableOnly)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Available",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name ?? 'Unnamed Dish',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkTextColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    item.description ?? 'No description available',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: lightTextColor,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          SizedBox(width: 4),
                          Text(
                            "4.${(index % 5) + 5}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: darkTextColor,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "(${100 + (index * 13)})",
                            style: GoogleFonts.poppins(
                              color: lightTextColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Add to cart
                        },
                        icon: Icon(Icons.add_shopping_cart, size: 18),
                        label: Text("Add"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FadeInUp(
        duration: Duration(milliseconds: 300),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.65,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Filter Menu",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: darkTextColor,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Divider(),
              SizedBox(height: 16),
              // Filter options would go here
              Text(
                "Price Range",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: darkTextColor,
                ),
              ),
              SizedBox(height: 16),
              RangeSlider(
                values: RangeValues(10, 50),
                min: 0,
                max: 100,
                divisions: 10,
                activeColor: primaryColor,
                labels: RangeLabels("\$10", "\$50"),
                onChanged: (RangeValues values) {},
              ),
              SizedBox(height: 24),
              Text(
                "Dietary Preferences",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: darkTextColor,
                ),
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildFilterChip("Vegetarian", false),
                  _buildFilterChip("Vegan", false),
                  _buildFilterChip("Gluten-Free", false),
                  _buildFilterChip("Dairy-Free", false),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Reset",
                        style: GoogleFonts.poppins(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Apply Filters",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(
        label,
        style: GoogleFonts.poppins(
          color: isSelected ? Colors.white : darkTextColor,
          fontSize: 13,
        ),
      ),
      selected: isSelected,
      onSelected: (bool selected) {},
      backgroundColor: Colors.grey.shade100,
      selectedColor: primaryColor,
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    );
  }
}