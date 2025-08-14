import 'dart:convert';

Santri santriFromJson(String str) => Santri.fromJson(json.decode(str));
class Santri {
    int id;
    String name;
    String kelas;
    int saldo;
    int hutang;
    DateTime createdAt;
    DateTime updatedAt;
    Kartu kartu;

    Santri({
        required this.id,
        required this.name,
        required this.kelas,
        required this.saldo,
        required this.hutang,
        required this.createdAt,
        required this.updatedAt,
        required this.kartu,
    });

    factory Santri.fromJson(Map<String, dynamic> json) => Santri(
        id: json["id"],
        name: json["name"],
        kelas: json["kelas"],
        saldo: json["saldo"],
        hutang: json["hutang"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        kartu: Kartu.fromJson(json["kartu"]),
    );

}

class Kartu {
    int id;
    String nomorKartu;
    DateTime createdAt;
    DateTime updatedAt;

    Kartu({
        required this.id,
        required this.nomorKartu,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Kartu.fromJson(Map<String, dynamic> json) => Kartu(
        id: json["id"],
        nomorKartu: json["nomor_kartu"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

}
