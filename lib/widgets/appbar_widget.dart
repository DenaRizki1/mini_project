import 'package:animate_do/animate_do.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project/widgets/appbar_leading.dart';

import '../../utils/app_color.dart';

AppBar appBarWidget(String title, {bool leadingback = true, Widget? leading = const AppbarLeading(), List<Widget>? action}) {
  return AppBar(
    elevation: 0,
    leading: leadingback == true ? leading : null,
    actions: action,
    centerTitle: true,
    title: FadeInUp(
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    backgroundColor: AppColor.biru,
  );
}
