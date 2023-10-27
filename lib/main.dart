import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mini_project/data/provider/main_provider.dart';
import 'package:mini_project/utils/routes/app_navigator.dart';
import 'package:mini_project/utils/routes/app_routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MainProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Go Rs",
      navigatorKey: AppNavigator.instance.navigatorKey,
      initialRoute: AppRoutes.INITIAL,
      routes: AppRoutes.routes,
      builder: EasyLoading.init(),
    );
  }
}
