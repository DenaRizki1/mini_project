import 'dart:developer';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutx/flutx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mini_project/utils/app_color.dart';
import 'package:mini_project/utils/routes/app_navigator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:url_launcher/url_launcher_string.dart';

String parseDateInd(String? input, String format) {
  //? exp format 'EEE dd MMMM yyyy HH:mm'
  try {
    initializeDateFormatting();
    if (input!.isEmpty || input == "-") {
      return "-";
    } else {
      final dateTime = DateTime.parse(input);
      final dateIndo = DateFormat(format, "id_ID").format(dateTime);
      return dateIndo;
    }
  } catch (e) {
    return input?.toString() ?? "-";
  }
}

String currencyInd(String input, {bool symbol = true}) {
  try {
    final currencyFormatter = NumberFormat('###,###,###,###', 'ID');
    if (symbol) {
      return "Rp ${currencyFormatter.format(double.parse(input))}";
    } else {
      return currencyFormatter.format(double.parse(input));
    }
  } catch (e) {
    return input;
  }
}

double safetyParseDouble(String input) {
  try {
    return double.tryParse(input) ?? 0.0;
  } catch (e) {
    log(e.toString());
    return 0.0;
  }
}

int safetyParseInt(String input) {
  try {
    return int.tryParse(input.replaceAll(".", "")) ?? 0;
  } catch (e) {
    log(e.toString());
    return 0;
  }
}

DateTime safetyParseDatetime(String input) {
  try {
    return DateTime.parse(input);
  } catch (e) {
    return DateTime.now();
  }
}

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
  );
}

void showDialogOpenGps(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FxText.titleLarge(
            "Informasi",
            fontWeight: 600,
            color: Colors.black,
          ),
          const Divider(),
          const SizedBox(height: 10),
          const Text('Aplikasi membutuhkan akses GPS, aktifkan sekarang?'),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => AppNavigator.instance.pop(),
          child: const Text('Tidak'),
        ),
        ElevatedButton(
          onPressed: () async {
            AppNavigator.instance.pop();
            await Geolocator.openLocationSettings();
          },
          child: const Text('Ya'),
        ),
      ],
    ),
  );
}

void showDialogOpenSettingLocationPermission(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FxText.titleLarge(
            "Informasi",
            fontWeight: 600,
            color: Colors.black,
          ),
          const Divider(),
          const SizedBox(height: 10),
          const Text('Aplikasi membutuhkan izin akses lokasi, aktifkan sekarang?'),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => AppNavigator.instance.pop(),
          child: const Text('Tidak'),
        ),
        ElevatedButton(
          onPressed: () async {
            AppNavigator.instance.pop();
            await Geolocator.openAppSettings();
          },
          child: const Text('Ya'),
        ),
      ],
    ),
  );
}

alertOpenSetting(BuildContext context, {String message = "Aplikasi memerlukan beberapa izin untuk dapat berjalan dengan baik. Apakah anda ingin mengaktifkannya?"}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FxText.titleLarge(
            "Perhatian1",
            fontWeight: 600,
            color: Colors.black,
          ),
          const Divider(),
          const SizedBox(height: 10),
          Text(message),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => AppNavigator.instance.pop(),
          child: const Text('Tidak'),
        ),
        ElevatedButton(
          onPressed: () async {
            AppNavigator.instance.pop();
            await openAppSettings();
          },
          child: const Text('Ya'),
        ),
      ],
    ),
  );
}

Widget loadingWidget({double size = 24, Color? color}) {
  return Center(
    child: LoadingAnimationWidget.inkDrop(
      color: color ?? AppColor.biru2,
      size: size,
    ),
  );
}

Widget emptyWidget(String text, {double size = 15, Color color = Colors.black}) {
  return Center(
    child: Text(
      text,
      style: GoogleFonts.montserrat(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

Future<void> showLoading({String message = "Tunggu sebentar...", bool dismissOnTap = true}) async {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..textColor = AppColor.biru
    ..loadingStyle = EasyLoadingStyle.custom //This was missing in earlier code
    ..indicatorColor = Colors.transparent
    ..backgroundColor = Colors.black54
    ..boxShadow = <BoxShadow>[]
    ..indicatorWidget = LoadingAnimationWidget.inkDrop(
      color: AppColor.biru,
      size: 40,
    );
  await EasyLoading.show(status: message, maskType: EasyLoadingMaskType.black, dismissOnTap: dismissOnTap);
}

Future<void> dismissLoading() async {
  if (EasyLoading.isShow) {
    await EasyLoading.dismiss();
  } else {
    return;
  }
}

void dismissKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

InputDecoration textFieldDecoration({String textHint = "", Widget? prefixIcon, Widget? suffixIcon, String? suffixText}) {
  double paddingVertical = 12;
  if (prefixIcon != null || suffixIcon != null) {
    paddingVertical = 0;
  }

  return InputDecoration(
    hintText: textHint,
    suffixText: suffixText,
    hintStyle: const TextStyle(
      color: Colors.black,
      fontSize: 12,
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(12),
      ),
      borderSide: BorderSide(
        color: Colors.grey.shade300,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(12),
      ),
      borderSide: BorderSide(
        color: Colors.grey.shade300,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(12),
      ),
      borderSide: BorderSide(
        color: AppColor.biru,
      ),
    ),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: Colors.grey.shade300,
    isDense: true,
    contentPadding: EdgeInsets.symmetric(vertical: paddingVertical, horizontal: 10),
  );
}

Future<bool> isNetworkAvailable() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

Future<bool> openUrl(String? url, {LaunchMode launchMode = LaunchMode.externalApplication}) async {
  if (url != null) {
    if (await canLaunchUrlString(url)) {
      return await launchUrlString(
        url,
        mode: launchMode,
      );
    } else {
      showToast("Tidak dapat membuka $url");
      return false;
    }
  } else {
    showToast("Url tidak valid");
    return false;
  }
}

Widget itemDetail(bool isColor, String title, String value, {bool textRight = true}) {
  return Container(
    color: isColor ? AppColor.biru.withAlpha(50) : Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 13,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 1,
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: textRight ? TextAlign.right : TextAlign.right,
          ),
        ),
      ],
    ),
  );
}
