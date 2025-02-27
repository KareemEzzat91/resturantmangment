import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturantmangment/helpers/api_helper/api_helper.dart';
import 'package:resturantmangment/screens/main_screen/main_screen.dart';

import 'helpers/cubit_helper/api_cubit.dart';

void main() {
  ApiHelper.init();
  runApp( const MyApp());
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


class MyApp extends StatelessWidget {
    const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return  BlocProvider(
      create: (BuildContext context) {
        return ApiCubit();
      },
      child: MaterialApp(
        home: const MainScreen(),
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,

      ),
    );
  }
}
