import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../helpers/api_helper/api_helper.dart';
import '../../helpers/cubit_helper/api_cubit.dart';
import '../../models/branch_model/branch_model.dart';
import '../../models/chefs_model/chefs_model.dart';

// RestaurantAdminCubit - Extend your ApiCubit for Restaurant Admin operations
class RestaurantAdminCubit extends ApiCubit {
  RestaurantAdminCubit() : super();

  List<Branch> branches = [];
  List<Chef> chefs = [];
  Map<String, dynamic>? restaurantStats;

  // Branch Operations
  Future<void> fetchBranches() async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.getData(path: '/api/Branch/all');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        branches = data.map((json) => Branch.fromJson(json)).toList();
        emit(SuccessState());
      } else {
        emit(ErrorState('Failed to load branches'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
  Future<void> assignBranchAdmin(String branchAdminId, String branchId) async {
    emit(LoadingState());
    try {
      // Ensure IDs are valid integers before passing them to the API
      final int parsedBranchId = int.tryParse(branchId) ?? 0;
      final int parsedBranchAdminId = int.tryParse(branchAdminId) ?? 0;
      final response = await ApiHelper.patchData(
        path: "/api/Account/assign-branch-admin-role?branchId=$parsedBranchId&branchAdminId=$parsedBranchAdminId",
      );

      if (response.statusCode == 200) {
        emit(SuccessState());
      } else {
        emit(ErrorState('Failed to assign branch admin'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> createBranch(Branch branch) async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.postData(
        path: '/api/Branch/create',
        body: branch.toJson(),
      );

      if (response?.statusCode == 201) {
        await fetchBranches();
      } else {
        emit(ErrorState('Failed to create branch'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> updateBranch(Branch branch,int branchID) async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.putData(
        path: '/api/Branch/update/$branchID',
        body: branch.toJson(),
      );
      if (response.statusCode == 200) {
        await fetchBranches();
      } else {
        emit(ErrorState('Failed to update branch'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> deleteBranch(int id) async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.deleteData(
        path: '/api/Branch/delete/$id',
      );
      if (response.statusCode == 200) {
        await fetchBranches();
      } else {
        emit(ErrorState('Failed to delete branch'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  // Chef Operations
  Future<void> fetchChefs() async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.getData(path: '/api/Chef/all');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        chefs = data.map((json) => Chef.fromJson(json)).toList();
        emit(SuccessState());
      } else {
        emit(ErrorState('Failed to load chefs'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> createChef(Chef chef) async {
    emit(LoadingState());
    try {

      final response = await ApiHelper.postData(
        path: '/api/Chef/create',
        body: chef.toJson(),
      );
       if (response?.statusCode == 201) {

        await fetchChefs();
      } else {
        emit(ErrorState('Failed to create chef'));

      }
    } catch (e) {
      emit(ErrorState(e.toString()));
     }
  }

  Future<void> updateChef(Chef chef,int chefId) async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.putData(
        path: '/api/Chef/update/${chefId}',
        body: chef.toJson(),
      );
      if (response.statusCode == 200) {
        await fetchChefs();
      } else {
        emit(ErrorState('Failed to update chef'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> deleteChef(int id) async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.deleteData(
        path: '/api/Chef/delete/$id',
      );
      if (response.statusCode == 200) {
        await fetchChefs();
      } else {
        emit(ErrorState('Failed to delete chef'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  // Restaurant Stats
  Future<void> fetchRestaurantStats() async {
    emit(LoadingState());
    try {
      final response =
          await ApiHelper.getData(path: '/api/Report/report-system');
      if (response.statusCode == 200) {
        restaurantStats = response.data;
        emit(SuccessState());
      } else {
        emit(ErrorState('Failed to load restaurant stats'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  // Update Restaurant
  Future<void> updateRestaurant(Map<String, dynamic> restaurantData) async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.putData(
        path: '/api/Restaurant/update/1', // Assuming restaurant ID is 1
        body: restaurantData,
      );
      if (response.statusCode == 200) {
        emit(SuccessState());
      } else {
        emit(ErrorState('Failed to update restaurant'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
}

class RestaurantAdminScreen extends StatefulWidget {
  const RestaurantAdminScreen({super.key});

  @override
  State<RestaurantAdminScreen> createState() => _RestaurantAdminScreenState();
}

class _RestaurantAdminScreenState extends State<RestaurantAdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final RestaurantAdminCubit _cubit = RestaurantAdminCubit();
  final TextEditingController assignBranchAdminController = TextEditingController();
  final TextEditingController assignBranchIdController = TextEditingController();
  final primaryColor = const Color(0xff32B768);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    await _cubit.fetchRestaurantStats();
    await _cubit.fetchBranches();
    await _cubit.fetchChefs();
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
          title: const Text('Restaurant Management'),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(text: 'Dashboard', icon: Icon(Icons.dashboard)),
              Tab(text: 'Branches', icon: Icon(Icons.store)),
              Tab(text: 'Chefs', icon: Icon(Icons.restaurant)),
              Tab(text: 'Settings', icon: Icon(Icons.settings)),
            ],
          ),

        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildDashboardTab(),
            _buildBranchesTab(),
            _buildChefsTab(),
            _buildSettingsTab(),
          ],
        ),
        floatingActionButton: BlocBuilder<RestaurantAdminCubit, ApiState>(
          builder: (context, state) {
            if (_tabController.index == 1) {
              return FloatingActionButton(
                onPressed: () => _showBranchForm(context),
                backgroundColor: primaryColor,
                child: const Icon(Icons.add),
              );
            } else if (_tabController.index == 2) {
              return FloatingActionButton(
                onPressed: () => _showChefForm(context),
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

  Widget _buildDashboardTab() {

    return BlocBuilder<RestaurantAdminCubit, ApiState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        final stats = _cubit.restaurantStats;

        if (stats == null) {
          return const Center(child: Text('No stats available'));
        }

        return RefreshIndicator(
          onRefresh: _cubit.fetchRestaurantStats,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Restaurant Statistics',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                _buildStatCard(
                  title: 'Total Branches',
                  value: stats['totalBranches'].toString(),
                  icon: Icons.store,
                  color: primaryColor,
                ),
                _buildStatCard(
                  title: 'Total Chefs',
                  value: stats['totalChefs'].toString(),
                  icon: Icons.restaurant,
                  color: Colors.orange,
                ),
                _buildStatCard(
                  title: 'Total Reservations',
                  value: stats['totalReservations'].toString(),
                  icon: Icons.calendar_today,
                  color: Colors.purple,
                ),
                const SizedBox(height: 24),
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildActionButton(
                      title: 'Add Branch',
                      icon: Icons.add_business,
                      color: primaryColor,
                      onTap: () => _showBranchForm(context),
                    ),
                    const SizedBox(width: 16),
                    _buildActionButton(
                      title: 'Add Chef',
                      icon: Icons.person_add,
                      color: Colors.orange,
                      onTap: () => _showChefForm(context),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildActionButton(
                      title: 'Assign New Branch Admin',
                      icon: Icons.person_add,
                      color: Colors.blueAccent,
                      onTap: () => QuickAlert.show(
                        context: context,
                        type: QuickAlertType.custom,
                        barrierDismissible: true,
                        confirmBtnText: 'Save',
                        widget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Branch Admin ID Field
                            TextFormField(
                              controller: assignBranchAdminController,
                              decoration: const InputDecoration(
                                hintText: 'Enter Branch Admin ID',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(),
                              ),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number, // Ensures numeric input
                            ),
                            const SizedBox(height: 10),

                            // Branch ID Field
                            TextFormField(
                              controller: assignBranchIdController,
                              decoration: const InputDecoration(
                                hintText: 'Enter Branch ID',
                                prefixIcon: Icon(Icons.qr_code),
                                border: OutlineInputBorder(),
                              ),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number, // Ensures numeric input
                            ),
                          ],
                        ),
                        onConfirmBtnTap: () {
                          final branchAdminId = assignBranchAdminController.text.trim();
                          final branchId = assignBranchIdController.text.trim();

                          if (branchAdminId.isEmpty || branchId.isEmpty) {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: 'Error',
                              text: 'Both fields are required!',
                            );
                            return;
                          }

                         context.read<RestaurantAdminCubit>().assignBranchAdmin(branchAdminId, branchId);
                          Navigator.pop(context); // Close the dialog after confirming
                        },
                      ),
                    )

                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBranchesTab() {
    return BlocBuilder<RestaurantAdminCubit, ApiState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_cubit.branches.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.store_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No branches available',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => _showBranchForm(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Branch'),
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
          onRefresh: _cubit.fetchBranches,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _cubit.branches.length,
            itemBuilder: (context, index) {
              final branch = _cubit.branches[index];
              return _buildBranchCard(branch);
            },
          ),
        );
      },
    );
  }

  Widget _buildBranchCard(Branch branch) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Branch Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: branch.imageUrl != null && branch.imageUrl!.isNotEmpty
                ? Image.network(
              branch.imageUrl??"https://mir-s3-cdn-cf.behance.net/project_modules/max_1200/62ea0e35568421.56fbe47dcc9e0.jpg",
              height: 150,
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
                    child:
                        const Icon(Icons.store, size: 64, color: Colors.grey),
                  ),
          ),

          // Branch Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        branch.name ?? 'Unnamed Branch',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showBranchForm(context, branch),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _showDeleteConfirmation(
                            context,
                            'Delete Branch',
                            'Are you sure you want to delete ${branch.name}?',
                            () => _cubit.deleteBranch(branch.id!),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (branch.address != null)
                  _buildInfoRow(Icons.location_on, branch.address!),
                if (branch.phone != null)
                  _buildInfoRow(Icons.phone, branch.phone!),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Working Hours:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      '${branch.openingTime ?? '00:00'} - ${branch.closingTime ?? '00:00'}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
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

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey[800]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChefsTab() {
    return BlocBuilder<RestaurantAdminCubit, ApiState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_cubit.chefs.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No chefs available',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => _showChefForm(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Chef'),
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
          onRefresh: _cubit.fetchChefs,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _cubit.chefs.length,
            itemBuilder: (context, index) {
              final chef = _cubit.chefs[index];
              return _buildChefCard(chef);
            },
          ),
        );
      },
    );
  }

  Widget _buildChefCard(Chef chef) {
    String jobTitleText = 'Chef';
    if (chef.jobTitle == 1) {
      jobTitleText = 'Head Chef';
    } else if (chef.jobTitle == 2) {
      jobTitleText = 'Sous Chef';
    } else if (chef.jobTitle == 3) {
      jobTitleText = 'Pastry Chef';
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chef Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: chef.imageUrl != null && chef.imageUrl!.isNotEmpty
                  ? Image.network(
                      chef.imageUrl!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                        child: const Icon(Icons.person,
                            size: 50, color: Colors.grey),
                      ),
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.person,
                          size: 50, color: Colors.grey),
                    ),
            ),
            const SizedBox(width: 16),
            // Chef Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          chef.name ?? 'Unnamed Chef',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Colors.blue, size: 20),
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            onPressed: () => _showChefForm(context, chef),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red, size: 20),
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            onPressed: () => _showDeleteConfirmation(
                              context,
                              'Delete Chef',
                              'Are you sure you want to delete ${chef.name}?',
                              () => _cubit.deleteChef(chef.id!),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      jobTitleText,
                      style: TextStyle(
                        fontSize: 12,
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    chef.description ?? 'No description',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Restaurant Settings',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Restaurant Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),

          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: () => _showRestaurantUpdateForm(context),
            icon: const Icon(Icons.edit),
            label: const Text('Update Restaurant Info'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),

          const SizedBox(height: 32),

          const Text(
            'System Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),

          const SizedBox(height: 16),

          // Sample system info
          const ListTile(
            leading: Icon(Icons.info, color: Colors.grey),
            title: Text('App Version'),
            subtitle: Text('1.0.0'),
            dense: true,
          ),

          const ListTile(
            leading: Icon(Icons.api, color: Colors.grey),
            title: Text('API Endpoint'),
            subtitle: Text('http://spiderxrestauranttt.runasp.net'),
            dense: true,
          ),
        ],
      ),
    );
  }

  void _showBranchForm(BuildContext context, [Branch? branch]) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: branch?.name);
    final addressController = TextEditingController(text: branch?.address);
    final phoneController = TextEditingController(text: branch?.phone);
    final imageUrlController = TextEditingController(text: branch?.imageUrl);
    final openingTimeController =
        TextEditingController(text: branch?.openingTime);
    final closingTimeController =
        TextEditingController(text: branch?.closingTime);

    bool isEditing = branch != null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isEditing ? 'Edit Branch' : 'Add New Branch',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Branch Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter branch name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: imageUrlController,
                    decoration: InputDecoration(
                      labelText: 'Image URL',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.image),
                        onPressed: () async {
                          // Here you would typically implement image picking and uploading
                          // For demonstration purposes, we'll just use a placeholder URL
                          imageUrlController.text =
                              'https://via.placeholder.com/150';
                          // Implement image picking using ImagePicker
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery);

                          if (image != null) {
                            // Assuming you have a function to upload the image and get the URL
                            // For now, we'll just use the local file path as a placeholder
                            imageUrlController.text = image.path;
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: openingTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Opening Time (HH:mm)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.datetime,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter opening time';
                      }
                      // Add time format validation if needed
                      return null;
                    },
                    onTap: () async {
                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        openingTimeController.text =
                        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: closingTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Closing Time (HH:mm)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.datetime,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter closing time';
                      }
                      // Add time format validation if needed
                      return null;
                    },
                    onTap: () async {
                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        closingTimeController.text =
                        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final newBranch = Branch(
                            name: nameController.text,
                            address: addressController.text,
                            phone: phoneController.text,
                            imageUrl: imageUrlController.text,
                            openingTime: openingTimeController.text,
                            closingTime: closingTimeController.text,
                            restaurantId: 1,
                          );

                          if (isEditing) {
                            await _cubit.updateBranch(newBranch,branch.id??4);
                          } else {
                            await _cubit.createBranch(newBranch);
                          }

                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isEditing
                                      ? 'Branch updated successfully'
                                      : 'Branch added successfully',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        }
                      },
                      child: Text(isEditing ? 'Update Branch' : 'Add Branch'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showChefForm(BuildContext context, [Chef? chef]) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: chef?.name);
    final descriptionController =
        TextEditingController(text: chef?.description);
    final imageUrlController = TextEditingController(text: chef?.imageUrl);
    int selectedJobTitle = chef?.jobTitle ?? 1;

    bool isEditing = chef != null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: StatefulBuilder(
          builder: (context, setState) => Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isEditing ? 'Edit Chef' : 'Add New Chef',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Chef Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter chef name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: selectedJobTitle,
                      decoration: const InputDecoration(
                        labelText: 'Job Title',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('Head Chef')),
                        DropdownMenuItem(value: 2, child: Text('Sous Chef')),
                        DropdownMenuItem(value: 3, child: Text('Pastry Chef')),
                      ],
                      onChanged: (value) {
                        setState(() => selectedJobTitle = value!);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty ||value.length <12) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: imageUrlController,
                      decoration: InputDecoration(
                        labelText: 'Image URL',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.image),
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery);

                            if (image != null) {
                              imageUrlController.text = image.path;
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final newChef = Chef(

                               name: nameController.text,
                              description: descriptionController.text,
                              imageUrl: imageUrlController.text,
                              jobTitle: selectedJobTitle,
                              restaurantId: 1,

                            );

                            if (isEditing) {
                              await _cubit.updateChef(newChef,chef.id??7);
                            } else {
                              await _cubit.createChef(newChef);
                            }

                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isEditing
                                        ? 'Chef updated successfully'
                                        : 'Chef added successfully',
                                  ),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          }
                        },
                        child: Text(isEditing ? 'Update Chef' : 'Add Chef'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    String title,
    String message,
    VoidCallback onConfirm,
  ) {
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
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showRestaurantUpdateForm(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final addressController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Update Restaurant Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Restaurant Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter restaurant name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final restaurantData = {
                            'name': nameController.text,
                            'description': descriptionController.text,
                            'address': addressController.text,
                            'phone': phoneController.text,
                            'email': emailController.text,
                          };

                          await _cubit.updateRestaurant(restaurantData);

                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Restaurant information updated successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Update Restaurant'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
