import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:mini_project/data/apis/api_connect.dart';
import 'package:mini_project/data/apis/end_point.dart';
import 'package:mini_project/data/enums/request_method.dart';
import 'package:mini_project/utils/app_color.dart';
import 'package:mini_project/utils/app_images.dart';
import 'package:mini_project/utils/helpers.dart';
import 'package:mini_project/widgets/alert_dialog_ok_widget.dart';
import 'package:mini_project/widgets/appbar_widget.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class RumahSakitDetailPage extends StatefulWidget {
  Map? rumahSakit;
  RumahSakitDetailPage({Key? key, required this.rumahSakit}) : super(key: key);

  @override
  State<RumahSakitDetailPage> createState() => _RumahSakitDetailPageState();
}

class _RumahSakitDetailPageState extends State<RumahSakitDetailPage> {
  Map dataRs = {};
  List dataSp = [];

  @override
  void initState() {
    dataRs = widget.rumahSakit as Map;
    log(dataRs.toString());
    getSpesialis();
    super.initState();
  }

  Future getSpesialis() async {
    try {
      final network = await isNetworkAvailable();

      if (!network) {
        return showDialog(
          context: context,
          builder: (context) => const AlertDialogOkWidget(message: "Tidak ada koneksi internet"),
        );
      }

      final response = await ApiConnect.instance.request(
        requestMethod: RequestMethod.post,
        url: EndPoint.getDetailSpesialis,
        params: {
          'kd_rumah_sakit': dataRs['kd_rumah_sakit'],
        },
      );
      if (response!['success']) {
        dataSp = response['data'];
        setState(() {});
      }
      log(dataSp.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("Rumah Sakit Detail"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            dataRs['image'] == null
                ? Container(
                    width: double.infinity,
                    height: 200,
                    decoration: const BoxDecoration(
                      // color: Colors.amber,
                      image: DecorationImage(
                        image: AssetImage(AppImages.noimage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      // color: Colors.amber,
                      image: DecorationImage(
                        image: NetworkImage(
                          dataRs['image'],
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            const SizedBox(height: 10),
            Card(
              margin: const EdgeInsets.only(top: 12, left: 16, right: 16),
              color: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          AppImages.rumah_sakit,
                          width: 40,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          dataRs['nama_rumah_sakit'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 1),
                    const SizedBox(height: 8),
                    itemDetail(true, "Alamat", dataRs['alamat']),
                    itemDetail(false, "Jumlah Spesialis", dataSp.length.toString()),
                    const SizedBox(height: 8),
                    Visibility(
                      visible: dataRs['hotline'] != "",
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.biru,
                          ),
                          onPressed: () async {
                            launchUrl(Uri.parse('tel:${dataRs['hotline']}'));
                          },
                          child: const Text("Telephone Hotline"),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: dataRs['emergency'] != "",
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () async {
                            launchUrl(Uri.parse('tel:${dataRs['emergency']}'));
                          },
                          child: const Text("Telephone Emergency"),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: dataRs['customer_service'] != "",
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.hijau,
                          ),
                          onPressed: () async {
                            launchUrl(Uri.parse('tel:${dataRs['customer_service']}'));
                          },
                          child: const Text("Telephone Layanan"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.only(top: 12, left: 16, right: 16),
              color: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          AppImages.rumah_sakit,
                          width: 40,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Daftar Spesialis",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 1),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: dataSp.length,
                      itemBuilder: (context, index) {
                        return itemDetail(false, dataSp[index], "");
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.only(top: 12, left: 16, right: 16),
              color: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          AppImages.rumah_sakit,
                          width: 40,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Lokasi Map",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColor.hitam,
                      ),
                      padding: const EdgeInsets.all(1),
                      width: double.infinity,
                      height: 240,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: GoogleMap(
                          scrollGesturesEnabled: false,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              safetyParseDouble(dataRs['latitude'].toString()),
                              safetyParseDouble(dataRs['longitude'].toString()),
                            ),
                            zoom: 15,
                          ),
                          markers: {
                            Marker(
                              markerId: const MarkerId('1'),
                              position: LatLng(
                                safetyParseDouble(dataRs['latitude'].toString()),
                                safetyParseDouble(dataRs['longitude'].toString()),
                              ),
                            ),
                          },
                          onMapCreated: (GoogleMapController controller) {},
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          String lat = dataRs['latitude'].toString();
                          String lng = dataRs['longitude'].toString();

                          final availableMaps = await MapLauncher.installedMaps;
                          if (availableMaps.isEmpty) {
                            openUrl("'https://www.google.com/maps/search/?api=1&query=$lat,$lng'");
                          } else {
                            await availableMaps.first.showMarker(
                              coords: Coords(safetyParseDouble(lat), safetyParseDouble(lng)),
                              title: dataRs['nama_rumah_sakit'].toString(),
                            );
                          }
                        },
                        child: const Text('Lihat Lokasi Map'),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
