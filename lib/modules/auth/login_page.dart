import 'package:flutter/material.dart';
import 'package:mini_project/data/apis/api_connect.dart';
import 'package:mini_project/data/apis/end_point.dart';
import 'package:mini_project/data/enums/request_method.dart';
import 'package:mini_project/data/exceptions/api_error.dart';
import 'package:mini_project/data/provider/main_provider.dart';
import 'package:mini_project/modules/auth/daftar_page.dart';
import 'package:mini_project/modules/home/beranda_page.dart';
import 'package:mini_project/utils/app_images.dart';
import 'package:mini_project/utils/helpers.dart';
import 'package:mini_project/utils/routes/app_navigator.dart';
import 'package:mini_project/widgets/alert_dialog_ok_widget.dart';
import 'package:mini_project/widgets/appbar_widget.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const routeName = '/login-page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameEc = TextEditingController();
  TextEditingController passwordEc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("Login", leadingback: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            children: [
              Center(
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppImages.rumah_sakit),
                    ),
                  ),
                ),
              ),
              Form(
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Text(
                          "Username",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Visibility(
                          visible: true,
                          child: Text('*', style: TextStyle(color: Colors.red, fontSize: (14 + 2), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: usernameEc,
                      validator: (value) {
                        if (value == null) return "Username tidak boleh kosong";

                        return null;
                      },
                      decoration: textFieldDecoration(
                        textHint: "Masukan Username",
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        Text(
                          "Password",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Visibility(
                          visible: true,
                          child: Text('*', style: TextStyle(color: Colors.red, fontSize: (14 + 2), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: passwordEc,
                      validator: (value) {
                        if (value == null) {
                          return "Password tidak boleh kosong";
                        } else if (value.length < 6) {
                          return "Password harus lebih dari 6";
                        }

                        return null;
                      },
                      decoration: textFieldDecoration(
                        textHint: "Masukan Password",
                      ),
                    ),
                    const SizedBox(height: 10),
                    Consumer<MainProvider>(
                      builder: (context, prov, child) {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              prov.login(usernameEc.text, passwordEc.text, context);
                            },
                            child: const Text("Login"),
                          ),
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text("Belum punya akun?"),
                        const SizedBox(width: 5),
                        InkWell(
                          onTap: () {
                            AppNavigator.instance.pushNamed(DaftarAkunPage.routeName);
                          },
                          child: const Text(
                            "Daftar Sekarang",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
