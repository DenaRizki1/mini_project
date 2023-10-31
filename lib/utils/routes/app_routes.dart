import 'package:mini_project/modules/auth/daftar_page.dart';
import 'package:mini_project/modules/auth/login_page.dart';
import 'package:mini_project/modules/chat/chat_ai_page.dart';
import 'package:mini_project/modules/home/beranda_page.dart';
import 'package:mini_project/modules/splashscreen/splashscreen_page.dart';

class AppRoutes {
  AppRoutes._();

  // ignore: constant_identifier_names
  static const INITIAL = SplashScreenPage.routeName;

  static final routes = {
    SplashScreenPage.routeName: (context) => const SplashScreenPage(),
    BerandaPage.routeName: (context) => const BerandaPage(),
    LoginPage.routeName: (context) => const LoginPage(),
    DaftarAkunPage.routeName: (context) => const DaftarAkunPage(),
    ChatAiPage.routeName: (context) => const ChatAiPage(),
  };
}
