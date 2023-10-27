import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mini_project/modules/home/content/home_page.dart';
import 'package:mini_project/modules/home/content/profile_page.dart';
import 'package:mini_project/modules/tambah_spesialis/tambah_spesialis_page.dart';
import 'package:mini_project/utils/app_color.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  static const routeName = 'beranda-page';

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  int selectedIndex = 0;

  static const List<Widget> _listPages = [
    HomePage(),
    ProfilePage(),
  ];

  void onTap(int index) {
    selectedIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listPages[selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        height: 50,
        buttonBackgroundColor: AppColor.biru,
        color: AppColor.hitam,
        items: <Widget>[
          selectedIndex == 0
              ? const Icon(Icons.home, size: 28, color: Color(0xff2E2E2E))
              : Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: const [
                      Icon(Icons.home, size: 24, color: Color(0xffE0AB41)),
                      Text('Beranda', style: TextStyle(color: Color(0xffE0AB41))),
                    ],
                  ),
                ),
          selectedIndex == 1
              ? const Icon(Icons.person, size: 28, color: Color(0xff2E2E2E))
              : Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: const [
                      Icon(Icons.person, size: 24, color: Color(0xffE0AB41)),
                      Text('Profil', style: TextStyle(color: Color(0xffE0AB41))),
                    ],
                  ),
                ),
        ],
        onTap: onTap,
      ),
    );
  }
}
