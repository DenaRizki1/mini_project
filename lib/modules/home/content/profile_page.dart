import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mini_project/data/apis/api_connect.dart';
import 'package:mini_project/data/apis/end_point.dart';
import 'package:mini_project/data/exceptions/api_error.dart';
import 'package:mini_project/data/session/session.dart';
import 'package:mini_project/modules/auth/login_page.dart';
import 'package:mini_project/utils/app_color.dart';
import 'package:mini_project/utils/app_images.dart';
import 'package:mini_project/utils/configs/api_config.dart';
import 'package:mini_project/utils/constans.dart';
import 'package:mini_project/utils/helpers.dart';
import 'package:mini_project/utils/routes/app_navigator.dart';
import 'package:mini_project/widgets/alert_dialog_ok_widget.dart';
import 'package:mini_project/widgets/appbar_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String foto = '', nama = '', tgl_lahir = '', filePath = '';

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
      const Duration(seconds: 2),
      () {
        dismissLoading();
        AppNavigator.instance.pushNamedAndRemoveUntil(LoginPage.routeName, (p0) => false);
        clearUserSession();
      },
    );
  }

  Future<void> imageSelector(String pickerType) async {
    XFile? imageFile;
    switch (pickerType) {
      case "gallery":
        try {
          imageFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 100);
        } catch (e) {
          PermissionStatus permission = await Permission.storage.status;
          if (permission == PermissionStatus.denied) {
            //? Requesting the permission
            PermissionStatus statusDenied = await Permission.storage.request();
            if (statusDenied.isPermanentlyDenied) {
              //? permission isPermanentlyDenied
              alertOpenSetting;
            }
          }
        }

        break;

      case "camera":
        try {
          imageFile = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 80);
        } catch (e) {
          PermissionStatus permission = await Permission.camera.status;
          if (permission == PermissionStatus.denied) {
            //? Requesting the permission
            PermissionStatus statusDenied = await Permission.camera.request();
            if (statusDenied.isPermanentlyDenied) {
              //? permission isPermanentlyDenied
              alertOpenSetting;
            }
          }
        }

        break;
    }

    if (imageFile != null) {
      log("You selected  image : ${imageFile.path}");
      filePath = imageFile.path;
      uploadProfile();
    } else {
      log("You have not taken image");
    }
  }

  Future uploadProfile() async {
    final network = await isNetworkAvailable();

    if (!network) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialogOkWidget(message: "Tidak ada koneksi internet"),
      );
      return;
    }

    showLoading();

    try {
      final response = await ApiConnect.instance.uploadFile(
        EndPoint.uploadProfile,
        'foto_profile',
        filePath,
        {
          'hash_user': (await getPrefrence(HASH_USER)).toString(),
        },
      );
      dismissLoading();

      if (response != null) {
        if (response['success']) {
          setPrefrence(FOTO, response['data'].toString());
        }
      }
      await getProfile();
      setState(() {});
    } on ApiErrors catch (e) {
      debugPrint(e.message.toString());
      showToast(e.message.toString());
    } catch (e) {
      debugPrint(e.toString());
      showToast("Terjadi kesalahan");
    }
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
                      onTap: () {
                        showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            contentPadding: const EdgeInsets.all(8),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    imageSelector("camera");
                                  },
                                  child: const ListTile(
                                    leading: Icon(Icons.camera),
                                    title: Text("Kamera"),
                                  ),
                                ),
                                const Divider(),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    imageSelector("gallery");
                                  },
                                  child: const ListTile(
                                    leading: Icon(Icons.folder),
                                    title: Text("Galeri"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: foto == ''
                          ? Container(
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(AppImages.noimage),
                                  fit: BoxFit.fill,
                                ),
                                shape: BoxShape.circle,
                              ),
                            )
                          : Container(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    foto,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                    ),
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
