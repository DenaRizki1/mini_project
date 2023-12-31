import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart';
import 'package:mini_project/utils/configs/api_config.dart';
import 'package:mini_project/data/enums/request_method.dart';
import 'package:mini_project/utils/helpers.dart';

class ApiConnect {
  static final ApiConnect instance = ApiConnect._();

  ApiConnect._();

  static Map<String, String> headers = <String, String>{"authorization": getBasicAuth()};

  late Completer<Map<String, dynamic>?> _completer;
  late Timer _timer;

  void cancelOperation() {
    _timer.cancel();
    if (_completer.isCompleted == false) {
      _completer.complete(null);
    }
  }

  Future<Map<String, dynamic>?> request({RequestMethod requestMethod = RequestMethod.get, required String url, required Map<String, String> params}) async {
    try {
      log("==================================================");
      log(url);
      log(params.toString());

      late Response response;

      if (requestMethod == RequestMethod.post) {
        response = await post(
          Uri.parse(url),
          headers: ApiConnect.headers,
          body: params,
        );
      } else {
        response = await get(
          Uri.parse(url),
          headers: ApiConnect.headers,
        );
      }

      log(response.body.toString());

      final body = jsonDecode(response.body);

      return body;
    } on SocketException {
      showToast("Tidak ada koneksi internet");
      Future.error("Tidak ada koneksi internet");
    } catch (e) {
      log(e.toString());
      showToast("Terjadi kesalahan");
      Future.error("Terjadi kesalahan");
    }
    return null;
  }

  Future<Map<String, dynamic>?> uploadFile(String url, String keyFile, String filePath, Map<String, String> params) async {
    try {
      final request = MultipartRequest("POST", Uri.parse(url));

      request.headers.addAll(headers);
      request.fields.addAll(params);
      request.files.add(await MultipartFile.fromPath(keyFile, filePath));

      final streameResponse = await request.send();

      final response = await Response.fromStream(streameResponse);

      log("==================================================");
      log(url);
      log(params.toString());
      log(response.body);

      final result = jsonDecode(response.body);

      return result;
    } on SocketException {
      showToast("Tidak ada koneksi internet");
      Future.error("Tidak ada koneksi internet");
    } catch (e) {
      log(e.toString());
      showToast("Terjadi kesalahan");
      Future.error("Terjadi kesalahan");
    }
    return null;
  }
}
