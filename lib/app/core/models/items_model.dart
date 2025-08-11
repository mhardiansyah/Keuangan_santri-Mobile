

class Items {
    int id;
    String nama;
    int harga;
    int? kategoriId;
    int jumlah;
    String gambar;
    DateTime createdAt;
    DateTime updatedAt;

    Items({
        required this.id,
        required this.nama,
        required this.harga,
        required this.kategoriId,
        required this.jumlah,
        required this.gambar,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Items.fromJson(Map<String, dynamic> json) => Items(
        id: json["id"],
        nama: json["nama"],
        harga: json["harga"],
        kategoriId: json["kategori_id"],
        jumlah: json["jumlah"],
        gambar: json["gambar"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "harga": harga,
        "kategori_id": kategoriId,
        "jumlah": jumlah,
        "gambar": gambar,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };

}
