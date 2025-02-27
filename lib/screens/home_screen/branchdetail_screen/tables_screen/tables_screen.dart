import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:resturantmangment/helpers/cubit_helper/api_cubit.dart';
import 'package:resturantmangment/models/Reservation_model/Reservation_model.dart';
import '../../../../models/table_model/tables_model.dart';
import '../../../main_screen/main_screen.dart';

class TablesScreenController {
  final BuildContext context;
  final int branchId;
  final String? selectedDateString;
  final String? selectedMealString;
  final bool isBooking;
  final int? mealSchedulesId;
  final int? selectedMealNum;

  // State variables
  final ValueNotifier<DateTime> selectedDate = ValueNotifier<DateTime>(DateTime.now());
  final ValueNotifier<String> selectedMeal = ValueNotifier<String>("Lunch");
  final ValueNotifier<String> filter = ValueNotifier<String>('all');
  final ValueNotifier<Future<List<TablesModel>?>> tablesFuture = ValueNotifier<Future<List<TablesModel>?>>(Future.value([]));

  final TextEditingController specialRequestsController = TextEditingController();
  final List<String> mealTimes = ["Breakfast", "Lunch", "Dinner"];

  TablesScreenController({
    required this.context,
    required this.branchId,
    required this.isBooking,
    this.selectedDateString,
    this.selectedMealString,
    this.mealSchedulesId,
    this.selectedMealNum,
  }) {
    // Initialize values
    if (selectedDateString != null) {
      selectedDate.value = _parseDate(selectedDateString!);
    }

    if (selectedMealString != null) {
      selectedMeal.value = selectedMealString!;
    }

    // Setup listeners
    selectedDate.addListener(_refreshTables);
    selectedMeal.addListener(_refreshTables);
    filter.addListener(_refreshTables);

    // Initial fetch
    _refreshTables();
  }

  DateTime _parseDate(String dateString) {
    try {
      return DateFormat('yyyy-MM-dd').parse(dateString);
    } catch (e) {
      debugPrint('Error parsing date: $e');
      return DateTime.now();
    }
  }

  void _refreshTables() {
    tablesFuture.value = _fetchTables();
  }

  Future<List<TablesModel>?> _fetchTables() async {
    final bloc = context.read<ApiCubit>();
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate.value);

    switch (filter.value) {
      case 'available':
        return bloc.getAvailableTables(branchId, formattedDate, selectedMeal.value);
      case 'reserved':
        return bloc.getReservedTables(branchId, formattedDate, selectedMeal.value);
      default:
        return bloc.getAllTables(branchId);
    }
  }

  void updateFilter(String newFilter) {
    filter.value = newFilter;
  }

  void updateSelectedMeal(String newMeal) {
    selectedMeal.value = newMeal;
  }

  void updateSelectedDate(DateTime newDate) {
    selectedDate.value = newDate;
  }

  void dispose() {
    selectedDate.dispose();
    selectedMeal.dispose();
    filter.dispose();
    tablesFuture.dispose();
    specialRequestsController.dispose();
  }

  Future<void> completeBooking(String tableNumber, int tableId) async {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      title: "Complete Your Booking",
      text: 'Your Table is $tableNumber',
      confirmBtnText: 'Confirm',
      cancelBtnText: 'Cancel',
      confirmBtnColor: const Color(0xff32B768),
      onConfirmBtnTap: () async {
        try {
          String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate.value);
          final Reservation reservation = await context.read<ApiCubit>().createReservation(
            date: formattedDate,
            specialRequests: specialRequestsController.text,
            mealType: selectedMealNum ?? 0,
            branchId: branchId,
            tableId: tableId,
            branchScheduleId: mealSchedulesId ?? 0,
          );

          // Close dialog and navigate
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MainScreen()),
                  (Route<dynamic> route) => false
          );

          _showBookingConfirmation(reservation);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to complete booking: $e')),
          );
        }
      },
      onCancelBtnTap: () {
        Navigator.of(context).pop();
      },
      widget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: specialRequestsController,
            decoration: const InputDecoration(labelText: 'Special Requests'),
          ),
          const SizedBox(height: 16),
          Text('Selected Date: ${selectedDate.value.year}-${selectedDate.value.month}-${selectedDate.value.day}'),
          const SizedBox(height: 16),
          Text('Selected Meal: ${selectedMeal.value}'),
        ],
      ),
    );
  }

  void _showBookingConfirmation(Reservation reservation) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Booking Confirmed!',
      text: '''
      Go To Payment Screen To Request Your Payment By Code 
      And then Process it to pay and complete 
    📅 Date: ${reservation.dayOfReservation ?? 'N/A'}
    ⏰ Time: ${reservation.startTime ?? 'N/A'} - ${reservation.finishTime ?? 'N/A'}
    🍽 Meal Type: ${(reservation.mealType==0?"Breakfast":reservation.mealType==1?"Lunch":"Dinner")}
    Payment Code : ${reservation.paymentCode}
    💬 Special Requests: ${reservation.specialRequests?.isNotEmpty == true ? reservation.specialRequests : 'None'}
    ''',
      confirmBtnText: 'OK',
    );
  }
}

class TablesScreen extends StatefulWidget {
  final int branchId;
  final String? selectedDate;
  final String? selectedMeal;
  final bool isBooking;
  final int? mealSchedulesId;
  final int? selectedMealNum;

  const TablesScreen({
    super.key,
    required this.branchId,
    required this.isBooking,
    this.selectedDate,
    this.selectedMeal,
    this.mealSchedulesId,
    this.selectedMealNum
  });

  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  late TablesScreenController _controller;
  final Color _primaryColor = const Color(0xff32B768);
  final Color _secondaryColor = const Color(0xff256B4F);

  @override
  void initState() {
    super.initState();
    _controller = TablesScreenController(
      context: context,
      branchId: widget.branchId,
      isBooking: widget.isBooking,
      selectedDateString: widget.selectedDate,
      selectedMealString: widget.selectedMeal,
      mealSchedulesId: widget.mealSchedulesId,
      selectedMealNum: widget.selectedMealNum,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _controller.selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: _primaryColor,
              onPrimary: Colors.white,
              surface: Colors.grey.shade900,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _controller.updateSelectedDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: FadeIn(
        duration: const Duration(milliseconds: 800),
        child: Text(
          widget.isBooking ? "Choose Your Table" : "Tables Management",
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
          tooltip: 'Select Date',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody() {
    return Container(
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
          _buildDateAndMealSelection(),
          const SizedBox(height: 16),
          _buildFilterButtons(),
          const SizedBox(height: 16),
          _buildTablesGrid(),
        ],
      ),
    );
  }

  Widget _buildDateAndMealSelection() {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _controller.selectedDate,
      builder: (context, selectedDate, _) {
        return ValueListenableBuilder<String>(
          valueListenable: _controller.selectedMeal,
          builder: (context, selectedMeal, _) {
            return FadeInDown(
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
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.white, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('dd/MM/yyyy').format(selectedDate),
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    DropdownButton<String>(
                      value: selectedMeal,
                      dropdownColor: _secondaryColor,
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                      underline: Container(),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          _controller.updateSelectedMeal(newValue);
                        }
                      },
                      items: _controller.mealTimes
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterButtons() {
    return ValueListenableBuilder<String>(
      valueListenable: _controller.filter,
      builder: (context, filter, _) {
        return FadeInDown(
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
                  onPressed: () => _controller.updateFilter('all'),
                  icon: Icons.table_restaurant,
                ),
                FilterButton(
                  label: "Available",
                  isSelected: filter == 'available',
                  onPressed: () => _controller.updateFilter('available'),
                  icon: Icons.check_circle_outline,
                ),
                FilterButton(
                  label: "Reserved",
                  isSelected: filter == 'reserved',
                  onPressed: () => _controller.updateFilter('reserved'),
                  icon: Icons.event_busy,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTablesGrid() {
    return ValueListenableBuilder<Future<List<TablesModel>?>>(
      valueListenable: _controller.tablesFuture,
      builder: (context, tablesFuture, _) {
        return Expanded(
          child: FutureBuilder<List<TablesModel>?>(
            future: tablesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xff32B768),
                  ),
                );
              } else if (snapshot.hasError) {
                return _buildErrorWidget("Failed to load tables");
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildEmptyWidget("No tables found");
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
                  final table = snapshot.data![index];
                  return FadeInUp(
                    delay: Duration(milliseconds: 100 * index),
                    duration: const Duration(milliseconds: 500),
                    child: GestureDetector(
                      onTap: widget.isBooking
                          ? () => _controller.completeBooking(
                          table.tableNumber ?? "N/A", table.id ?? 0)
                          : null,
                      child: TableCard(
                        isBooking: widget.isBooking,
                        table: table,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 48),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _controller._refreshTables();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text(
              "Retry",
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.table_bar, color: Colors.white54, size: 48),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.poppins(color: Colors.white),
          ),
        ],
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
  final bool isBooking;

  const TableCard({
    super.key,
    required this.table,
    required this.isBooking
  });

  @override
  Widget build(BuildContext context) {
    // Properly check if the table is reserved
    bool isReserved = false;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isReserved
                ? Colors.redAccent.withOpacity(0.3)
                : const Color(0xff32B768).withOpacity(0.3),
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
              _getTableImage(table.capacity ?? 4),
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
              child: Row(
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
                        "${table.capacity ?? 0}",
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
            ),
          ),

          // Booking Indicator (Only shows for booking mode and available tables)
          if (isBooking && !isReserved)
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xff32B768),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.touch_app,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getTableImage(int capacity) {
    switch (capacity) {
      case 2:
        return "assets/images/table 1v1.png";
      case 4:
        return "assets/images/table_reserved4.png";
      default:
        return "assets/images/table_reserved.png";
    }
  }
}