import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mini_project/data/session/session.dart';
import 'package:mini_project/modules/auth/login_page.dart';
import 'package:mini_project/utils/app_color.dart';
import 'package:mini_project/utils/app_images.dart';
import 'package:mini_project/utils/constans.dart';
import 'package:mini_project/utils/helpers.dart';
import 'package:mini_project/utils/routes/app_navigator.dart';
import 'package:mini_project/widgets/appbar_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String foto = '', nama = '', tgl_lahir = '';

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  Future getProfile() async {
    nama = (await getPrefrence(NAMA)).toString();
    foto = (await getPrefrence(FOTO)).toString();
    tgl_lahir = (await getPrefrence(TANGGAL)).toString();

    setState(() {});
  }

  void logout() {
    showLoading();
    Future.delayed(
      Duration(seconds: 2),
      () {
        dismissLoading();
        AppNavigator.instance.pushNamedAndRemoveUntil(LoginPage.routeName, (p0) => false);
        clearUserSession();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("Profile", leadingback: false),
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 30, left: 16, right: 16, bottom: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.biru,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(60),
                    bottomLeft: Radius.circular(60),
                  ),
                ),
                child: Column(
                  children: [
                    InkWell(
                      child: CachedNetworkImage(
                        width: 100,
                        height: 100,
                        imageUrl: foto,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 2, color: Colors.grey),
                            color: Colors.red,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                              scale: 0.8,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                        progressIndicatorBuilder: (context, url, progressDownload) {
                          return const Center(child: CupertinoActivityIndicator());
                        },
                        errorWidget: (context, url, error) {
                          return const CircleAvatar(backgroundImage: AssetImage(AppImages.noimage), radius: 50);
                        },
                      ),
                    )
                  ],
                ),
              ),
              Card(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Info Pribadi",
                        style: GoogleFonts.heebo(
                          color: AppColor.hitam,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Expanded(
                            child: Text("Nama Lengkap"),
                          ),
                          Text(nama)
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Expanded(
                            child: Text("Tanggal Lahir"),
                          ),
                          Text(parseDateInd(tgl_lahir, "dd MMMM yyyy"))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: logout,
                child: Card(
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text("Logout"),
                        ),
                        Icon(MdiIcons.logout)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
