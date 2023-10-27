import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/animation/animation_controller.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:mini_project/data/apis/api_connect.dart';
import 'package:mini_project/data/apis/end_point.dart';
import 'package:mini_project/data/enums/request_method.dart';
import 'package:mini_project/utils/helpers.dart';
import 'package:mini_project/widgets/alert_dialog_ok_widget.dart';
import 'package:mini_project/widgets/appbar_widget.dart';

class TambahSpesialisPage extends StatefulWidget {
  const TambahSpesialisPage({super.key});

  static const routeName = 'TambahSpesialis';

  @override
  State<TambahSpesialisPage> createState() => _TambahSpesialisPageState();
}

class _TambahSpesialisPageState extends State<TambahSpesialisPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  List listDataSpesialis = [];
  Map selectedSpesialis = {};
  List selectedDataSpesialis = [];
  List listDataRs = [];
  Map selectedRs = {};

  @override
  void initState() {
    super.initState();
    getData();
    getRs();
    _controller = AnimationController(vsync: this);
  }

  Future getData() async {
    final netowrk = await isNetworkAvailable();

    if (!netowrk) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogOkWidget(message: "Tidak ada koneksi internet"),
      );
      return;
    }

    showLoading();

    final response = await ApiConnect.instance.request(
      requestMethod: RequestMethod.post,
      url: EndPoint.getSpesialis,
      params: {},
    );
    dismissLoading();

    if (response != null) {
      if (response['success']) {
        // log(response['data'].toString());
        listDataSpesialis.addAll(response['data']);
      }
    }
    log("===================================");
    log(listDataSpesialis.toString());
    setState(() {});
  }

  Future getRs() async {
    final netowrk = await isNetworkAvailable();

    if (!netowrk) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogOkWidget(message: "Tidak ada koneksi internet"),
      );
      return;
    }

    showLoading();

    final response = await ApiConnect.instance.request(
      requestMethod: RequestMethod.post,
      url: EndPoint.getAllRs,
      params: {},
    );
    dismissLoading();

    if (response != null) {
      if (response['success']) {
        // log(response['data'].toString());
        listDataRs.addAll(response['data']);
      }
    }

    setState(() {});
  }

  Future addData() async {
    final network = await isNetworkAvailable();

    if (!network) {
      showDialog(
        context: context,
        builder: (context) => AlertDialogOkWidget(message: "Tidak ada koneksi internet"),
      );
      return;
    }

    // log(jsonEncode(listDataSpesialis));

    final response = await ApiConnect.instance.request(
      requestMethod: RequestMethod.post,
      url: EndPoint.addRumahSakitSpesialis,
      params: {
        'kd_rumah_sakit': selectedRs['kd_rumah_sakit'],
        'data_spesialis': jsonEncode(selectedDataSpesialis),
      },
    );

    if (response != null) {
      if (response['success']) {
        selectedSpesialis.clear();
        selectedDataSpesialis.clear();
        selectedRs.clear();
        listDataSpesialis.clear();
        listDataRs.clear();
        getData();
        getRs();
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("Tambah Spesialis"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  borderRadius: BorderRadius.circular(12),
                  hint: selectedRs.isEmpty ? const Text("Pilih Jenis Izin") : Text(selectedRs['nama_rumah_sakit'].toString()),
                  items: listDataRs.map(
                    (val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(val['nama_rumah_sakit'].toString()),
                      );
                    },
                  ).toList(),
                  isExpanded: true,
                  dropdownColor: Colors.white,
                  onChanged: (val) {
                    log(val.toString());

                    selectedRs = val as Map;
                    setState(() {});
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  borderRadius: BorderRadius.circular(12),
                  hint: selectedSpesialis.isEmpty ? const Text("Pilih Jenis Izin") : Text(selectedSpesialis['nama_spesialis'].toString()),
                  items: listDataSpesialis.map(
                    (val) {
                      return DropdownMenuItem(
                        value: val,
                        child: Text(val['nama_spesialis'].toString()),
                      );
                    },
                  ).toList(),
                  isExpanded: true,
                  dropdownColor: Colors.white,
                  onChanged: (val) {
                    log(val.toString());

                    selectedSpesialis = val as Map;
                    listDataSpesialis.remove(val);
                    log(listDataSpesialis.toString());
                    selectedDataSpesialis.add(selectedSpesialis);
                    // selectedSpesialis.clear();
                    setState(() {});
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            selectedDataSpesialis.isNotEmpty
                ? Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("List Selected Spesialis"),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: selectedDataSpesialis.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          selectedRs['nama_rumah_sakit'],
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(selectedDataSpesialis[index]['nama_spesialis']),
                                      ],
                                    )),
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          log(selectedDataSpesialis[index].toString());
                                          listDataSpesialis.add(selectedDataSpesialis[index]);
                                          selectedDataSpesialis.removeAt(index);

                                          setState(() {});
                                          // setState(() {
                                          //   data.removeAt(index);
                                          //   listData.add(data[index]);
                                          // });
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )
                : Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  addData();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.green,
                ),
                child: Text("Submit"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
