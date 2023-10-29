import 'package:mini_project/modules/auth/daftar_page.dart';
import 'package:mini_project/modules/auth/login_page.dart';
import 'package:mini_project/modules/chat/chat_ai_page.dart';
import 'package:mini_project/modules/filter/rumah_sakit_filter_page.dart';
import 'package:mini_project/modules/home/beranda_page.dart';
import 'package:mini_project/modules/home/content/home_page.dart';
import 'package:mini_project/modules/splashscreen/splashscreen_page.dart';
import 'package:mini_project/modules/tambah_spesialis/tambah_spesialis_page.dart';

class AppRoutes {
  AppRoutes._();

  static const INITIAL = SplashScreenPage.routeName;

  static final routes = {
    SplashScreenPage.routeName: (context) => const SplashScreenPage(),
    BerandaPage.routeName: (context) => const BerandaPage(),
    TambahSpesialisPage.routeName: (context) => const TambahSpesialisPage(),
    LoginPage.routeName: (context) => const LoginPage(),
    DaftarAkunPage.routeName: (context) => const DaftarAkunPage(),
    ChatAiPage.routeName: (context) => const ChatAiPage(),
  };
}
