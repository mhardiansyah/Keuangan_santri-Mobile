class Items {
  int id;
  String nama;
  int harga;
  String kategori;
  int jumlah;
  String gambar;
  DateTime createdAt;
  DateTime updatedAt;

  Items({
    required this.id,
    required this.nama,
    required this.harga,
    required this.kategori,
    required this.jumlah,
    required this.gambar,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Items.fromJson(Map<String, dynamic> json) => Items(
    id: json["id"] ?? 0,
    nama: json["nama"] ?? '',
    harga: json["harga"] ?? 0,
    kategori: json["kategori"] ?? '',
    jumlah: json["jumlah"] ?? 0,
    gambar: json["gambar"] ?? '',
    createdAt: DateTime.tryParse(json["createdAt"] ?? '') ?? DateTime.now(),
    updatedAt: DateTime.tryParse(json["updatedAt"] ?? '') ?? DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama": nama,
    "harga": harga,
    "kategori": kategori,
    "jumlah": jumlah,
    "gambar": gambar,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
