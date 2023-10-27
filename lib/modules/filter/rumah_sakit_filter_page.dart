import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mini_project/data/apis/api_connect.dart';
import 'package:mini_project/data/apis/end_point.dart';
import 'package:mini_project/data/enums/api_status.dart';
import 'package:mini_project/data/enums/request_method.dart';
import 'package:mini_project/models/data_spesialis_model.dart';
import 'package:mini_project/modules/detail/rumah_sakit_detail_page.dart';
import 'package:mini_project/modules/home/content/home_page.dart';
import 'package:mini_project/services/location_services.dart';
import 'package:mini_project/utils/app_color.dart';
import 'package:mini_project/utils/app_images.dart';
import 'package:mini_project/utils/helpers.dart';
import 'package:mini_project/utils/routes/app_navigator.dart';
import 'package:mini_project/widgets/alert_dialog_ok_widget.dart';
import 'package:mini_project/widgets/appbar_widget.dart';

class RumahSakitFilterPage extends StatefulWidget {
  DataSpesialisModel kdSpesialis;
  double? lat;
  double? long;

  RumahSakitFilterPage({Key? key, required this.kdSpesialis, required this.lat, required this.long}) : super(key: key);

  @override
  State<RumahSakitFilterPage> createState() => _RumahSakitFilterPageState();
}

class _RumahSakitFilterPageState extends State<RumahSakitFilterPage> {
  final radiusEc = TextEditingController();
  DataSpesialisModel? kdSp;
  ApiStatus _apiStatus = ApiStatus.loading;
  List listData = [];
  double latitude = 0.0, longitude = 0.0;
  String radius = "";
  bool changeRadius = false;
  @override
  void initState() {
    kdSp = widget.kdSpesialis;
    latitude = widget.lat ?? 0;
    longitude = widget.long ?? 0;
    getData();
    super.initState();
  }

  Future getData() async {
    try {
      setState(() {
        listData.clear();
      });

      final network = await isNetworkAvailable();

      if (!network) {
        showDialog(
          context: context,
          builder: (context) => AlertDialogOkWidget(message: "Tidak ada koneksi internet"),
        );
        return null;
      }

      final response = await ApiConnect.instance.request(
        requestMethod: RequestMethod.post,
        url: EndPoint.filterRumahSakit,
        params: {
          'kd_spesialis': kdSp!.kdSpesialis,
          'lat': latitude.toString(),
          'long': longitude.toString(),
          'radius_km': radiusEc.text,
        },
      );

      if (response!['success']) {
        listData = response['data'];
        getRadius(response['radius']);
        setState(() {
          _apiStatus = ApiStatus.success;
        });
      } else {
        setState(() {
          getRadius(response['radius']);
          _apiStatus = ApiStatus.empty;
        });
      }

      log(listData.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  void getRadius(String value) {
    radius = (safetyParseInt(value)).toString().replaceAll(".0", "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("Filter Rumah Sakit"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Rumah Sakit ${kdSp?.namaSpesialis}",
                style: GoogleFonts.montserrat(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Divider(
                thickness: 2,
                color: Colors.black,
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  setState(() {
                    changeRadius = true;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Radius ${radius} Km",
                    style: GoogleFonts.montserrat(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Visibility(
                visible: changeRadius,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: radiusEc,
                        decoration: textFieldDecoration(textHint: "Masukan Radius", suffixText: "Km"),
                      ),
                    ),
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: () {
                        radius = radiusEc.text;
                        getData();
                        changeRadius = false;
                      },
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: AppColor.hijau,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          MdiIcons.send,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Builder(
                builder: (context) {
                  if (_apiStatus == ApiStatus.success) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: listData.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            AppNavigator.instance.push(MaterialPageRoute(
                              builder: (context) => RumahSakitDetailPage(rumahSakit: listData[index]),
                            ));
                          },
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Card(
                              margin: const EdgeInsets.only(top: 10),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  listData[index]['image'] == null
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
                                                  listData[index]['image'].toString(),
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
                                            listData[index]['nama_rumah_sakit'],
                                            style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.bold),
                                            maxLines: 2,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            listData[index]['alamat'],
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                size: 15,
                                              ),
                                              Text(listData[index]['dist']),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (_apiStatus == ApiStatus.empty) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * .8,
                      child: Center(child: Text("Tidak ada rumah sakit ${kdSp?.namaSpesialis} disekitar anda")),
                    );
                  } else if (_apiStatus == ApiStatus.failed) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * .8,
                      child: Center(child: Text("Terjadi Kesalahan")),
                    );
                  } else {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * .8,
                      child: Center(
                        child: loadingWidget(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
