import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mini_project/data/apis/api_connect.dart';
import 'package:mini_project/data/apis/end_point.dart';
import 'package:mini_project/data/session/session.dart';
import 'package:mini_project/widgets/alert_dialog_ok_widget.dart';
import 'package:mini_project/widgets/appbar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PickerPage extends StatefulWidget {
  const PickerPage({super.key});

  @override
  State<PickerPage> createState() => _PickerPageState();
}

class _PickerPageState extends State<PickerPage> {
  List<String> filedata = [];
  String? data = "";

  bool isPlaying = false;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  final audioPlayer = AudioPlayer();

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  playAudio() async {
    // await audioPlayer.setReleaseMode(ReleaseMode.loop);

    // final player = AudioPlayer();

    // player.setSourceDeviceFile(fileMusic.path);
  }

  getData() async {
    final pref = await SharedPreferences.getInstance();

    final data = pref.getStringList('listData');

    log(data.toString());
  }

  clearData() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.remove('listData');
  }

  Future upload() async {
    final pref = await SharedPreferences.getInstance();

    pref.setStringList("listData", filedata);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget("Picker"),
        body: Column(
          children: [
            Expanded(
              child: data == ""
                  ? Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          width: double.infinity,
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Positioned(
                          top: 140,
                          left: MediaQuery.of(context).size.width * .4,
                          child: InkWell(
                            onTap: () async {
                              FilePickerResult? file = await FilePicker.platform.pickFiles();

                              filedata.add(file!.files.first.path ?? "");
                              data = file.files.first.path ?? "";
                              setState(() {});
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              // color: Colors.amber,
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.add,
                                    color: Colors.blue,
                                  ),
                                  Text("Tambah"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      margin: const EdgeInsets.all(10),
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Slider(
                            min: 0,
                            max: duration.inSeconds.toDouble(),
                            value: position.inSeconds.toDouble(),
                            onChanged: (value) {},
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (isPlaying) {
                                await audioPlayer.pause();
                                setState(() {
                                  isPlaying = false;
                                });
                              } else {
                                final fileMusic = File(data!);
                                await audioPlayer.play(DeviceFileSource(fileMusic.path));
                                setState(() {
                                  isPlaying = true;
                                });
                              }

                              setState(() {});
                            },
                            child: Icon(isPlaying == false ? Icons.play_arrow : Icons.pause),
                          ),
                        ],
                      ),
                    ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  clearData();
                },
                child: Text("Clear"),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  upload();
                },
                child: Text("Kirim"),
              ),
            )
          ],
        ));
  }
}
