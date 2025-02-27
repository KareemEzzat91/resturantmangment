import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../helpers/api_helper/api_helper.dart';
import '../../helpers/cubit_helper/api_cubit.dart';
import '../../models/meal_schedules/meal_schedulesmodel.dart';
import '../../models/menu_model/menu_model.dart';
import '../../models/table_model/tables_model.dart';

// BranchAdminCubit - Extend ApiCubit for Branch Admin operations
class BranchAdminCubit extends ApiCubit {
  BranchAdminCubit() : super();

  BranchSchedule? branchSchedule;
  List<MenuModel> menuItems = [];
  List<TablesModel> tables = [];

  // Branch Schedule Operations
  Future<void> fetchBranchSchedule(int branchId) async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.getData(path: '/api/BranchSchedule/1');
      if (response.statusCode == 200) {
        branchSchedule = BranchSchedule.fromJson(response.data);
        emit(SuccessState());
      } else {
        emit(ErrorState('Failed to load branch schedule'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> updateBranchSchedule(int scheduleId, Map<String, dynamic> scheduleData) async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.putData(
        path: '/api/BranchSchedule/update/$scheduleId',
        body: scheduleData,
      );
      if (response.statusCode == 200) {
        emit(SuccessState());
        await fetchBranchSchedule(scheduleData['1']);
      } else {
        emit(ErrorState('Failed to update branch schedule'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  // Menu Operations
  Future<void> fetchMenuItems(int branchId) async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.getData(path: '/api/Menu/menu/1');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        menuItems = data.map((json) => MenuModel.fromJson(json)).toList();
        emit(SuccessState());
      } else {
        emit(ErrorState('Failed to load menu items'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> createMenuItem(MenuModel menuItem) async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.postData(
        path: '/api/Menu/create',
        body: menuItem.toJson(),
      );
      if (response?.statusCode == 201) {
        await fetchMenuItems(menuItem.branchId??1);
      } else {
        emit(ErrorState('Failed to create menu item'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> updateMenuItem(MenuModel menuItem, int menuItemId) async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.putData(
        path: '/api/Menu/update/$menuItemId',
        body: menuItem.toJson(),
      );
      if (response.statusCode == 200) {
        await fetchMenuItems(menuItem.branchId??1);
      } else {
        emit(ErrorState('Failed to update menu item'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> deleteMenuItem(int id, int branchId) async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.deleteData(
        path: '/api/Menu/delete/$id',
      );
      if (response.statusCode == 200) {
        await fetchMenuItems(branchId);
      } else {
        emit(ErrorState('Failed to delete menu item'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  // Table Operations
  Future<void> fetchTables(int branchId) async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.getData(path: '/api/Table/all/1');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        tables = data.map((json) => TablesModel.fromJson(json)).toList();
        emit(SuccessState());
      } else {
        emit(ErrorState('Failed to load tables'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> createTable(TablesModel table) async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.postData(
        path: '/api/Table/create',
        body: table.toJson(),
      );
      if (response?.statusCode == 201) {
        await fetchTables(table.branchId??1);
      } else {
        emit(ErrorState('Failed to create table'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> updateTable(TablesModel table, int tableId) async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.putData(
        path: '/api/Table/update/$tableId',
        body: table.toJson(),
      );
      if (response.statusCode == 200) {
        await fetchTables(table.branchId??1);
      } else {
        emit(ErrorState('Failed to update table'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> deleteTable(int id, int branchId) async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.deleteData(
        path: '/api/Table/delete/$id',
      );
      if (response.statusCode == 200) {
        await fetchTables(branchId);
      } else {
        emit(ErrorState('Failed to delete table'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
}

class BranchAdminScreen extends StatefulWidget {
  const BranchAdminScreen({super.key});

  @override
  State<BranchAdminScreen> createState() => _BranchAdminScreenState();
}

class _BranchAdminScreenState extends State<BranchAdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final BranchAdminCubit _cubit = BranchAdminCubit();
  final primaryColor = const Color(0xff32B768);

  // Mock branch ID - in a real app, get this from authentication
  final int branchId = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    await _cubit.fetchBranchSchedule(branchId);
    await _cubit.fetchMenuItems(branchId);
    await _cubit.fetchTables(branchId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Branch Management'),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(text: 'Schedule', icon: Icon(Icons.schedule)),
              Tab(text: 'Menu', icon: Icon(Icons.restaurant_menu)),
              Tab(text: 'Tables', icon: Icon(Icons.table_bar)),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildScheduleTab(),
            _buildMenuTab(),
            _buildTablesTab(),
          ],
        ),
        floatingActionButton: BlocBuilder<BranchAdminCubit, ApiState>(
          builder: (context, state) {
            if (_tabController.index == 1) {
              return FloatingActionButton(
                onPressed: () => _showMenuItemForm(context),
                backgroundColor: primaryColor,
                child: const Icon(Icons.add),
              );
            } else if (_tabController.index == 2) {
              return FloatingActionButton(
                onPressed: () => _showTableForm(context),
                backgroundColor: primaryColor,
                child: const Icon(Icons.add),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // Schedule Tab
  Widget _buildScheduleTab() {
    return BlocBuilder<BranchAdminCubit, ApiState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        final schedule = _cubit.branchSchedule;

        if (schedule == null) {
          return const Center(child: Text('No schedule available'));
        }

        return RefreshIndicator(
          onRefresh: () => _cubit.fetchBranchSchedule(branchId),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Branch Schedule',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // Display schedule for each day
                ...List.generate(7, (index) => _buildDayScheduleCard(index, schedule)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDayScheduleCard(int dayIndex, BranchSchedule schedule) {
    final dayNames = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];

    // Get meal schedules for this day
    final mealSchedules = schedule.mealSchedules?.where(
            (meal) => meal.id == dayIndex
    ).toList();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dayNames[dayIndex],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showScheduleForm(context, dayIndex, mealSchedules!),
                ),
              ],
            ),
            const Divider(height: 24),
            if (mealSchedules!.isEmpty)
              const Text('No meals scheduled for this day'),
            ...mealSchedules.map((meal) => _buildMealScheduleItem(meal)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMealScheduleItem(MealSchedules meal) {
    final mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];
    final mealTypeName = meal.mealType! < mealTypes.length
        ? mealTypes[meal.mealType??0]
        : 'Meal ${meal.mealType}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              mealTypeName,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            '${meal.mealStartTime} - ${meal.mealEndTime}',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _showScheduleForm(BuildContext context, int dayIndex, List<MealSchedules> mealSchedules) {
    final dayNames = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    final mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];

    // Controller for new meal schedules
    int? selectedMealType = 0;
    final startTimeController = TextEditingController();
    final endTimeController = TextEditingController();

    if (mealSchedules.isNotEmpty) {
      final meal = mealSchedules.first;
      selectedMealType = meal.mealType;
      startTimeController.text = meal.mealStartTime??"20:20:00";
      endTimeController.text = meal.mealEndTime??"20:20:00";
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${dayNames[dayIndex]} Schedule'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<int>(
                    value: selectedMealType,
                    decoration: const InputDecoration(
                      labelText: 'Meal Type',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(mealTypes.length, (index) {
                      return DropdownMenuItem(
                        value: index,
                        child: Text(mealTypes[index]),
                      );
                    }),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedMealType = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: startTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Start Time (HH:MM)',
                      border: OutlineInputBorder(),
                    ),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        startTimeController.text = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: endTimeController,
                    decoration: const InputDecoration(
                      labelText: 'End Time (HH:MM)',
                      border: OutlineInputBorder(),
                    ),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        endTimeController.text = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final scheduleData = {
                'mealType': selectedMealType,
                'mealStartTime': startTimeController.text,
                'mealEndTime': endTimeController.text,
                'branchId': branchId,
              };

              // Get schedule ID if exists
              int? scheduleId;
              if (mealSchedules.isNotEmpty) {
                scheduleId = mealSchedules.first.id;
              }

              if (scheduleId != null) {
                _cubit.updateBranchSchedule(scheduleId, scheduleData);
              }

              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Menu Tab
  Widget _buildMenuTab() {
    return BlocBuilder<BranchAdminCubit, ApiState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_cubit.menuItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.restaurant_menu, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No menu items available',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => _showMenuItemForm(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Menu Item'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _cubit.fetchMenuItems(branchId),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _cubit.menuItems.length,
            itemBuilder: (context, index) {
              final menuItem = _cubit.menuItems[index];
              return _buildMenuItemCard(menuItem);
            },
          ),
        );
      },
    );
  }

  Widget _buildMenuItemCard(MenuModel menuItem) {
    final categoryNames = [
      'Appetizer', 'Main Course', 'Dessert', 'Beverage', 'Special'
    ];
    final categoryName = menuItem.category! < categoryNames.length
        ? categoryNames[menuItem.category??0]
        : 'Category ${menuItem.category}';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Menu Item Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: menuItem.imageUrl!.isNotEmpty
                ? Image.network(
              menuItem.imageUrl??"https://www.deputy.com/uploads/2018/10/The-Most-Popular-Menu-Items-That-You-should-Consider-Adding-to-Your-Restaurant_Content-image2-min-1024x569.png"
              ,height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image,
                    size: 64, color: Colors.grey),
              ),
            )
                : Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Icon(Icons.restaurant_menu,
                  size: 64, color: Colors.grey),
            ),
          ),

          // Menu Item Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            menuItem.name??"",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${menuItem.price?.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showMenuItemForm(context, menuItem),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _showDeleteConfirmation(
                            context,
                            'Delete Menu Item',
                            'Are you sure you want to delete ${menuItem.name}?',
                                () => _cubit.deleteMenuItem(menuItem.id??0, 1),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  menuItem.description??"",
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        categoryName,
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: menuItem.isAvailable!
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        menuItem.isAvailable! ? 'Available' : 'Not Available',
                        style: TextStyle(
                          color: menuItem.isAvailable! ? Colors.green : Colors.red,
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
    );
  }

  void _showMenuItemForm(BuildContext context, [MenuModel? menuItem]) {
    final categoryNames = [
      'Appetizer', 'Main Course', 'Dessert', 'Beverage', 'Special'
    ];

    final nameController = TextEditingController(text: menuItem?.name ?? '');
    final descController = TextEditingController(text: menuItem?.description ?? '');
    final priceController = TextEditingController(
        text: menuItem?.price.toString() ?? '');

    int selectedCategory = menuItem?.category ?? 0;
    bool isAvailable = menuItem?.isAvailable ?? true;
    String? imagePath;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(menuItem == null ? 'Add Menu Item' : 'Edit Menu Item'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(),
                      prefixText: '\$',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(categoryNames.length, (index) {
                      return DropdownMenuItem(
                        value: index,
                        child: Text(categoryNames[index]),
                      );
                    }),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedCategory = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Available for order',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Switch(
                        value: isAvailable,
                        onChanged: (value) {
                          setState(() {
                            isAvailable = value;
                          });
                        },
                        activeColor: primaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final imagePicker = ImagePicker();
                      final pickedImage = await imagePicker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (pickedImage != null) {
                        setState(() {
                          imagePath = pickedImage.path;
                        });
                      }
                    },
                    icon: const Icon(Icons.image),
                    label: Text(imagePath != null || (menuItem?.imageUrl?.isNotEmpty ?? false)
                        ? 'Change Image'
                        : 'Add Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  if (imagePath != null)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text('Image selected'),
                    ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              final description = descController.text.trim();
              final priceText = priceController.text.trim();

              if (name.isEmpty || description.isEmpty || priceText.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
                return;
              }

              final price = double.tryParse(priceText) ?? 0.0;
              final imageUrl = imagePath ?? (menuItem?.imageUrl ?? '');

              final newMenuItem = MenuModel(
                id: menuItem?.id ?? 0,
                name: name,
                description: description,
                price: price,
                imageUrl: imageUrl,
                category: selectedCategory,
                isAvailable: isAvailable,
                branchId: branchId,
              );

              if (menuItem == null) {
                _cubit.createMenuItem(newMenuItem);
              } else {
                _cubit.updateMenuItem(newMenuItem, menuItem.id??0);
              }

              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
// Tables Tab
  Widget _buildTablesTab() {
    return BlocBuilder<BranchAdminCubit, ApiState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_cubit.tables.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.table_bar, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No tables available',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => _showTableForm(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Table'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => _cubit.fetchTables(branchId),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: _cubit.tables.length,
            itemBuilder: (context, index) {
              final table = _cubit.tables[index];
              return _buildTableCard(table);
            },
          ),
        );
      },
    );
  }

  Widget _buildTableCard(TablesModel table) {
    // Status color mapping
    final statusColors = {
      'Available': Colors.green,
      'Occupied': Colors.red,
      'Reserved': Colors.orange,
    };

    // Get color based on status with fallback
    const statusColor =  Colors.grey;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showTableForm(context, table),
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.table_restaurant, size: 48, color: primaryColor),
                  const SizedBox(height: 12),
                  Text(
                    'Table ${table.tableNumber ?? 0}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${table.capacity ?? 0} Person${table.capacity == 1 ? '' : 's'}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
/*
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                       'Unknown',
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
*/
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteConfirmation(
                  context,
                  'Delete Table',
                  'Are you sure you want to delete Table ${table.tableNumber}?',
                      () => _cubit.deleteTable(table.id ?? 0, branchId),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTableForm(BuildContext context, [TablesModel? table]) {
    final tableNumberController = TextEditingController(text: table?.tableNumber?.toString() ?? '');
    final capacityController = TextEditingController(text: table?.capacity?.toString() ?? '4');

    final statusOptions = ['Available', 'Occupied', 'Reserved', 'Maintenance'];
    String selectedStatus =  'Available';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(table == null ? 'Add New Table' : 'Edit Table'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    enabled: false,
                    controller: tableNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Table Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: capacityController,
                    decoration: const InputDecoration(
                      labelText: 'Capacity',
                      border: OutlineInputBorder(),
                      suffixText: 'Person(s)',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    items: statusOptions.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedStatus = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final tableNumber = int.tryParse(tableNumberController.text.trim());
              final capacity = int.tryParse(capacityController.text.trim());

              if (capacity == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter valid numbers')),
                );
                return;
              }

              final newTable = TablesModel(
                  capacity: capacity,
                 branchId: 1,
              );

              if (table == null) {
                _cubit.createTable(newTable);
              } else {
                _cubit.updateTable(newTable, table.id ?? 0);
              }

              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Utility methods
  void _showDeleteConfirmation(
      BuildContext context,
      String title,
      String message,
      Function() onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}