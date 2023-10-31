import 'package:flutter/material.dart';
import 'package:mini_project/data/provider/main_provider.dart';
import 'package:mini_project/utils/helpers.dart';
import 'package:mini_project/widgets/appbar_widget.dart';
import 'package:provider/provider.dart';

class DaftarAkunPage extends StatefulWidget {
  const DaftarAkunPage({super.key});

  static const routeName = '/daftar-akun';

  @override
  State<DaftarAkunPage> createState() => _DaftarAkunPageState();
}

class _DaftarAkunPageState extends State<DaftarAkunPage> {
  TextEditingController namaLengkapEc = TextEditingController();
  TextEditingController usernameEc = TextEditingController();
  TextEditingController passwordEc = TextEditingController();
  TextEditingController konfimasiPasswordEc = TextEditingController();
  DateTime? selectedDate;

  bool obscurePassword = true;
  bool obscureKonfiPassword = true;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("Daftar Akun"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Text(
                          "Nama Lengkap",
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
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: namaLengkapEc,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Nama Lengkap tidak boleh kosong";
                        }
                        return null;
                      },
                      decoration: textFieldDecoration(textHint: "Masukan Nama Lengkap"),
                    ),
                    const SizedBox(height: 12),
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
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: usernameEc,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Username tidak boleh kosong";
                        }
                        return null;
                      },
                      decoration: textFieldDecoration(textHint: "Masukan Username"),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        Text(
                          "Tanggal Lahir",
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
                    const SizedBox(height: 5),
                    TextFormField(
                      onTap: () {
                        showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1700), lastDate: DateTime.now()).then((value) {
                          if (value != null) {
                            setState(() {
                              selectedDate = value;
                            });
                          }
                        });
                      },
                      decoration: textFieldDecoration(textHint: selectedDate == null ? "Pilih Tanggal Lahir" : parseDateInd(selectedDate.toString(), "dd MMMM yyyy")),
                      readOnly: true,
                    ),
                    const SizedBox(height: 12),
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
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: passwordEc,
                      obscureText: obscurePassword,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password tidak boleh kosong";
                        } else if (konfimasiPasswordEc.text != '') {
                          if (konfimasiPasswordEc.text != passwordEc.text) {
                            return "Password tidak sesuai";
                          }
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
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        Text(
                          "Konfirmasi Password",
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
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: konfimasiPasswordEc,
                      obscureText: obscureKonfiPassword,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Konfirmasi Password tidak boleh kosong";
                        } else if (passwordEc.text != '') {
                          if (passwordEc.text != konfimasiPasswordEc.text) {
                            return "Password tidak sesuai";
                          }
                        }

                        return null;
                      },
                      decoration: textFieldDecoration(
                          textHint: "Masukan Konfirmasi Password",
                          suffixIcon: InkWell(
                            onTap: () {
                              obscureKonfiPassword = !obscureKonfiPassword;
                              setState(() {});
                            },
                            child: Icon(!obscureKonfiPassword ? Icons.visibility : Icons.visibility_off),
                          )),
                    ),
                    const SizedBox(height: 12),
                    Consumer<MainProvider>(
                      builder: (context, prov, child) {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                prov.daftar(
                                  namaLengkapEc.text,
                                  usernameEc.text,
                                  passwordEc.text,
                                  parseDateInd(selectedDate.toString(), "yyyy-MM-dd HH:mm:SS"),
                                  context,
                                );
                              }
                            },
                            child: const Text("Daftar"),
                          ),
                        );
                      },
                    ),
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
