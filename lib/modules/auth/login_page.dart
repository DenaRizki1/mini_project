import 'package:flutter/material.dart';
import 'package:mini_project/data/provider/main_provider.dart';
import 'package:mini_project/modules/auth/daftar_page.dart';
import 'package:mini_project/utils/app_images.dart';
import 'package:mini_project/utils/helpers.dart';
import 'package:mini_project/utils/routes/app_navigator.dart';
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

  bool obscurePassword = true;

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
                      obscureText: obscurePassword,
                      validator: (value) {
                        if (value == null) {
                          return "Password tidak boleh kosong";
                        }

                        return null;
                      },
                      decoration: textFieldDecoration(
                        textHint: "Masukan Password",
                        suffixIcon: InkWell(
                          onTap: () {
                            obscurePassword = !obscurePassword;
                            setState(() {});
                          },
                          child: Icon(!obscurePassword ? Icons.visibility : Icons.visibility_off),
                        ),
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
