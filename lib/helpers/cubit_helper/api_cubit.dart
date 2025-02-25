import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:resturantmangment/helpers/api_helper/api_helper.dart';
import 'package:resturantmangment/models/chefs_model/chefs_model.dart';
import 'package:resturantmangment/models/meal_schedules/meal_schedulesmodel.dart';
import 'package:resturantmangment/models/menu_model/menu_model.dart';
import 'package:resturantmangment/models/notification_model/notification_model.dart';
import 'package:resturantmangment/models/resturant_model/resturant_model.dart';
import 'package:resturantmangment/screens/main_screen/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/Reservation_model/Reservation_model.dart';
import '../../models/table_model/tables_model.dart';
import '../../screens/Registration/login_screen/login_screen.dart';
import '../../screens/home_screen/home_screen.dart';

part 'api_state.dart';

class ApiCubit extends Cubit<ApiState> {
  ApiCubit() : super(ApiInitial());
  Future<void> login(BuildContext context, {required String email, required String password}) async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.postData(
        path: "/api/Account/login",
        body: {"email": email, "password": password},
      );

      if (response?.statusCode == 200) {
        final token = response?.data["token"];
        final role = response?.data['role'];

        // حفظ التوكين في التخزين المحلي
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token);
        await prefs.setInt("role", role);

        // الانتقال إلى الصفحة الرئيسية وإزالة كل الصفحات السابقة
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>  const MainScreen()),
              (Route<dynamic> route) => false,
        );

        emit(SuccessState());
      } else {
        emit(ErrorState('Invalid credentials'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
  Future<void> register(BuildContext context, {required String email, required String password, required String firstName, required String lastName, required String phoneNumber,}) async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.postData(
        path: "/api/Account/register",
        body: {"email": email,"firstName":firstName,"lastName":lastName,"phoneNumber":phoneNumber, "password": password},
      );

      if (response?.statusCode == 200) {




        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>   LoginScreen()),
              (Route<dynamic> route) => false,
        );
        emit(ErrorState("Account Done Please Sign In"));


        emit(SuccessState());
      } else {
        emit(ErrorState('Invalid credentials'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
  Future<void> forgetPassword(BuildContext context, {required String email}) async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.postData(
        path: "/api/Account/forgot-password",
        body: {"email": email },
      );

      if (response?.statusCode == 200) {

        // الانتقال إلى الصفحة الرئيسية وإزالة كل الصفحات السابقة
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>  const HomeScreen()),
              (Route<dynamic> route) => false,
        );
        emit(ErrorState(response?.data));

        emit(SuccessState());
      } else {
        emit(ErrorState('Invalid credentials'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

 Future<List<BranchSchedule>?>getSchedule(int branchId )async{
   emit(LoadingState());
   try {
     final response = await ApiHelper.getData(path: '/api/BranchSchedule/all/$branchId');
     if (response.statusCode == 200) {
       final brnchSchedule = (response.data as List).map((e) => BranchSchedule.fromJson(e)).toList();
       emit(SuccessState());

       return brnchSchedule;

     } else {
       emit(ErrorState('Failed to fetch Schedule'));
     }
   } catch (e) {
     emit(ErrorState(e.toString()));
   }
   return [];

 }
 Future<List<MenuModel>?>getMenu(int branchId )async{
   emit(LoadingState());
   try {
     final response = await ApiHelper.getData(path: '/api/Menu/menu/$branchId');
     if (response.statusCode == 200) {
       final menu = (response.data as List).map((e) => MenuModel.fromJson(e)).toList();
       emit(SuccessState());

       return menu;

     } else {
       emit(ErrorState('Failed to fetch Schedule'));
     }
   } catch (e) {
     emit(ErrorState(e.toString()));
   }
   return [];

 }
  Future<List<MenuModel>?> searchMenu(int branchId, String keyword) async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.getData(path: '/api/Menu/search/$branchId/$keyword');
      if (response.statusCode == 200) {
        final menu = (response.data as List).map((e) => MenuModel.fromJson(e)).toList();
        emit(SuccessState());
        return menu;
      } else {
        emit(ErrorState('Failed to fetch search results'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
    return [];
  }

  Future<List<MenuModel>?> filterMenuByCategory(int branchId, int category) async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.getData(path: '/api/Menu/all-by-category/$branchId/$category');
      if (response.statusCode == 200) {
        final menu = (response.data as List).map((e) => MenuModel.fromJson(e)).toList();
        emit(SuccessState());
        return menu;
      } else {
        emit(ErrorState('Failed to fetch category items'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
    return [];
  }

  Future<List<MenuModel>?> getAvailableMenu(int branchId) async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.getData(path: '/api/Menu/items-available/$branchId');
      if (response.statusCode == 200) {
        final menu = (response.data as List).map((e) => MenuModel.fromJson(e)).toList();
        emit(SuccessState());
        return menu;
      } else {
        emit(ErrorState('Failed to fetch available items'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
    return [];
  }
  Future<List<TablesModel>?> getAllTables(int branchId) async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.getData(path: '/api/Table/all/$branchId');
      if (response.statusCode == 200) {
        final tables = (response.data as List).map((e) => TablesModel.fromJson(e)).toList();
        emit(SuccessState());
        return tables;
      } else {
        emit(ErrorState('Failed to fetch tables'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
    return [];
  }

  Future<List<TablesModel>?> getAvailableTables(int branchId, String date, String mealType) async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.getData(path: '/api/Table/all-available/$branchId/$date/$mealType');
      if (response.statusCode == 200) {
        final availableTables = (response.data as List).map((e) => TablesModel.fromJson(e)).toList();
        emit(SuccessState());
        return availableTables;
      } else {
        emit(ErrorState('Failed to fetch available tables'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
    return [];
  }

  Future<List<TablesModel>?> getReservedTables(int branchId, String date, String mealType) async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.getData(path: '/api/Table/all-reserved/$branchId/$date/$mealType');
      if (response.statusCode == 200) {
        final reservedTables = (response.data as List).map((e) => TablesModel.fromJson(e)).toList();
        emit(SuccessState());
        return reservedTables;
      } else {
        emit(ErrorState('Failed to fetch reserved tables'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
    return [];
  }

  Future<List<Chef>?>getChefs( )async{
    emit(LoadingState());
    try {
      final response = await ApiHelper.getData(path: '/api/Chef/all');
      if (response.statusCode == 200) {
        final chefs = (response.data as List).map((e) => Chef.fromJson(e)).toList();
        emit(SuccessState());

        return chefs;

      } else {
        emit(ErrorState('Failed to fetch Chefs'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
    return [];

  }
  Future<Resturant>getResturant( )async{
    emit(LoadingState());
    try {
      final response = await ApiHelper.getData(path: '/api/Restaurant/1');
      if (response.statusCode == 200) {
        final restaurant = Resturant.fromJson(response.data );
        emit(SuccessState());
        return restaurant;
      } else {
        emit(ErrorState('Failed to fetch reserved tables'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
    return Resturant(rating: 4.50,name: "Our Restaurant",  id: 1,description:  "Welcome To Our Restaurant ",imageUrl: "");
  }
  Future<List<NotificationModel>>getNotifications ()async{
    emit(LoadingState());
    try {
      final response = await ApiHelper.getData(path: '/api/Notification');
      if (response.statusCode == 200) {
        final notifications = (response.data as List).map((e) => NotificationModel.fromJson(e)).toList();
        emit(SuccessState());
        return notifications;
      } else {
        emit(ErrorState('Failed to fetch notifications'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
    return [];
  }
  Future<List <Reservation>> getReservations()async{
    emit(LoadingState());
    try {
      final response = await ApiHelper.getData(path: '/api/Reservation/all-user');
      if (response.statusCode == 200) {
        final reservations = (response.data as List).map((e) => Reservation.fromJson(e)).toList();
        emit(SuccessState());

        return reservations;

      } else {
        emit(ErrorState('Failed to fetch Chefs'));
      }
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
    return [];

  }



}
