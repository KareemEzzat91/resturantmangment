import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturantmangment/models/meal_schedules/meal_schedulesmodel.dart';
import '../../../../helpers/cubit_helper/api_cubit.dart';

class ScheduleScreen extends StatefulWidget {
  final int branchId;

  const ScheduleScreen({super.key, required this.branchId});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late Future<List<BranchSchedule>?> _scheduleFuture;
  int _selectedDayIndex = DateTime.now().weekday % 7; // Today's index, using Saturday as 0

  final List<String> weekDays = [
    "Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"
  ];

  // Color scheme
  final Color primaryColor = const Color(0xff32B768);
  final Color secondaryColor = const Color(0xffE6F7EC);
  final Color accentColor = const Color(0xff065F46);

  @override
  void initState() {
    super.initState();
    _scheduleFuture = _fetchSchedule();
  }

  Future<List<BranchSchedule>?> _fetchSchedule() async {
    return await context.read<ApiCubit>().getSchedule(widget.branchId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weekly Meal Schedule",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: FutureBuilder<List<BranchSchedule>?>(
        future: _scheduleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: primaryColor),
                  const SizedBox(height: 16),
                  Text(
                    "Loading schedule...",
                    style: TextStyle(color: accentColor, fontSize: 16),
                  )
                ],
              ),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            return _buildErrorView();
          }

          final scheduleList = snapshot.data!;
          if (scheduleList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    "No schedule available for this branch",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              _buildDaySelector(scheduleList),
              Expanded(
                child: _selectedDayIndex < scheduleList.length
                    ? _buildDaySchedule(scheduleList[_selectedDayIndex])
                    : Center(
                  child: Text(
                    "No schedule for ${weekDays[_selectedDayIndex]}",
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
          const SizedBox(height: 16),
          const Text(
            "Failed to load schedule",
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _scheduleFuture = _fetchSchedule();
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text("Retry"),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector(List<BranchSchedule> scheduleList) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: weekDays.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedDayIndex == index;
          final isScheduled = scheduleList.any((schedule) => schedule.dayOfWeek == index);

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDayIndex = index;
              });
            },
            child: Container(
              width: 80,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : (isScheduled ? secondaryColor : Colors.grey.shade100),
                borderRadius: BorderRadius.circular(16),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weekDays[index].substring(0, 3),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? Colors.white
                          : (isScheduled ? accentColor : Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (isScheduled && !isSelected)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                    )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDaySchedule(BranchSchedule schedule) {
    final sortedMeals = List<MealSchedules>.from(schedule.mealSchedules ?? [])
      ..sort((a, b) => a.mealType?.compareTo(b.mealType ?? 0) ?? 0);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedMeals.length,
      itemBuilder: (context, index) {
        final meal = sortedMeals[index];
        return _buildMealCard(meal, index);
      },
    );
  }

  Widget _buildMealCard(MealSchedules meal, int index) {
    final colors = _getMealColorScheme(meal.mealType);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.background, colors.background.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(
                  _getMealIcon(meal.mealType),
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  _getMealTypeName(meal.mealType),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time, color: colors.primary, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      "Serving Time",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.primary.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "${meal.mealStartTime}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          indent: 10,
                          endIndent: 10,
                          color: colors.primary.withOpacity(0.5),
                        ),
                      ),
                      Text(
                        "${meal.mealEndTime}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  MealColorScheme _getMealColorScheme(int? mealType) {
    switch (mealType) {
      case 0: // Breakfast
        return MealColorScheme(
          primary: const Color(0xFF1E88E5),
          background: const Color(0xFFE3F2FD),
          shadow: const Color(0xFF1E88E5).withOpacity(0.2),
        );
      case 1: // Lunch
        return MealColorScheme(
          primary: const Color(0xFF43A047),
          background: const Color(0xFFE8F5E9),
          shadow: const Color(0xFF43A047).withOpacity(0.2),
        );
      case 2: // Dinner
        return MealColorScheme(
          primary: const Color(0xFF8E24AA),
          background: const Color(0xFFF3E5F5),
          shadow: const Color(0xFF8E24AA).withOpacity(0.2),
        );
      default:
        return MealColorScheme(
          primary: primaryColor,
          background: secondaryColor,
          shadow: primaryColor.withOpacity(0.2),
        );
    }
  }

  IconData _getMealIcon(int? mealType) {
    switch (mealType) {
      case 0:
        return Icons.breakfast_dining;
      case 1:
        return Icons.lunch_dining;
      case 2:
        return Icons.dinner_dining;
      default:
        return Icons.restaurant;
    }
  }

  String _getMealTypeName(int? mealType) {
    switch (mealType) {
      case 0:
        return "Breakfast";
      case 1:
        return "Lunch";
      case 2:
        return "Dinner";
      default:
        return "Meal";
    }
  }
}

// Helper class for meal color schemes
class MealColorScheme {
  final Color primary;
  final Color background;
  final Color shadow;

  MealColorScheme({
    required this.primary,
    required this.background,
    required this.shadow,
  });
}