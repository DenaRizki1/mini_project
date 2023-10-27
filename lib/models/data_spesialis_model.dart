// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DataSpesialisModel {
  String idSpesialis = "";
  String kdSpesialis = "";
  String namaSpesialis = "";

  DataSpesialisModel({
    required this.idSpesialis,
    required this.kdSpesialis,
    required this.namaSpesialis,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id_spesialis': idSpesialis,
      'kd_spesialis': kdSpesialis,
      'nama_spesialis': namaSpesialis,
    };
  }

  factory DataSpesialisModel.fromMap(Map<String, dynamic> map) {
    return DataSpesialisModel(
      idSpesialis: map['id_spesialis'] as String,
      kdSpesialis: map['kd_spesialis'] as String,
      namaSpesialis: map['nama_spesialis'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DataSpesialisModel.fromJson(String source) => DataSpesialisModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
