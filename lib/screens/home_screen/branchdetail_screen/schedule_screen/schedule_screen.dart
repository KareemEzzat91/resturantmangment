import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:resturantmangment/models/meal_schedules/meal_schedulesmodel.dart';
import 'package:resturantmangment/screens/home_screen/branchdetail_screen/tables_screen/tables_screen.dart';
import '../../../../helpers/cubit_helper/api_cubit.dart';

class ScheduleScreen extends StatefulWidget {
  final int branchId;
  final bool isBooking;
  final String? date;

  const ScheduleScreen({
    super.key,
    required this.branchId,
    required this.isBooking,
    this.date
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late Future<dynamic> _scheduleFuture;
  int _selectedDayIndex = DateTime.now().weekday % 7; // Today's index, using Saturday as 0

  // Constants
  static const List<String> weekDays = [
    "Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"
  ];

  // Color scheme
  static const Color primaryColor = Color(0xff32B768);
  static const Color secondaryColor = Color(0xffE6F7EC);
  static const Color accentColor = Color(0xff065F46);

  @override
  void initState() {
    super.initState();
    _initScheduleFuture();
  }

  void _initScheduleFuture() {
    _scheduleFuture = widget.isBooking && widget.date != null
        ? _fetchDaySchedule()
        : _fetchWeeklySchedule();
  }

  Future<List<BranchSchedule>?> _fetchWeeklySchedule() async {
    return await context.read<ApiCubit>().getSchedule(widget.branchId);
  }

  Future<BranchSchedule> _fetchDaySchedule() async {
    return await context.read<ApiCubit>().getSchedulePerDay(widget.branchId, widget.date!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: FutureBuilder<dynamic>(
        future: _scheduleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingView();
          } else if (snapshot.hasError || snapshot.data == null) {
            return _buildErrorView();
          }

          if (widget.isBooking && widget.date != null) {
            return _buildDaySchedule(snapshot.data as BranchSchedule);
          } else {
            final scheduleList = snapshot.data as List<BranchSchedule>;
            if (scheduleList.isEmpty) {
              return _buildEmptyScheduleView();
            }
            return _buildWeeklyScheduleView(scheduleList);
          }
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        widget.isBooking ? "Choose Your Meal Schedule" : "Weekly Meal Schedule",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: primaryColor),
          SizedBox(height: 16),
          Text(
            "Loading schedule...",
            style: TextStyle(color: accentColor, fontSize: 16),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyScheduleView() {
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
                _initScheduleFuture();
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

  Widget _buildWeeklyScheduleView(List<BranchSchedule> scheduleList) {
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
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
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
                      decoration: const BoxDecoration(
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

    if (sortedMeals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.no_meals, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              "No meals scheduled for ${widget.isBooking ? "this date" : weekDays[_selectedDayIndex]}",
              style: const TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedMeals.length,
      itemBuilder: (context, index) {
        final meal = sortedMeals[index];
        return _buildMealCard(meal, index,);
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
                const Spacer(),
                if (widget.isBooking)
                  IconButton(
                    icon: const Icon(Icons.check_circle_outline_outlined, color: Colors.white),
                    onPressed: () {
                      QuickAlert.show(
                      context: context,
                      type: QuickAlertType.confirm,
                      text: 'Your Meal is ${_getMealTypeName(meal.mealType)}',
                      confirmBtnText: 'Yes',
                      cancelBtnText: 'No',
                      confirmBtnColor: Colors.green,
                      onConfirmBtnTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>TablesScreen( mealSchedulesId: meal.id,branchId: widget.branchId, isBooking: true,selectedDate:widget.date ,selectedMeal: _getMealTypeName(meal.mealType),selectedMealNum:meal.mealType)));
                      }
                    );

                    },
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
                        meal.mealStartTime ?? "N/A",
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
                        meal.mealEndTime ?? "N/A",
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
        return const MealColorScheme(
          primary: Color(0xFF1E88E5),
          background: Color(0xFFE3F2FD),
          shadow: Color(0x331E88E5),
        );
      case 1: // Lunch
        return const MealColorScheme(
          primary: Color(0xFF43A047),
          background: Color(0xFFE8F5E9),
          shadow: Color(0x3343A047),
        );
      case 2: // Dinner
        return const MealColorScheme(
          primary: Color(0xFF8E24AA),
          background: Color(0xFFF3E5F5),
          shadow: Color(0x338E24AA),
        );
      default:
        return const MealColorScheme(
          primary: primaryColor,
          background: secondaryColor,
          shadow: Color(0x3332B768),
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

  const MealColorScheme({
    required this.primary,
    required this.background,
    required this.shadow,
  });
}