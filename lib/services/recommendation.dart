import 'dart:convert';
import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:mini_project/data/apis/end_point.dart';
import 'package:mini_project/data/constant/open_ai.dart';
import 'package:mini_project/models/open_ai_model.dart';
import 'package:http/http.dart' as http;
import 'package:mini_project/modules/auth/login_page.dart';

class RecommendationService {
  Future<GptData> getrecommendation({
    required String chat,
  }) async {
    late GptData gptData = GptData(
      id: "",
      object: "",
      created: 0,
      model: "",
      choices: [],
      usage: Usage(completionTokens: 0, promptTokens: 0, totalTokens: 0),
    );

    try {
      var url = EndPoint.openAiChat;

      Map<String, String> headers = {
        'Content-type': 'application/json;charset=UTF-8',
        'Charset': 'utf-8',
        'Authorization': 'Bearer $apiKey',
      };

      // String promptdata = "${chat} di daerah jakarta";
      String promptdata = "${chat} di jakarta";

      // String promptdata = "you are a smartphone expert. Please give me a recommendation from budget equals to $smartPhoneBudget with camera requirement $camera and Internal storage size $storage";

      final data = jsonEncode({
        "model": "text-davinci-003",
        "prompt": promptdata,
        "temperature": 0.4,
        "max_tokens": 64,
        "top_p": 1,
        "frequency_penalty": 0,
        "presence_penalty": 0,
      });

      var response = await http.post(Uri.parse(url), headers: headers, body: data);

      if (response.statusCode == 200) {
        log(response.body.toString());
        gptData = gptDataFromJson(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
    return gptData;
  }
}
