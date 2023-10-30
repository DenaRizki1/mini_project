import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mini_project/models/open_ai_model.dart';
import 'package:mini_project/services/recommendation.dart';
import 'package:mini_project/utils/app_color.dart';
import 'package:mini_project/utils/helpers.dart';
import 'package:mini_project/widgets/appbar_widget.dart';

class ChatAiPage extends StatefulWidget {
  const ChatAiPage({super.key});

  static const routeName = '/chat-ai';

  @override
  State<ChatAiPage> createState() => _ChatAiPageState();
}

class _ChatAiPageState extends State<ChatAiPage> {
  List<Map<String, dynamic>> chat = [];
  GptData? gptResponse;
  TextEditingController chatEc = TextEditingController();

  @override
  void dispose() {
    chat.clear();
    super.dispose();
  }

  Future getrecommendation(int index) async {
    try {
      Map<String, dynamic> message = {};
      message['pesan'] = "Mengetik...";
      message['pengirim_ai'] = true;
      message['jam'] = "${DateTime.now().hour}:${DateTime.now().minute}";
      chat.add(message);
      final response = await RecommendationService().getrecommendation(chat: chatEc.text);

      gptResponse = response;
      message.clear();
      chat.removeLast();
      message['pesan'] = gptResponse!.choices[0].text.replaceAll('\n', "");
      message['pengirim_ai'] = true;
      message['jam'] = "${DateTime.now().hour}:${DateTime.now().minute}";
      chat.add(message);
      chatEc.clear();
      setState(() {});
    } catch (e) {
      return showToast(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("CHAT AI"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Column(
          children: [
            Expanded(
              child: chat.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: chat.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return chat[index]['pengirim_ai'] ? AiSender(chat[index]) : senderChat(chat[index]);
                      },
                    )
                  : Container(),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: chatEc,
                    decoration: textFieldDecoration(textHint: "Masukan Chat Anda"),
                    maxLines: 10,
                    minLines: 1,
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    if (chatEc.text == '') {
                      return showToast("Tidak dapat mengirim pesan kosong");
                    }

                    Map<String, dynamic> message = {};

                    message['pesan'] = chatEc.text;
                    message['pengirim_ai'] = false;
                    message['jam'] = "12:00";

                    chat.add(message);
                    dismissKeyboard();
                    getrecommendation(chat.length);
                    setState(() {});
                  },
                  child: Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(MdiIcons.send, color: Colors.white),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget senderChat(Map<String, dynamic> chat) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(top: 12, left: 70),
      decoration: BoxDecoration(
        color: Colors.green[600],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              chat['pesan'],
              style: GoogleFonts.heebo(
                color: Colors.white,
              ),
            ),
          ),
          Text(
            chat['jam'],
            style: GoogleFonts.heebo(
              color: Colors.white,
              fontSize: 10,
            ),
          )
        ],
      ),
    );
  }

  Widget AiSender(Map<String, dynamic> chat) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(top: 12, right: 70),
      decoration: BoxDecoration(
        color: AppColor.hitam,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              chat['pesan'],
              style: GoogleFonts.heebo(
                color: Colors.white,
              ),
            ),
          ),
          Text(
            chat['jam'],
            style: GoogleFonts.heebo(
              color: Colors.white,
              fontSize: 10,
            ),
          )
        ],
      ),
    );
  }
}
