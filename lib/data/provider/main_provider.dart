import 'package:flutter/material.dart';
import 'package:mini_project/data/apis/api_connect.dart';
import 'package:mini_project/data/apis/end_point.dart';
import 'package:mini_project/data/enums/request_method.dart';
import 'package:mini_project/data/exceptions/api_error.dart';
import 'package:mini_project/data/session/session.dart';
import 'package:mini_project/modules/auth/login_page.dart';
import 'package:mini_project/modules/home/beranda_page.dart';
import 'package:mini_project/data/constant/constans.dart';
import 'package:mini_project/utils/helpers.dart';
import 'package:mini_project/utils/routes/app_navigator.dart';
import 'package:mini_project/widgets/alert_dialog_ok_widget.dart';

class MainProvider with ChangeNotifier {
  Future<void> login(String username, String password, BuildContext context) async {
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
      final response = await ApiConnect.instance.request(
        requestMethod: RequestMethod.post,
        url: EndPoint.loginAuth,
        params: {
          'username': username,
          'password': password,
        },
      );

      dismissLoading();

      if (response != null) {
        if (response['success']) {
          final data = response['data'];

          setPrefrenceBool(IS_LOGIN, true);
          setPrefrence(HASH_USER, data['hash_user']).toString();
          setPrefrence(TOKEN_AUTH, data['token_auth'].toString());
          setPrefrence(NAMA, data['nama_lengkap'].toString());
          setPrefrence(FOTO, data['foto'].toString());
          setPrefrence(USERNAME, data['username'].toString());
          setPrefrence(TANGGAL, data['tgl_lahir']).toString();

          AppNavigator.instance.pushNamedAndRemoveUntil(BerandaPage.routeName, (p0) => false);
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialogOkWidget(message: response['message'].toString()),
          );
        }
      }
    } on ApiErrors catch (e) {
      debugPrint(e.message.toString());
      showDialog(
        context: context,
        builder: (context) => AlertDialogOkWidget(message: e.message),
      );
    } catch (e) {
      debugPrint(e.toString());

      showDialog(
        context: context,
        builder: (context) => const AlertDialogOkWidget(message: "Terjadi kesalahan"),
      );
    }
  }

  Future<void> daftar(String namaLengkap, String username, String password, String tglLahir, BuildContext context) async {
    final network = await isNetworkAvailable();

    if (!network) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialogOkWidget(message: "Tidak ada koneksi internet"),
      );
      return;
    }

    try {
      showLoading();
      final response = await ApiConnect.instance.request(
        requestMethod: RequestMethod.post,
        url: EndPoint.daftarAkun,
        params: {
          'nama_lengkap': namaLengkap,
          'username': username,
          'password': password,
          'tgl_lahir': tglLahir,
        },
      );

      dismissLoading();

      if (response != null) {
        if (response['success']) {
          showDialog(
            context: context,
            builder: (context) => const AlertDialogOkWidget(message: "Berhasil Daftar"),
          ).then((value) {
            AppNavigator.instance.pushNamed(LoginPage.routeName);
          });
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialogOkWidget(message: response['message'].toString()),
          );
        }
      }
    } on ApiErrors catch (e) {
      debugPrint(e.message.toString());

      showToast(e.message.toString());
    } catch (e) {
      debugPrint(e.toString());

      showToast("Terjadi kesalahan");
    }
  }
}
