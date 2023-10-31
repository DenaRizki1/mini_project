import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mini_project/data/session/session.dart';
import 'package:mini_project/modules/auth/login_page.dart';
import 'package:mini_project/modules/home/beranda_page.dart';
import 'package:mini_project/utils/app_images.dart';
import 'package:mini_project/data/constant/constans.dart';
import 'package:mini_project/utils/helpers.dart';
import 'package:mini_project/utils/routes/app_navigator.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});
  static const routeName = '/SplashscreenPage';

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    delaySplash();
    super.initState();
  }

  Future delaySplash() async {
    Future.delayed(
      const Duration(seconds: 5),
      () => init(),
    );
  }

  Future init() async {
    final isLogedIn = await getPrefrenceBool(IS_LOGIN);

    log(isLogedIn.toString());

    if (isLogedIn) {
      AppNavigator.instance.pushNamedAndRemoveUntil(
        BerandaPage.routeName,
        (p0) => false,
      );
    } else {
      AppNavigator.instance.pushNamedAndRemoveUntil(
        LoginPage.routeName,
        (p0) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(AppImages.rumah_sakit1),
                    ),
                  ),
                  const SizedBox(height: 16),
                  loadingWidget()
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "Go Rs",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
              ],
            ),
          )
        ],
      ),
    );
  }
}
