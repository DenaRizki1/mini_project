import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mini_project/utils/helpers.dart';
import 'package:mini_project/widgets/appbar_widget.dart';

class DaftarAkunPage extends StatefulWidget {
  const DaftarAkunPage({super.key});

  static const routeName = '/daftar-akun';

  @override
  State<DaftarAkunPage> createState() => _DaftarAkunPageState();
}

class _DaftarAkunPageState extends State<DaftarAkunPage> {
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
                      decoration: textFieldDecoration(textHint: "Masukan Tanggal Lahir"),
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
                      decoration: textFieldDecoration(textHint: "Masukan Password"),
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
                      decoration: textFieldDecoration(textHint: "Masukan Konfirmasi Password"),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("Daftar"),
                      ),
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
