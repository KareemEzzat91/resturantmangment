import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:resturantmangment/helpers/cubit_helper/api_cubit.dart';

import '../../../../models/table_model/tables_model.dart';

class TablesScreen extends StatefulWidget {
  final int branchId;
  const TablesScreen({super.key, required this.branchId});

  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  late Future<List<TablesModel>?> _tablesFuture;
  String filter = 'all';
  DateTime selectedDate = DateTime.now();
  String selectedMeal = "Lunch";

  List<String> mealTimes = ["Breakfast", "Lunch", "Dinner"];

  @override
  void initState() {
    super.initState();
    _tablesFuture = fetchTables();
  }

  Future<List<TablesModel>?> fetchTables() async {
    final bloc = context.read<ApiCubit>();
    String formattedDate = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

    if (filter == 'available') {
      return await bloc.getAvailableTables(widget.branchId, formattedDate, selectedMeal);
    } else if (filter == 'reserved') {
      return await bloc.getReservedTables(widget.branchId, formattedDate, selectedMeal);
    } else {
      return await bloc.getAllTables(widget.branchId);
    }
  }

  void updateFilter(String newFilter) {
    setState(() {
      filter = newFilter;
      _tablesFuture = fetchTables();
    });
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _tablesFuture = fetchTables();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: FadeIn(
          duration: const Duration(milliseconds: 800),
          child: Text(
            "Tables Management",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month, color: Colors.white),
            onPressed: () => _selectDate(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Color.fromRGBO(0, 0, 0, 0.6),
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 100), // Space for app bar

            // Date and Meal Selection
            FadeInDown(
              duration: const Duration(milliseconds: 600),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    DropdownButton<String>(
                      value: selectedMeal,
                      dropdownColor: const Color(0xff256B4F),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                      underline: Container(),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedMeal = newValue;
                            _tablesFuture = fetchTables();
                          });
                        }
                      },
                      items: mealTimes.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Filter Buttons
            FadeInDown(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(milliseconds: 600),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FilterButton(
                      label: "All Tables",
                      isSelected: filter == 'all',
                      onPressed: () => updateFilter('all'),
                      icon: Icons.table_restaurant,
                    ),
                    FilterButton(
                      label: "Available",
                      isSelected: filter == 'available',
                      onPressed: () => updateFilter('available'),
                      icon: Icons.check_circle_outline,
                    ),
                    FilterButton(
                      label: "Reserved",
                      isSelected: filter == 'reserved',
                      onPressed: () => updateFilter('reserved'),
                      icon: Icons.event_busy,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Tables Grid
            Expanded(
              child: FutureBuilder<List<TablesModel>?>(
                future: _tablesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xff32B768),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline, color: Colors.white, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            "Failed to load tables",
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.table_bar, color: Colors.white54, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            "No tables found",
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return FadeInUp(
                        delay: Duration(milliseconds: 100 * index),
                        duration: const Duration(milliseconds: 500),
                        child: TableCard(table: snapshot.data![index]),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;
  final IconData icon;

  const FilterButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xff256B4F) : Colors.white.withOpacity(0.1),
        foregroundColor: Colors.white,
        elevation: isSelected ? 8 : 0,
        shadowColor: isSelected ? const Color(0xff256B4F).withOpacity(0.4) : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class TableCard extends StatelessWidget {
  final TablesModel table;
  const TableCard({Key? key, required this.table}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Note: This value should come from your model or API
    // For now I'll assume it's false as the isReserved check wasn't working correctly
    bool isReserved =false;

    return GestureDetector(
      onTap: () {
        // Show table details or edit dialog
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isReserved
                  ? Colors.redAccent.withOpacity(0.3)
                  : Colors.greenAccent.withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
          border: Border.all(
            color: isReserved ? Colors.redAccent : const Color(0xff32B768),
            width: 2,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Status Indicator
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isReserved ? Colors.redAccent : const Color(0xff32B768),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isReserved ? FontAwesomeIcons.xmark : FontAwesomeIcons.check,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isReserved ? "Reserved" : "Available",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Table Image
            Padding(
              padding: const EdgeInsets.all(16),
              child: Image.asset(
                table.capacity == 4
                    ? "assets/images/table_reserved4.png"
                    : table.capacity == 2
                    ? "assets/images/table 1v1.png"
                    : "assets/images/table_reserved.png",
                fit: BoxFit.contain,
              ),
            ),

            // Table Details
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Table ",
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              table.tableNumber ?? "N/A",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.people,
                              color: Colors.white70,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${table.capacity}",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}