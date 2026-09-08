import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturantmangment/helpers/api_helper/api_helper.dart';
import 'package:resturantmangment/screens/main_screen/main_screen.dart';

import 'helpers/cubit_helper/api_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ApiHelper.init();
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ApiCubit(),
      child: MaterialApp(
        title: 'Restaurant Management',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.deepPurple,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const MainScreen(),
      ),
    );
  }
}
