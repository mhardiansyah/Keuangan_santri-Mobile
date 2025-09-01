class Kategori {
  final int id;
  final String nama;
    //   DateTime createdAt;
    // DateTime updatedAt;

  Kategori({required this.id, required this.nama,
      // required this.createdAt,
      // required this.updatedAt,
      });

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      id: json['id'],
      nama: json['nama'],
      // createdAt: DateTime.parse(json['created_at']),
      // updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
