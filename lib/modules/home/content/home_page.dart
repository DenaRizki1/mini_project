import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutx/flutx.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mini_project/data/apis/api_connect.dart';
import 'package:mini_project/data/apis/end_point.dart';
import 'package:mini_project/data/enums/api_status.dart';
import 'package:mini_project/data/enums/request_method.dart';
import 'package:mini_project/data/exceptions/api_error.dart';
import 'package:mini_project/models/data_spesialis_model.dart';
import 'package:mini_project/modules/chat/chat_ai_page.dart';
import 'package:mini_project/modules/detail/rumah_sakit_detail_page.dart';
import 'package:mini_project/modules/filter/rumah_sakit_filter_page.dart';
import 'package:mini_project/services/location_services.dart';
import 'package:mini_project/utils/app_color.dart';
import 'package:mini_project/utils/app_images.dart';
import 'package:mini_project/utils/helpers.dart';
import 'package:mini_project/utils/routes/app_navigator.dart';
import 'package:mini_project/utils/routes/app_routes.dart';
import 'package:mini_project/widgets/alert_dialog_ok_widget.dart';
import 'package:mini_project/widgets/appbar_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = 'HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _refreshController = RefreshController(initialRefresh: false);
  List<DataSpesialisModel> listSp = [];
  List dataRs = [];
  ApiStatus _apiStatus = ApiStatus.loading;
  String address = '';
  double latitude = 0.0, longitude = 0.0;
  Position? currentLocation;
  @override
  void initState() {
    getDataRumahSakit();
    getDataSp();

    super.initState();
  }

  Future getDataSp() async {
    listSp.clear();
    final network = await isNetworkAvailable();
    if (!network) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialogOkWidget(message: "Tidak ada koneksi internet"),
      );

      return;
    }
    try {
      if (latitude == 0 && longitude == 0) {
        await getCurrentLocation();
      }

      setState(() {
        _apiStatus = ApiStatus.loading;
      });

      final response = await ApiConnect.instance.request(
        requestMethod: RequestMethod.post,
        url: EndPoint.getSpesialis,
        params: {},
      );

      if (response!['success']) {
        final data = response['data'];
        listSp.addAll((data as List).map((e) => DataSpesialisModel.fromMap(e)));
      }

      log(listSp.length.toString());
    } on ApiErrors catch (e) {
      debugPrint(e.message.toString());

      showToast(e.message.toString());
    } catch (e) {
      debugPrint(e.toString());

      showToast("Terjadi kesalahan");
    }
  }

  Future<void> getDataRumahSakit() async {
    final network = await isNetworkAvailable();
    if (!network) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialogOkWidget(message: "Tidak ada koneksi internet"),
      );

      return;
    }
    try {
      if (latitude == 0 && longitude == 0) {
        await getCurrentLocation();
      }

      setState(() {
        _apiStatus = ApiStatus.loading;
      });

      final response = await ApiConnect.instance.request(
        requestMethod: RequestMethod.post,
        url: EndPoint.getRs,
        params: {
          'lat': latitude.toString(),
          'long': longitude.toString(),
        },
      );

      if (response!['success']) {
        dataRs = response['data'];
        setState(() {
          _apiStatus = ApiStatus.success;
        });
      } else {
        setState(() {
          _apiStatus = ApiStatus.empty;
        });
      }
      if (_refreshController.isRefresh) _refreshController.refreshCompleted();
    } on ApiErrors catch (e) {
      debugPrint(e.message.toString());
      if (_refreshController.isRefresh) _refreshController.refreshCompleted();
      showToast(e.message.toString());
    } catch (e) {
      debugPrint(e.toString());
      if (_refreshController.isRefresh) _refreshController.refreshCompleted();
      showToast("Terjadi kesalahan");
    }
  }

  Future<void> getCurrentLocation() async {
    address = "";
    currentLocation = null;
    currentLocation = await LocationService.instance.getCurrentLocation(context);

    if (currentLocation != null) {
      latitude = currentLocation!.latitude;
      longitude = currentLocation!.longitude;
      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentLocation!.latitude,
        currentLocation!.longitude,
        localeIdentifier: "id_ID",
      );
      if (placemarks.isNotEmpty) {
        Placemark placeMark = placemarks[0];
        address =
            "${placeMark.street}, ${placeMark.subLocality}, ${placeMark.locality}, ${placeMark.subAdministrativeArea}, ${placeMark.administrativeArea}, ${placeMark.country}, ${placeMark.postalCode}";
        log(address);
      } else {
        address = "Lokasi tidak ditemukan";
      }
    } else {
      address = "Koordinat tidak ditemukan";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("Home Page", leadingback: false),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: () async {
          latitude = 0;
          longitude = 0;
          await getDataSp();
          await getDataRumahSakit();
        },
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 130,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColor.biru,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(60),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 30, top: 30),
                      margin: const EdgeInsets.only(top: 15),
                      height: 170,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: AppColor.hijau,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(60),
                          topLeft: Radius.circular(60),
                          bottomRight: Radius.circular(60),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Selamat Datang,",
                            style: GoogleFonts.montserrat(color: Colors.white, fontSize: 25),
                            textAlign: TextAlign.end,
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 220,
                            child: Text(
                              "Ini adalah aplikasi untuk mencari lokasi rumah sakit di sekitar anda",
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.end,
                              maxLines: 3,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.only(left: 5),
                            width: 220,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 15,
                                ),
                                Expanded(
                                  child: Text(
                                    address == '' ? "Sedang Mencari Lokasi" : address,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 116,
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: AppColor.kuning,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            strokeAlign: StrokeAlign.outside,
                            width: 19,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Filter Rumah Sakit",
                        style: GoogleFonts.montserrat(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              // log(listSp[9].namaSpesialis);

                              if (latitude == 0 && longitude == 0) {
                                showDialog(
                                  context: context,
                                  builder: (context) => const AlertDialogOkWidget(message: "Lokasi belum ditemukan"),
                                );
                              } else {
                                AppNavigator.instance.push(MaterialPageRoute(
                                  builder: (context) => RumahSakitFilterPage(
                                    kdSpesialis: listSp[9],
                                    lat: latitude,
                                    long: longitude,
                                  ),
                                ));
                              }
                            },
                            child: Card(
                              margin: const EdgeInsets.only(right: 15),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.asset(AppImages.jantung, height: 50),
                                    const SizedBox(height: 6),
                                    const Text(
                                      "Spesialis \nJantung",
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (latitude == 0 && longitude == 0) {
                                showDialog(
                                  context: context,
                                  builder: (context) => const AlertDialogOkWidget(message: "Lokasi belum ditemukan"),
                                );
                              } else {
                                AppNavigator.instance.push(MaterialPageRoute(
                                  builder: (context) => RumahSakitFilterPage(
                                    kdSpesialis: listSp[0],
                                    lat: latitude,
                                    long: longitude,
                                  ),
                                ));
                              }
                            },
                            child: Card(
                              margin: const EdgeInsets.only(right: 15),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.asset(AppImages.gigi, height: 50),
                                    const SizedBox(height: 6),
                                    const Text(
                                      "Spesialis \nGigi",
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (latitude == 0 && longitude == 0) {
                                showDialog(
                                  context: context,
                                  builder: (context) => const AlertDialogOkWidget(message: "Lokasi belum ditemukan"),
                                );
                              } else {
                                AppNavigator.instance.push(MaterialPageRoute(
                                  builder: (context) => RumahSakitFilterPage(
                                    kdSpesialis: listSp[2],
                                    lat: latitude,
                                    long: longitude,
                                  ),
                                ));
                              }
                            },
                            child: Card(
                              margin: const EdgeInsets.only(right: 15),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.asset(AppImages.anak, height: 50),
                                    const SizedBox(height: 6),
                                    const Text(
                                      "Spesialis \nAnak",
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return FractionallySizedBox(
                                    heightFactor: 0.9,
                                    child: MenuBuilder(),
                                  );
                                },
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.only(right: 15),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.withOpacity(0.6),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.withOpacity(0.6),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.withOpacity(0.6),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.withOpacity(0.6),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      "Lainnya \n",
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "List Rumah Sakit Terdekat",
                        style: GoogleFonts.montserrat(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Builder(
                        builder: (context) {
                          if (_apiStatus == ApiStatus.success) {
                            return ListView.builder(
                              itemCount: dataRs.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    AppNavigator.instance.push(
                                      MaterialPageRoute(
                                        builder: (context) => RumahSakitDetailPage(rumahSakit: dataRs[index]),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.only(top: 10),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        dataRs[index]['image'] == null
                                            ? Container(
                                                height: 125,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  image: const DecorationImage(
                                                    image: AssetImage(AppImages.noimage),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                height: 125,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                        dataRs[index]['image'].toString(),
                                                      ),
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  dataRs[index]['nama_rumah_sakit'],
                                                  style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.bold),
                                                  maxLines: 2,
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  dataRs[index]['alamat'],
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.location_on,
                                                            size: 15,
                                                          ),
                                                          const SizedBox(width: 5),
                                                          Text(dataRs[index]['dist']),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.car_crash,
                                                            size: 15,
                                                          ),
                                                          const SizedBox(width: 5),
                                                          Text(dataRs[index]['estimasi'].toString()),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4)
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else if (_apiStatus == ApiStatus.empty) {
                            return const Center(child: Text("Data tidak ditemukan"));
                          } else if (_apiStatus == ApiStatus.failed) {
                            return const Text("Terjadi Kesalahan");
                          } else {
                            return Center(child: loadingWidget());
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget MenuBuilder() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 10,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listSp.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.9, crossAxisSpacing: 10, mainAxisSpacing: 10),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  if (latitude == 0 && longitude == 0) {
                    showDialog(
                      context: context,
                      builder: (context) => const AlertDialogOkWidget(message: "Lokasi belum ditemukan"),
                    );
                  } else {
                    AppNavigator.instance.pop();
                    AppNavigator.instance.push(MaterialPageRoute(
                      builder: (context) => RumahSakitFilterPage(
                        kdSpesialis: listSp[index],
                        lat: latitude,
                        long: longitude,
                      ),
                    ));
                  }
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.asset(_icon[index], height: 50),
                        const SizedBox(height: 6),
                        Text(
                          listSp[index].namaSpesialis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          const Divider(
            thickness: 2,
          ),
          InkWell(
            onTap: () {
              AppNavigator.instance.pop();
              AppNavigator.instance.pushNamed(ChatAiPage.routeName);
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Image.asset(AppImages.chat, height: 80),
                    const SizedBox(height: 6),
                    const Text(
                      "Chat AI",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final List _icon = [
    AppImages.gigi,
    AppImages.dalam,
    AppImages.anak,
    AppImages.syaraf,
    AppImages.kandungan,
    AppImages.bedah,
    AppImages.kulit,
    AppImages.tht,
    AppImages.mata,
    AppImages.jantung,
  ];
}
